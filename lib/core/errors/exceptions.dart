import 'package:dash_todo_app/core/errors/failure.dart';

class AccountExistsWithDifferentCredentialException implements Exception {}

class InvalidCredentialException implements Exception {}

class LoginWithEmailException implements Exception {}

class GoogleSignInException implements Exception {}

class DataBaseException implements Exception {
  DataBaseException({required this.message});

  final String message;
}

class LoginWithEmailFailure implements Failure {
  LoginWithEmailFailure({required this.message});

  final String message;
}

class WeekPasswordException implements Exception {
  WeekPasswordException({required this.message});

  final String message;
}

class EmailAlreadyInUseException implements Exception {
  EmailAlreadyInUseException({required this.message});

  final String message;
}
