import 'package:dartz/dartz.dart';
import 'package:dash_todo_app/core/base/base_usecase.dart';
import 'package:dash_todo_app/core/errors/failure.dart';

import 'package:dash_todo_app/features/home_view/domain/repositories/task_manager_repository.dart';

class CreateTaskUseCase extends BaseUseCase<dynamic, CreateTaskUseParams> {
  CreateTaskUseCase({required this.taskManagerRepository});
  final TaskManagerRepository taskManagerRepository;

  @override
  Future<Either<Failure, void>> call(CreateTaskUseParams params) {
    return taskManagerRepository.addTask(
      title: params.title,
      dueDate: params.dueDate,
      category: params.category,
    );
  }
}

class CreateTaskUseParams {
  CreateTaskUseParams({
    required this.title,
    required this.dueDate,
    required this.category,
  });

  final String title;
  final String dueDate;
  final String category;
}
