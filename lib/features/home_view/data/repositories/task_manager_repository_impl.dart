import 'package:dartz/dartz.dart';
import 'package:dash_todo_app/core/errors/failure.dart';
import 'package:dash_todo_app/features/home_view/data/datasource/task_manager_data_source.dart';
import 'package:dash_todo_app/features/home_view/data/model/categories_model.dart';
import 'package:dash_todo_app/features/home_view/data/model/task_info_model.dart';
import 'package:dash_todo_app/features/home_view/domain/repositories/task_manager_repository.dart';

class TaskManagerRepositoryImpl extends TaskManagerRepository {
  TaskManagerRepositoryImpl({
    required this.taskManagerDataSource,
  });

  final TaskManagerDataSource taskManagerDataSource;

  @override
  Future<Either<Failure, void>> addTask({
    required Map<String, dynamic> infoTask,
  }) async {
    try {
      final result = await taskManagerDataSource.addTask(
        infoTask: infoTask,
      );
      return Right(result);
    } catch (e) {
      return Left(
        AddTaskFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask({required String taskId}) async {
    try {
      final result = await taskManagerDataSource.deleteTask(
        taskId: taskId,
      );
      return Right(result);
    } catch (e) {
      return Left(
        DeleteTaskFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Stream<Either<Failure, List<TaskInfoModel>>> getTasks() {
    try {
      return taskManagerDataSource.getTasksList().map(
            (tasks) => Right(tasks),
          );
    } catch (e) {
      return Stream.value(
        Left(
          GetTasksFailure(
            message: e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateTask({
    required String taskId,
    required Map<String, dynamic> updateTaskInfo,
  }) async {
    try {
      final result = await taskManagerDataSource.updateTask(
        taskId: taskId,
        updateTaskInfo: updateTaskInfo,
      );
      return Right(result);
    } catch (e) {
      return Left(
        UpdateTaskFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final result = await taskManagerDataSource.getCategoriesList();
      return Right(result);
    } catch (e) {
      throw Left(
        GetCategoriesFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
