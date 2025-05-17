import 'package:dartz/dartz.dart';
import 'package:dash_todo_app/core/errors/failure.dart';
import 'package:dash_todo_app/features/home_view/data/model/categories_model.dart';
import 'package:dash_todo_app/features/home_view/data/model/task_info_model.dart';

abstract class TaskManagerRepository {
  Future<Either<Failure, void>> addTask({
    required Map<String, dynamic> infoTask,
  });

  Future<Either<Failure, void>> updateTask({
    required String taskId,
    required Map<String, dynamic> updateTaskInfo,
  });

  Future<Either<Failure, void>> deleteTask({required String taskId});

  Stream<Either<Failure, List<TaskInfoModel>>> getTasks();
  Future<Either<Failure, List<CategoryModel>>> getCategories();
}
