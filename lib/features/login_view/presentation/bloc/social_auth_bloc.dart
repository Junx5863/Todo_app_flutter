import 'package:dash_todo_app/features/login_view/domain/usecases/sign_in_email_password_use_case.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'social_auth_state.dart';

class SocialAuthBloc extends Cubit<SocialAuthState> {
  SocialAuthBloc({
    required SignInEmailPasswordUseCase signInEmailPasswordUseCase,
  })  : _signInEmailPasswordUseCase = signInEmailPasswordUseCase,
        super(SocialAuthState.initial());

  final SignInEmailPasswordUseCase _signInEmailPasswordUseCase;

  /* void signInWithGoogle() {
    emit(SocialAuthLoading());
    // Simulate a network call
    Future.delayed(const Duration(seconds: 2), () {
      emit(SocialAuthSuccess());
    });
  }

  void signInWithFacebook() {
    emit(SocialAuthLoading());
    // Simulate a network call
    Future.delayed(const Duration(seconds: 2), () {
      emit(SocialAuthSuccess());
    });
  }

  void signInWithApple() {
    emit(SocialAuthLoading());
    // Simulate a network call
    Future.delayed(const Duration(seconds: 2), () {
      emit(SocialAuthSuccess());
    });
  } */
}
