import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:portfolio/features/chat/data/datasource/chat_message/chat_message.datasource.dart';
import 'package:portfolio/features/chat/data/model/chat_message/private_chat_message.model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../main/core/constant/response_wrapper.dart';
import '../../domain/entity/private_chat_message.entity.dart';

part 'package:portfolio/features/chat/domain/repository/private_chat_message.repository.dart';

@LazySingleton(as: PrivateChatMessageRepository)
class PrivateChatMessageRepositoryImpl implements PrivateChatMessageRepository {
  final PrivateChatMessageDataSource _dataSource;
  final _logger = Logger();

  PrivateChatMessageRepositoryImpl(this._dataSource);

  @override
  Future<ResponseWrapper<void>> createChatMessage(
      {required String content, required String receiver}) async {
    try {
      return await _dataSource
          .createChatMessage(
              PrivateChatMessageModel(content: content, receiver: receiver))
          .then(ResponseWrapper.success);
    } on PostgrestException catch (error) {
      _logger.e(error);
      return ResponseWrapper.error(error.message);
    } catch (error) {
      _logger.e(error);
      return ResponseWrapper.error('create message fails');
    }
  }

  @override
  Future<ResponseWrapper<void>> deleteMessageById(String messageId) async {
    try {
      return await _dataSource
          .deleteChatMessageById(messageId)
          .then(ResponseWrapper.success);
    } on PostgrestException catch (error) {
      _logger.e(error);
      return ResponseWrapper.error(error.message);
    } catch (error) {
      _logger.e(error);
      return ResponseWrapper.error('delete message fails');
    }
  }

  @override
  Future<ResponseWrapper<List<PrivateChatMessageEntity>>> fetchLastMessages(
      DateTime afterAt) async {
    try {
      return await _dataSource
          .fetchLastMessages(afterAt)
          .then(
              (res) => res.map(PrivateChatMessageEntity.fromRpcModel).toList())
          .then(ResponseWrapper.success);
    } on PostgrestException catch (error) {
      _logger.e(error);
      return ResponseWrapper.error(error.message);
    } catch (error) {
      _logger.e(error);
      return ResponseWrapper.error('fetch message fails');
    }
  }

  @override
  Future<ResponseWrapper<List<PrivateChatMessageEntity>>> fetchMessages(
      {required DateTime beforeAt,
      required String receiver,
      int take = 20,
      bool ascending = true}) async {
    try {
      return await _dataSource
          .fetchMessages(
              beforeAt: beforeAt,
              receiver: receiver,
              take: take,
              ascending: ascending)
          .then((res) =>
              res.map(PrivateChatMessageEntity.fromWithUserModel).toList())
          .then(ResponseWrapper.success);
    } on PostgrestException catch (error) {
      _logger.e(error);
      return ResponseWrapper.error(error.message);
    } catch (error) {
      _logger.e(error);
      return ResponseWrapper.error('fetch message fails');
    }
  }

  @override
  RealtimeChannel getMessageChannel(
      {required String currentUid,
      void Function(PrivateChatMessageEntity newRecord)? onInsert,
      void Function(PrivateChatMessageEntity oldRecord,
              PrivateChatMessageEntity newRecord)?
          onUpdate,
      void Function(PrivateChatMessageEntity oldRecord)? onDelete}) {
    return _dataSource.getMessageChannel(
      key: "private_chat_message:$currentUid",
      onInsert: onInsert == null
          ? null
          : (PrivateChatMessageModel newModel) {
              onInsert(PrivateChatMessageEntity.fromModel(newModel));
            },
      onUpdate: onUpdate == null
          ? null
          : (PrivateChatMessageModel oldModel,
              PrivateChatMessageModel newModel) {
              onUpdate(PrivateChatMessageEntity.fromModel(oldModel),
                  PrivateChatMessageEntity.fromModel(newModel));
            },
      onDelete: onDelete == null
          ? null
          : (PrivateChatMessageModel oldModel) {
              onDelete(PrivateChatMessageEntity.fromModel(oldModel));
            },
    );
  }
}