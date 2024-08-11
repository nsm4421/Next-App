import 'package:injectable/injectable.dart';
import 'package:portfolio/data/datasource/local/chat/impl/private_chat_message.local_datasource_impl.dart';
import 'package:portfolio/data/model/chat/private_chat_message/local_private_chat_message.model.dart';
import 'package:portfolio/domain/entity/auth/presence.entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constant/response_wrapper.dart';
import '../../../core/util/exception.util.dart';
import '../../../domain/entity/chat/private_chat_message.entity.dart';
import '../../datasource/remote/auth/abstract/auth.remote_datasource.dart';
import '../../datasource/remote/chat/impl/private_chat_message.remote_datasource_impl.dart';
import '../../model/chat/private_chat_message/private_chat_message.model.dart';

part '../../../domain/repository/chat/private_chat_message.repository.dart';

@LazySingleton(as: PrivateChatMessageRepository)
class PrivateChatMessageRepositoryImpl implements PrivateChatMessageRepository {
  final AuthRemoteDataSource _authDataSource;
  final PrivateChatMessageRemoteDataSource _messageRemoteDataSource;
  final PrivateChatMessageLocalDataSource _messageLocalDataSource;

  PrivateChatMessageRepositoryImpl({
    required AuthRemoteDataSource authDataSource,
    required PrivateChatMessageRemoteDataSource messageDataSource,
    required PrivateChatMessageLocalDataSource messageLocalDataSource,
  })  : _authDataSource = authDataSource,
        _messageRemoteDataSource = messageDataSource,
        _messageLocalDataSource = messageLocalDataSource;

  PresenceEntity get currentUser =>
      PresenceEntity.fromUser(_authDataSource.currentUser!);

  @override
  Future<ResponseWrapper<void>> sendMessage(
      {required String content, required String receiver}) async {
    try {
      return await _messageRemoteDataSource
          .sendMessage(
              PrivateChatMessageModel(content: content, receiver: receiver))
          .then(ResponseWrapper.success);
    } catch (error) {
      throw CustomException.from(error);
    }
  }

  /// 메세지 삭제
  @override
  Future<ResponseWrapper<void>> deleteMessageById(String messageId) async {
    try {
      await _messageRemoteDataSource.deleteById(messageId);
      await _messageLocalDataSource.deleteById(messageId);
      return ResponseWrapper.success(null);
    } catch (error) {
      throw CustomException.from(error);
    }
  }

  /// 최근 메시지 조회
  @override
  Future<ResponseWrapper<List<PrivateChatMessageEntity>>>
      fetchLastMessages() async {
    try {
      // 최신 메세지 조회
      final afterAt = await _messageLocalDataSource.getMaxCreatedAt();
      final dataFromRemote = await _messageRemoteDataSource
          .fetchLastMessages(afterAt)
          .then((res) => res.map((e) => PrivateChatMessageEntity.fromRpcModel(e,
              currentUid: currentUser.id!)));
      // 로컬 DB에 저장
      await _messageLocalDataSource.saveAll(dataFromRemote.map((entity) =>
          LocalPrivateChatMessageModel.fromEntity(entity,
              currentUser: currentUser)));
      // 로컬 DB 조회
      return await _messageLocalDataSource
          .fetchLatestMessages()
          .then((res) => res
              .map((item) => PrivateChatMessageEntity.fromLocalModel(item,
                  currentUid: currentUser.id!))
              .toList())
          .then(ResponseWrapper.success);
    } catch (error) {
      throw CustomException.from(error);
    }
  }

  @override
  Future<ResponseWrapper<List<PrivateChatMessageEntity>>> fetchMessages(
      {required DateTime beforeAt,
      required String chatId,
      int take = 20,
      bool ascending = true}) async {
    try {
      return await _messageLocalDataSource
          .fetch(chatId: chatId, beforeAt: beforeAt, take: take)
          .then((res) => res
              .map((e) => PrivateChatMessageEntity.fromLocalModel(e,
                  currentUid: currentUser.id!))
              .toList())
          .then(ResponseWrapper.success);
    } catch (error) {
      throw CustomException.from(error);
    }
  }

  @override
  Future<ResponseWrapper<void>> insertOnLocalDB(
      PrivateChatMessageEntity entity) async {
    try {
      return await _messageLocalDataSource
          .save(LocalPrivateChatMessageModel.fromEntity(entity,
              currentUser: currentUser))
          .then(ResponseWrapper.success);
    } catch (error) {
      throw CustomException.from(error);
    }
  }

  @override
  RealtimeChannel getConversationChannel(
      {required String chatId,
      void Function(PrivateChatMessageEntity newRecord)? onInsert,
      void Function(PrivateChatMessageEntity oldRecord,
              PrivateChatMessageEntity newRecord)?
          onUpdate,
      void Function(PrivateChatMessageEntity oldRecord)? onDelete}) {
    try {
      return _getMessageChannel(
          key: "conversation-channel:$chatId",
          onInsert: onInsert,
          onUpdate: onUpdate,
          onDelete: onDelete);
    } catch (error) {
      throw CustomException.from(error);
    }
  }

  @override
  RealtimeChannel getLastChatChannel(
      {void Function(PrivateChatMessageEntity newRecord)? onInsert,
      void Function(PrivateChatMessageEntity oldRecord,
              PrivateChatMessageEntity newRecord)?
          onUpdate,
      void Function(PrivateChatMessageEntity oldRecord)? onDelete}) {
    try {
      return _getMessageChannel(
          key: "last-message-channel:${const Uuid().v4()}",
          onInsert: onInsert,
          onUpdate: onUpdate,
          onDelete: onDelete);
    } catch (error) {
      throw CustomException.from(error);
    }
  }

  RealtimeChannel _getMessageChannel(
      {required String key,
      void Function(PrivateChatMessageEntity newRecord)? onInsert,
      void Function(PrivateChatMessageEntity oldRecord,
              PrivateChatMessageEntity newRecord)?
          onUpdate,
      void Function(PrivateChatMessageEntity oldRecord)? onDelete}) {
    return _messageRemoteDataSource.getMessageChannel(
        key: key,
        onInsert: onInsert == null
            ? null
            : (PrivateChatMessageModel newModel) {
                onInsert(PrivateChatMessageEntity.fromModel(newModel,
                    currentUid: currentUser.id!));
              },
        onUpdate: onUpdate == null
            ? null
            : (PrivateChatMessageModel oldModel,
                PrivateChatMessageModel newModel) {
                onUpdate(
                    PrivateChatMessageEntity.fromModel(oldModel,
                        currentUid: currentUser.id!),
                    PrivateChatMessageEntity.fromModel(newModel,
                        currentUid: currentUser.id!));
              },
        onDelete: onDelete == null
            ? null
            : (PrivateChatMessageModel oldModel) {
                onDelete(PrivateChatMessageEntity.fromModel(oldModel,
                        currentUid: currentUser.id!)
                    .copyWith(isRemoved: true));
              });
  }
}
