import 'package:dartz/dartz.dart';
import 'package:dash_todo_app/core/base/base_usecase.dart';
import 'package:dash_todo_app/core/errors/failure.dart';

import 'package:dash_todo_app/features/home_view/domain/repositories/task_manager_repository.dart';

class DeleteTaskUseCase extends BaseUseCase<bool, DeleteTaskUseParams> {
  DeleteTaskUseCase({required this.taskManagerRepository});
  final TaskManagerRepository taskManagerRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteTaskUseParams params) {
    return taskManagerRepository.deleteTask(
      taskId: params.taskId,
      hasConnection: params.hasConnection,
    );
  }
}

class DeleteTaskUseParams {
  DeleteTaskUseParams({
    required this.taskId,
    required this.hasConnection,
  });
  final String taskId;
  final bool hasConnection;
}
