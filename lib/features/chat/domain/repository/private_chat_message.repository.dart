part of 'package:portfolio/features/chat/data/repository_impl/private_chat_message.repository_impl.dart';

abstract class PrivateChatMessageRepository {
  Future<ResponseWrapper<void>> createChatMessage(
      {required String content, required String receiver});

  Future<ResponseWrapper<void>> deleteMessageById(String messageId);

  Future<ResponseWrapper<List<PrivateChatMessageEntity>>> fetchLastMessages(
      DateTime afterAt);

  Future<ResponseWrapper<List<PrivateChatMessageEntity>>> fetchMessages(
      {required DateTime beforeAt,
      required String receiver,
      int take = 20,
      bool ascending = true});

  RealtimeChannel getMessageChannel({
    required String currentUid,
    void Function(PrivateChatMessageEntity newRecord)? onInsert,
    void Function(PrivateChatMessageEntity oldRecord,
            PrivateChatMessageEntity newRecord)?
        onUpdate,
    void Function(PrivateChatMessageEntity oldRecord)? onDelete,
  });
}