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

class EmailAlreadyInUseFailure extends Failure {
  EmailAlreadyInUseFailure({required this.message});

  final String message;
}

class WeekPasswordFailure extends Failure {
  WeekPasswordFailure({required this.message});

  final String message;
}

class InvalidEmailFailure extends Failure {
  InvalidEmailFailure({required this.message});

  final String message;
}
