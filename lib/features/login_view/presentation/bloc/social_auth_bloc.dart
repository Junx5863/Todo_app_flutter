import 'package:dash_todo_app/core/errors/exceptions.dart';
import 'package:dash_todo_app/core/errors/failure.dart';
import 'package:dash_todo_app/features/login_view/domain/usecases/create_user_use_case.dart';
import 'package:dash_todo_app/features/login_view/domain/usecases/sign_in_email_password_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'social_auth_state.dart';

class SocialAuthBloc extends Cubit<SocialAuthState> {
  SocialAuthBloc({
    required SignInEmailPasswordUseCase signInEmailPasswordUseCase,
    required CreateEmailPasswordUseCase createEmailPasswordUseCase,
  })  : _signInEmailPasswordUseCase = signInEmailPasswordUseCase,
        _createEmailPasswordUseCase = createEmailPasswordUseCase,
        super(SocialAuthState.initial());

  final SignInEmailPasswordUseCase _signInEmailPasswordUseCase;
  final CreateEmailPasswordUseCase _createEmailPasswordUseCase;

  void singInWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    emit(state.copyWith(
      status: SocialAuthStatus.loading,
    ));
    final result = await _signInEmailPasswordUseCase(
      SignInEmailPasswordParams(
        email: email,
        password: password,
      ),
    );
    result.fold((dynamic fail) {
      if (fail is AccountExistsWithDifferentCredentialFailure) {
        emit(state.copyWith(
          status: SocialAuthStatus.error,
          errorTitle: 'Account Exists With Different Credential',
          errorMessage:
              'The account already exists with a different credential.',
        ));
      } else if (fail is InvalidCredentialFailure) {
        emit(state.copyWith(
          status: SocialAuthStatus.error,
          errorTitle: 'Invalid Credential',
          errorMessage: 'The credential is invalid or has expired.',
        ));
      } else if (fail is LoginWithEmailFailure) {
        emit(state.copyWith(
          status: SocialAuthStatus.error,
          errorTitle: 'Login Failed',
          errorMessage: 'Login failed. Please try again.',
        ));
      }
    }, (User? response) {
      emit(state.copyWith(
        status: SocialAuthStatus.success,
      ));
    });
  }

  void createUserWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    emit(state.copyWith(
      status: SocialAuthStatus.loading,
    ));
    final result = await _createEmailPasswordUseCase(
      CreateEmailPasswordParams(
        email: email,
        password: password,
      ),
    );

    result.fold(
      (dynamic failure) {
        if (failure is WeekPasswordFailure) {
          emit(state.copyWith(
            status: SocialAuthStatus.error,
            errorTitle: 'Weak Password',
            errorMessage:
                'The password provided is too weak. It must be at least 6 characters long.',
          ));
        } else if (failure is EmailAlreadyInUseFailure) {
          emit(state.copyWith(
            status: SocialAuthStatus.error,
            errorTitle: 'Email Already In Use',
            errorMessage:
                'The email address is already in use by another account.',
          ));
        } else if (failure is InvalidEmailFailure) {
          emit(state.copyWith(
            status: SocialAuthStatus.error,
            errorTitle: 'Invalid Email',
            errorMessage: 'The email address is badly formatted or invalid.',
          ));
        } else {
          emit(state.copyWith(
            status: SocialAuthStatus.error,
            errorTitle: 'Unexpected Error',
            errorMessage:
                'An unexpected error occurred. Please try again later.',
          ));
        }
      },
      (User? response) {
        emit(state.copyWith(
          status: SocialAuthStatus.initial,
        ));
      },
    );
  }
}
