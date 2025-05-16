import 'package:dartz/dartz.dart';
import 'package:dash_todo_app/core/base/base_usecase.dart';
import 'package:dash_todo_app/core/errors/failure.dart';
import 'package:dash_todo_app/features/home_view/data/model/task_info_model_dart';

import 'package:dash_todo_app/features/home_view/domain/repositories/task_manager_repository.dart';

class GetTaskUseCase extends BaseUsecaseStream<List<TaskInfoModel>, NoParams> {
  GetTaskUseCase({required this.taskManagerRepository});
  final TaskManagerRepository taskManagerRepository;

  @override
  Stream<Either<Failure, List<TaskInfoModel>>> callStream(NoParams params) {
    return taskManagerRepository.getTasks();
  }
}
