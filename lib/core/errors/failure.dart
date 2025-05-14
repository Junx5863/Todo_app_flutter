abstract class Failure {}

class AccountExistsWithDifferentCredentialFailure extends Failure {
  AccountExistsWithDifferentCredentialFailure({required this.message});

  final String message;
}

class InvalidCredentialFailure extends Failure {
  InvalidCredentialFailure({required this.message});

  final String message;
}

class ResetPasswordFailure extends Failure {
  ResetPasswordFailure({required this.message});

  final String message;
}
