import 'dart:io';

import 'package:logger/logger.dart';
import 'package:portfolio/data/datasource/base/base.datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constant/supabase_constant.dart';
import '../../../model/feed/feed/feed.model.dart';
import '../../../model/feed/feed/feed_model_for_rpc.model.dart';

part "../abstract/feed.datasource.dart";

class FeedDataSourceImpl implements FeedDataSource {
  final SupabaseClient _client;
  final Logger _logger;

  FeedDataSourceImpl({required SupabaseClient client, required Logger logger})
      : _client = client,
        _logger = logger;

  @override
  String get tableName => TableName.feed.name;

  @override
  FeedModel audit(FeedModel model) {
    return model.copyWith(
        id: model.id.isNotEmpty ? model.id : const Uuid().v4(),
        created_by: model.created_by.isNotEmpty
            ? model.created_by
            : _client.auth.currentUser!.id,
        created_at: model.created_at ?? DateTime.now().toUtc());
  }

  @override
  Future<FeedModel> createFeed(FeedModel model) async {
    final audited = audit(model);
    return await _client.rest
        .from(tableName)
        .insert(audited.toJson())
        .then((_) => audited);
  }

  @override
  Future<void> modifyFeed(
      {required String feedId,
      String? content,
      List<String>? media,
      List<String>? hashtags}) async {
    await _client.rest.from(tableName).update({
      if (content != null) "content": content,
      if (media != null) "media": media,
      if (hashtags != null) "hashtags": hashtags
    }).eq("id", feedId);
  }

  @override
  Future<void> deleteFeedById(String feedId) async {
    await _client.rest.from(tableName).delete().eq("id", feedId);
  }

  @override
  Future<Iterable<FeedModelForRpc>> fetchFeeds(
      {required DateTime beforeAt, int take = 20}) async {
    return await _client
        .rpc<List<Map<String, dynamic>>>(RpcName.fetchFeeds.name, params: {
      "before_at": beforeAt.toIso8601String(),
      'take': take
    }).then((res) => res.map(FeedModelForRpc.fromJson));
  }

  @override
  Future<Iterable<String>> uploadMedia(
      {required String feedId, required Iterable<File> files}) async {
    return Future.wait(files.map((file) async {
      final bytes = await file.readAsBytes();
      final fileName = "$feedId/${const Uuid().v4()}";
      return await _client.storage
          .from(BucketName.feed.name)
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          )
          .then((_) => _client.storage
              .from(BucketName.feed.name)
              .getPublicUrl(fileName));
    }));
  }
}
