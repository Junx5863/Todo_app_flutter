import 'package:dartz/dartz.dart';
import 'package:dash_todo_app/core/base/base_usecase.dart';
import 'package:dash_todo_app/core/errors/failure.dart';

import 'package:dash_todo_app/features/home_view/domain/repositories/task_manager_repository.dart';

class CreateTaskUseCase extends BaseUseCase<dynamic, CreateTaskUseParams> {
  CreateTaskUseCase({required this.taskManagerRepository});
  final TaskManagerRepository taskManagerRepository;

  @override
  Future<Either<Failure, void>> call(CreateTaskUseParams params) =>
      taskManagerRepository.addTask(
        infoTask: params.infoTask,
        hasConnection: params.hasConnection,
      );
}

class CreateTaskUseParams {
  CreateTaskUseParams({
    required this.hasConnection,
    required this.infoTask,
  });
  final bool hasConnection;
  final Map<String, dynamic> infoTask;
}
