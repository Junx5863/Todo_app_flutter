import 'package:dartz/dartz.dart';
import 'package:dash_todo_app/core/errors/failure.dart';
import 'package:dash_todo_app/features/home_view/data/model/task_info_model_dart';

abstract class TaskManagerRepository {
  Future<Either<Failure, void>> addTask({
    required String title,
    required String dueDate,
    required String category,
  });

  Future<Either<Failure, void>> updateTask({
    required String taskId,
    required String title,
    required String dueDate,
    required String category,
    required bool isDone,
  });

  Future<Either<Failure, void>> deleteTask({required String taskId});

  Stream<Either<Failure, List<TaskInfoModel>>> getTasks();
}
