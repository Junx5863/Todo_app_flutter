import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'social_auth_state.dart';

class SocialAuthBloc extends Cubit<SocialAuthState> {
  SocialAuthBloc() : super(SocialAuthState.initial());

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
