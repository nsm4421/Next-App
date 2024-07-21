import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:portfolio/core/response/status.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth.state.freezed.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState({
    @Default(Status.initial) Status status,
    User? user,
    String? message,
  }) = _AuthenticationState;
}
