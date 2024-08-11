part of "../chat.usecase_module.dart";

class InsertLocalPrivateChatMessageUseCase {
  final PrivateChatMessageRepository _repository;

  InsertLocalPrivateChatMessageUseCase(this._repository);

  Future<ResponseWrapper<void>> call(PrivateChatMessageEntity entity) async {
    return await _repository.insertOnLocalDB(entity);
  }
}
