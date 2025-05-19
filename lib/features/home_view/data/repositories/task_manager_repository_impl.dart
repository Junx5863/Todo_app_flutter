import 'dart:async';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:dash_todo_app/core/errors/failure.dart';
import 'package:dash_todo_app/features/home_view/data/datasource/local/task_local_data_source.dart';
import 'package:dash_todo_app/features/home_view/data/datasource/remotes/task_manager_data_source.dart';
import 'package:dash_todo_app/features/home_view/data/model/local/task_local_model.dart';
import 'package:dash_todo_app/features/home_view/data/model/remotes/categories_model.dart';
import 'package:dash_todo_app/features/home_view/data/model/remotes/task_info_model.dart';
import 'package:dash_todo_app/features/home_view/domain/repositories/task_manager_repository.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskManagerRepositoryImpl extends TaskManagerRepository {
  TaskManagerRepositoryImpl({
    required this.taskManagerDataSource,
    required this.taskLocalDataSource,
    required this.sharedPreferences,
  });

  final TaskManagerDataSource taskManagerDataSource;
  final TaskLocalDataSource taskLocalDataSource;
  final SharedPreferences sharedPreferences;

  @override
  Future<Either<Failure, void>> addTask({
    required bool hasConnection,
    required Map<String, dynamic> infoTask,
  }) async {
    try {
      if (hasConnection) {
        final result = await taskManagerDataSource.addTask(
          infoTask: infoTask,
        );
        return Right(result);
      } else {
        final task = TaskLocalModel(
          taskId: generateCustomId(),
          nameTask: infoTask['nameTask'],
          descripTask: infoTask['descripTask'],
          dateCreate: DateTime.parse(
            infoTask['dateCreate'],
          ),
          categoryName: infoTask['categoryName'],
          categoryId: infoTask['categoryId'],
          pendingTaskId: 'peding_task',
        );
        final results = await taskLocalDataSource.saveOrUpdateTask(
          infoTask: task,
        );

        return Right(results);
      }
    } catch (e) {
      return Left(
        AddTaskFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTask({
    required String taskId,
    required bool hasConnection,
  }) async {
    try {
      final deletedTaskIds =
          sharedPreferences.getStringList('deleted_task_ids') ?? [];
      if (hasConnection) {
        await taskManagerDataSource.deleteTask(
          taskId: taskId,
        );
        return Right(true);
      } else {
        if (!deletedTaskIds.contains(taskId)) {
          deletedTaskIds.add(taskId);

          // Guarda la lista actualizada
          await sharedPreferences.setStringList(
              'deleted_task_ids', deletedTaskIds);
        }
        await taskLocalDataSource.deleteTask(taskId);
        return Right(true);
      }
    } catch (e) {
      return Left(
        DeleteTaskFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Stream<Either<Failure, List<TaskInfoModel>>> getTasks({
    required bool hasConnection,
  }) {
    try {
      if (hasConnection) {
        // Obtenemos el stream de tareas remotas

        return taskManagerDataSource.getTasksList().asyncMap(
          (tasks) async {
            try {
              await syncPendingTasks(tasks);
            } catch (e) {
              return Left(GetTasksFailure(message: e.toString()));
            }

            // Retornamos las tareas actualizadas
            return Right(tasks);
          },
        );
      } else {
        // Escuchamos cambios locales en tiempo real desde Hive
        return taskLocalDataSource.getAllTaskList().asyncMap((localTasks) {
          final taskInfoList = localTasks.map((local) {
            return TaskInfoModel(
              taskId: local.taskId,
              nameTask: local.nameTask,
              descripTask: local.descripTask,
              dateCreate: local.dateCreate,
              categoryName: local.categoryName,
              categoryId: local.categoryId,
            );
          }).toList();

          return Right(taskInfoList);
        });
      }
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

  String generateCustomId({int length = 20}) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random.secure();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)])
        .join();
  }

  Future<void> syncPendingTasks(List<TaskInfoModel> remoteTasks) async {
    //* 1. Sincronizar tareas eliminadas
    // Obtener la lista de IDs de tareas eliminadas desde SharedPreferences
    final deletedTaskIds =
        sharedPreferences.getStringList('deleted_task_ids') ?? [];
    // Eliminar las tareas locales que están en la lista de IDs eliminados
    await Future.wait(deletedTaskIds.map(
      (taskId) async {
        await taskManagerDataSource.deleteTask(taskId: taskId);
      },
    ));
    // Limpiar la lista de IDs eliminados en SharedPreferences
    await sharedPreferences.remove('deleted_task_ids');

    //* 2. Sincronizar tareas pendientes
    // Obtener las tareas locales actuales
    final localTaskList = await taskLocalDataSource.getAllTaskList().first;

    await Future.wait(localTaskList.map(
      (localTask) async {
        if (localTask.pendingTaskId.contains('peding_task')) {
          await taskManagerDataSource.addTask(
            infoTask: {
              'nameTask': localTask.nameTask,
              'descripTask': localTask.descripTask,
              'dateCreate': DateFormat('yyyy-MM-dd')
                  .format(localTask.dateCreate)
                  .toString(),
              'categoryName': localTask.categoryName,
              'categoryId': localTask.categoryId,
            },
          );
          await taskLocalDataSource.deleteTask(localTask.taskId);
        }
      },
    ));

    //* 3. Guardar las tareas remotas en local, nuevas tareas
    for (final task in remoteTasks) {
      final existingTask = await taskLocalDataSource.getTaskById(task.taskId!);
      if (existingTask == null) {
        await taskLocalDataSource.saveOrUpdateTask(
          infoTask: TaskLocalModel(
            taskId: task.taskId!,
            nameTask: task.nameTask!,
            descripTask: task.descripTask!,
            dateCreate: task.dateCreate!,
            categoryName: task.categoryName!,
            categoryId: task.categoryId!,
            pendingTaskId: '',
          ),
        );
      }
    }
  }
}
