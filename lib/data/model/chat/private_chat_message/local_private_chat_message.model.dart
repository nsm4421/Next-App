import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portfolio/domain/entity/auth/presence.entity.dart';
import 'package:portfolio/domain/entity/chat/private_chat_message.entity.dart';

import 'private_chat_message.model.dart';

part 'local_private_chat_message.model.freezed.dart';

part 'local_private_chat_message.model.g.dart';

@freezed
class LocalPrivateChatMessageModel with _$LocalPrivateChatMessageModel {
  const factory LocalPrivateChatMessageModel({
    @Default('') String id,
    @Default('') String chat_id,
    @Default('') String sender_uid,
    @Default('') String sender_nickname,
    @Default('') String sender_profile_image,
    @Default('') String receiver_uid,
    @Default('') String receiver_nickname,
    @Default('') String receiver_profile_image,
    @Default('') String content,
    DateTime? created_at,
    @Default(false) bool is_deleted,
  }) = _LocalPrivateChatMessageModel;

  factory LocalPrivateChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$LocalPrivateChatMessageModelFromJson(json);

  factory LocalPrivateChatMessageModel.fromModel(PrivateChatMessageModel model,
          {required PresenceEntity sender,
          required PresenceEntity receiver,
          bool isDeleted = false}) =>
      LocalPrivateChatMessageModel(
        id: model.id,
        chat_id: model.chat_id ?? "",
        sender_uid: sender.id!,
        sender_nickname: sender.nickname!,
        sender_profile_image: sender.profileImage!,
        receiver_uid: receiver.id!,
        receiver_nickname: receiver.nickname!,
        receiver_profile_image: receiver.profileImage!,
        content: model.content ?? "",
        created_at: model.created_at?.toUtc(),
        is_deleted: isDeleted,
      );

  factory LocalPrivateChatMessageModel.fromEntity(
          PrivateChatMessageEntity entity,
          {required PresenceEntity currentUser}) =>
      LocalPrivateChatMessageModel(
        id: entity.id ?? "",
        chat_id: entity.chatId ?? "",
        sender_uid: entity.isSender! ? currentUser.id! : entity.opponent!.id!,
        sender_nickname: entity.isSender!
            ? currentUser.nickname!
            : entity.opponent!.nickname!,
        sender_profile_image: entity.isSender!
            ? currentUser.profileImage!
            : entity.opponent!.profileImage!,
        receiver_uid: entity.isSender! ? entity.opponent!.id! : currentUser.id!,
        receiver_nickname: entity.isSender!
            ? entity.opponent!.nickname!
            : currentUser.nickname!,
        receiver_profile_image: entity.isSender!
            ? entity.opponent!.profileImage!
            : currentUser.profileImage!,
        content: entity.content ?? "",
        created_at: entity.createdAt?.toUtc(),
        is_deleted: false,
      );
}
