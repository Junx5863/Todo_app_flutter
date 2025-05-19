import 'package:dartz/dartz.dart';
import 'package:dash_todo_app/core/base/base_usecase.dart';
import 'package:dash_todo_app/core/errors/failure.dart';
import 'package:dash_todo_app/features/home_view/data/model/remotes/task_info_model.dart';

import 'package:dash_todo_app/features/home_view/domain/repositories/task_manager_repository.dart';

class GetTaskUseCase
    extends BaseUsecaseStream<List<TaskInfoModel>, GetTaskParams> {
  GetTaskUseCase({required this.taskManagerRepository});
  final TaskManagerRepository taskManagerRepository;

  @override
  Stream<Either<Failure, List<TaskInfoModel>>> callStream(
      GetTaskParams params) {
    return taskManagerRepository.getTasks(
      hasConnection: params.hasConnection,
    );
  }
}

class GetTaskParams {
  GetTaskParams({
    required this.hasConnection,
  });

  final bool hasConnection;
}
