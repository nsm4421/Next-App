part of "../impl/private_chat_message.local_datasource_impl.dart";

abstract interface class PrivateChatMessageLocalDataSource
    implements BaseLocalDataSource<LocalPrivateChatMessageModel> {
  Future<DateTime> getMaxCreatedAt();

  Future<Iterable<LocalPrivateChatMessageModel>> fetchLatestMessages(
      {int take = 20});

  Future<Iterable<LocalPrivateChatMessageModel>> fetch(
      {required String chatId,
      required DateTime beforeAt,
      int take = 20,
      bool ascending = false});

  Future<void> save(LocalPrivateChatMessageModel model);

  Future<void> saveAll(Iterable<LocalPrivateChatMessageModel> messages);

  Future<void> deleteById(String messageId);
}
