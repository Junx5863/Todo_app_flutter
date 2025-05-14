part of 'social_auth_bloc.dart';

class SocialAuthState {
  SocialAuthState({
    required this.emailLoginTextEditingController,
    required this.passwordLoginTextEditingController,
  });

  factory SocialAuthState.initial() => SocialAuthState(
        emailLoginTextEditingController: TextEditingController(),
        passwordLoginTextEditingController: TextEditingController(),
      );

  //Definicion de los estados
  final TextEditingController emailLoginTextEditingController;
  final TextEditingController passwordLoginTextEditingController;

  SocialAuthState copyWith({
    TextEditingController? emailLoginTextEditingController,
    TextEditingController? passwordLoginTextEditingController,
  }) {
    return SocialAuthState(
      emailLoginTextEditingController: emailLoginTextEditingController ??
          this.emailLoginTextEditingController,
      passwordLoginTextEditingController: passwordLoginTextEditingController ??
          this.passwordLoginTextEditingController,
    );
  }
}
