import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:portfolio/features/auth/data/repository_impl/auth.repository_impl.dart';
import 'package:portfolio/features/auth/domain/entity/account.entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../main/core/constant/response_wrapper.dart';



part "edit_profile.usecase.dart";

part "get_current_user.usecase.dart";

part "get_auth_stream.usecase.dart";

part 'sign_up_with_email_and_password.usecase.dart';

part "sign_in_with_email_and_password.usecase.dart";

part "sign_out.usecase.dart";

@lazySingleton
class AuthUseCase {
  final AuthRepository _repository;

  AuthUseCase(this._repository);

  @injectable
  GetCurrentUserUseCase get currentUser => GetCurrentUserUseCase(_repository);

  @injectable
  GetAuthStreamUseCase get authStream => GetAuthStreamUseCase(_repository);

  @injectable
  SignUpWithEmailAndPasswordUseCase get signUpWithEmailAndPassword =>
      SignUpWithEmailAndPasswordUseCase(_repository);

  @injectable
  SignInWithEmailAndPasswordUseCase get signInWithEmailAndPassword =>
      SignInWithEmailAndPasswordUseCase(_repository);

  @injectable
  EditProfileUseCase get editProfile => EditProfileUseCase(_repository);

  @injectable
  SignOutUseCase get signOut => SignOutUseCase(_repository);
}