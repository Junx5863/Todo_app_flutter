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

        await taskLocalDataSource.deleteTask(taskId);

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
  }) async* {
    try {
      if (hasConnection) {
        // 1. Eliminar tareas marcadas para borrar
        await deleteTaskInLocal();

        // 2. Sincronizar tareas pendientes
        await syncPendingTasks();

        // 3. Escuchar tareas remotas y guardarlas en local
        final remoteTasksStream = taskManagerDataSource.getTasksList();

        yield* remoteTasksStream.asyncMap((remoteTasks) async {
          // Copiamos las tareas remotas al local
          await copyRemotTaskInLocal(remoteTasks);

          return Right(remoteTasks);
        });
      } else {
        // Escuchamos cambios locales en tiempo real desde Hive
        yield* taskLocalDataSource.getAllTaskList().asyncMap((localTasks) {
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
      Left(GetTasksFailure(message: e.toString()));
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

  Future deleteTaskInLocal() async {
    try {
      final deletedTaskIds =
          sharedPreferences.getStringList('deleted_task_ids') ?? [];
      // Eliminar las tareas locales que están en la lista de IDs eliminados
      if (deletedTaskIds.isNotEmpty) {
        await Future.wait(deletedTaskIds.map(
          (taskId) async {
            await taskManagerDataSource.deleteTask(taskId: taskId);
          },
        ));
        // Limpiar la lista de IDs eliminados en SharedPreferences
        await sharedPreferences.remove('deleted_task_ids');
      }
    } catch (e) {
      throw Left(
        DeleteTaskFailure(
          message: e.toString(),
        ),
      );
    }
  }

  bool _isSyncing = false;
  Future<void> syncPendingTasks() async {
    if (_isSyncing) return;
    _isSyncing = true;
    try {
      final localTaskListStream = taskLocalDataSource.getAllTaskList();

      final localTask = await localTaskListStream.first;
      for (final local in localTask) {
        if (local.pendingTaskId.contains('peding_task')) {
          await taskManagerDataSource.addTask(
            infoTask: {
              'nameTask': local.nameTask,
              'descripTask': local.descripTask,
              'dateCreate':
                  DateFormat('yyyy-MM-dd').format(local.dateCreate).toString(),
              'categoryName': local.categoryName,
              'categoryId': local.categoryId,
            },
          );
          await taskLocalDataSource.deleteTask(local.taskId);
        }
      }
    } catch (e) {
      Left(false);
    } finally {
      _isSyncing = false;
    }
  }

  Future copyRemotTaskInLocal(List<TaskInfoModel> remoteTasks) async {
    //* 3. Guardar las tareas remotas en local, nuevas tareas
    try {
      for (final task in remoteTasks) {
        final existingTask =
            await taskLocalDataSource.getTaskById(task.taskId!);
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
    } catch (e) {
      throw Left(
        CopyRemotTaskInLocalFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> signOut() async {
    try {
      final result = await taskManagerDataSource.signOut();
      return Right(result);
    } catch (e) {
      return Left(
        SignOutFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
