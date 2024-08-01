import 'package:logger/logger.dart';
import 'package:portfolio/features/main/data/datasource/base.datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../main/core/constant/supabase_constant.dart';
import '../../model/comment/feed_comment.model.dart';
import '../../model/comment/feed_comment_for_rpc.model.dart';

part "feed_comment.datasource.dart";

class FeedCommentDataSourceImpl implements FeedCommentDataSource {
  final SupabaseClient _client;
  final Logger _logger;

  FeedCommentDataSourceImpl(
      {required SupabaseClient client, required Logger logger})
      : _client = client,
        _logger = logger;

  @override
  String get tableName => TableName.feedComment.name;

  @override
  FeedCommentModel audit(FeedCommentModel model) {
    return model.copyWith(
        id: model.id.isNotEmpty ? model.id : const Uuid().v4(),
        created_by: model.created_by.isNotEmpty
            ? model.created_by
            : _client.auth.currentUser!.id,
        created_at: model.created_at ?? DateTime.now().toUtc());
  }

  @override
  Future<void> createComment(FeedCommentModel model) async {
    await _client.rest.from(tableName).insert(audit(model).toJson());
  }

  @override
  Future<void> deleteCommentById(String commentId) async {
    await _client.rest.from(tableName).delete().eq("id", commentId);
  }

  @override
  Future<Iterable<FeedCommentModelForRpc>> fetchComments(
      {required DateTime beforeAt,
      required String feedId,
      int take = 20,
      bool ascending = true}) {
    // TODO: implement fetchComments
    throw UnimplementedError();
  }
}