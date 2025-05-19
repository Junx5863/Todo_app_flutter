import 'package:dartz/dartz.dart';
import 'package:dash_todo_app/core/base/base_usecase.dart';
import 'package:dash_todo_app/core/errors/failure.dart';
import 'package:dash_todo_app/features/home_view/domain/repositories/task_manager_repository.dart';

class SignOutUseCase extends BaseUseCase<bool, NoParams> {
  SignOutUseCase({required this.taskManagerRepository});

  final TaskManagerRepository taskManagerRepository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return taskManagerRepository.signOut();
  }
}
