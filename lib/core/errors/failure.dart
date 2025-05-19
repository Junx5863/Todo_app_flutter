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

/* TaskFailure */

class AddTaskFailure extends Failure {
  AddTaskFailure({required this.message});

  final String message;
}

class UpdateTaskFailure extends Failure {
  UpdateTaskFailure({required this.message});

  final String message;
}

class DeleteTaskFailure extends Failure {
  DeleteTaskFailure({required this.message});

  final String message;
}

class GetTasksFailure extends Failure {
  GetTasksFailure({required this.message});

  final String message;
}

class GetCategoriesFailure extends Failure {
  GetCategoriesFailure({required this.message});

  final String message;
}

class SaveOrUpdateTaskLocalFailure extends Failure {
  SaveOrUpdateTaskLocalFailure({required this.message});

  final String message;
}

class DeleteAllTasksFailure extends Failure {
  DeleteAllTasksFailure({required this.message});

  final String message;
}

class SignOutFailure extends Failure {
  SignOutFailure({required this.message});

  final String message;
}

class CopyRemotTaskInLocalFailure extends Failure {
  CopyRemotTaskInLocalFailure({required this.message});

  final String message;
}
