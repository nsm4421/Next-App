import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_comment.model.freezed.dart';

part 'feed_comment.model.g.dart';

@freezed
class FeedCommentModel with _$FeedCommentModel {
  const factory FeedCommentModel({
    @Default('') String id,
    @Default('') String feed_id,
    @Default('') String content,
    @Default('') String created_by,
    DateTime? created_at,
  }) = _FeedCommentModel;

  factory FeedCommentModel.fromJson(Map<String, dynamic> json) =>
      _$FeedCommentModelFromJson(json);
}
