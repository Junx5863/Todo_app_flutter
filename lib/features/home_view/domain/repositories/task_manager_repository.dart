import 'package:dartz/dartz.dart';
import 'package:dash_todo_app/core/errors/failure.dart';
import 'package:dash_todo_app/features/home_view/data/model/remotes/categories_model.dart';
import 'package:dash_todo_app/features/home_view/data/model/remotes/task_info_model.dart';

abstract class TaskManagerRepository {
  Future<Either<Failure, void>> addTask({
    required bool hasConnection,
    required Map<String, dynamic> infoTask,
  });

  Future<Either<Failure, void>> updateTask({
    required String taskId,
    required Map<String, dynamic> updateTaskInfo,
  });

  Future<Either<Failure, bool>> deleteTask({
    required String taskId,
    required bool hasConnection,
  });

  Stream<Either<Failure, List<TaskInfoModel>>> getTasks({
    required bool hasConnection,
  });
  Future<Either<Failure, List<CategoryModel>>> getCategories();
}
