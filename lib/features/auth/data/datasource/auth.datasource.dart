part of "auth.datasource_impl.dart";

abstract interface class AuthDataSource {
  User? get currentUser;

  Stream<AuthState> get authStream;

  Future<User?> signUpWithEmailAndPassword(String email, String password);

  Future<User?> signInWithEmailAndPassword(String email, String password);

  Future<void> signOut();

  Future<void> insertAccount(AccountModel account);

  Future<User?> updateMetaData({String? nickname, String? profileImage});

  Future<void> updateAccount(
      {required String uid, String? nickname, String? profileImage});
}
