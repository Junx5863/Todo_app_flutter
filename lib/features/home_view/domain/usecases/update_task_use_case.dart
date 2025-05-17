import 'package:dartz/dartz.dart';
import 'package:dash_todo_app/core/base/base_usecase.dart';
import 'package:dash_todo_app/core/errors/failure.dart';

import 'package:dash_todo_app/features/home_view/domain/repositories/task_manager_repository.dart';

class UpdateTaskUseCase extends BaseUseCase<dynamic, UpdateTaskUseParams> {
  UpdateTaskUseCase({required this.taskManagerRepository});
  final TaskManagerRepository taskManagerRepository;

  @override
  Future<Either<Failure, void>> call(UpdateTaskUseParams params) {
    return taskManagerRepository.updateTask(
      taskId: params.taskId,
      updateTaskInfo: params.updateTaskInfo,
    );
  }
}

class UpdateTaskUseParams {
  UpdateTaskUseParams({
    required this.updateTaskInfo,
    required this.taskId,
  });
  final String taskId;
  final Map<String, dynamic> updateTaskInfo;
}
