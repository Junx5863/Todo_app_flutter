part of 'social_auth_bloc.dart';

enum SocialAuthStatus {
  initial,
  loading,
  success,
  error,
}

class SocialAuthState {
  SocialAuthState({
    required this.status,
    required this.errorTitle,
    required this.errorMessage,
    required this.emailTextEditingController,
    required this.passwordTextEditingController,
    required this.emailTextEditingControllerRegister,
    required this.passwordTextEditingControllerRegister,
  });

  factory SocialAuthState.initial() => SocialAuthState(
        status: SocialAuthStatus.initial,
        errorTitle: '',
        errorMessage: '',
        emailTextEditingController: TextEditingController(),
        passwordTextEditingController: TextEditingController(),
        passwordTextEditingControllerRegister: TextEditingController(),
        emailTextEditingControllerRegister: TextEditingController(),
      );

  //Definicion de los estados
  final SocialAuthStatus status;
  final String errorTitle;
  final String errorMessage;
  final TextEditingController emailTextEditingController;
  final TextEditingController passwordTextEditingController;
  final TextEditingController emailTextEditingControllerRegister;
  final TextEditingController passwordTextEditingControllerRegister;

  SocialAuthState copyWith({
    SocialAuthStatus? status,
    String? errorTitle,
    String? errorMessage,
    TextEditingController? emailTextEditingController,
    TextEditingController? passwordTextEditingController,
    TextEditingController? passwordTextEditingControllerRegister,
    TextEditingController? emailTextEditingControllerRegister,
  }) {
    return SocialAuthState(
      status: status ?? this.status,
      errorTitle: errorTitle ?? this.errorTitle,
      errorMessage: errorMessage ?? this.errorMessage,
      emailTextEditingController:
          emailTextEditingController ?? this.emailTextEditingController,
      passwordTextEditingController:
          passwordTextEditingController ?? this.passwordTextEditingController,
      passwordTextEditingControllerRegister:
          passwordTextEditingControllerRegister ??
              this.passwordTextEditingControllerRegister,
      emailTextEditingControllerRegister: emailTextEditingControllerRegister ??
          this.emailTextEditingControllerRegister,
    );
  }
}
