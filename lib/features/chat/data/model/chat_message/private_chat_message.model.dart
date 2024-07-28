import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portfolio/features/chat/domain/entity/private_chat_message.entity.dart';

part 'private_chat_message.model.freezed.dart';

part 'private_chat_message.model.g.dart';

@freezed
class PrivateChatMessageModel with _$PrivateChatMessageModel {
  const factory PrivateChatMessageModel(
      {@Default('') String id,
      @Default('') String chat_id, // 유저 id를 연결를 _로 연결한 문자열
      @Default('') String sender,
      @Default('') String receiver,
      @Default('') String content,
      DateTime? created_at}) = _PrivateChatMessageModel;

  factory PrivateChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$PrivateChatMessageModelFromJson(json);

  factory PrivateChatMessageModel.fromEntity(PrivateChatMessageEntity entity) =>
      PrivateChatMessageModel(
          id: entity.id ?? "",
          chat_id: entity.chatId ?? "",
          sender: entity.sender?.id ?? "",
          receiver: entity.receiver?.id ?? "",
          content: entity.content ?? "",
          created_at: entity.createdAt);
}
