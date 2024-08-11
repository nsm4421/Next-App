import '../../../base/remote_datasource.dart';

abstract interface class ChatMessageRemoteDataSource<T>
    implements BaseRemoteDataSource<T> {
  Future<T> sendMessage(T model);

  Future<void> deleteById(String messageId);
}
