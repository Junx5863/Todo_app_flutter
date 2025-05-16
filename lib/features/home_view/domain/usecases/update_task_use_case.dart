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
      title: params.title,
      dueDate: params.dueDate,
      category: params.category,
      isDone: params.isDone,
    );
  }
}

class UpdateTaskUseParams {
  UpdateTaskUseParams({
    required this.taskId,
    required this.title,
    required this.dueDate,
    required this.category,
    required this.isDone,
  });
  final String taskId;
  final String title;
  final String dueDate;
  final String category;
  final bool isDone;
}
