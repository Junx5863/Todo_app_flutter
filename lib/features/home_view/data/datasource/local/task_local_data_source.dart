import 'dart:async';

import 'package:hive/hive.dart';
import 'package:dash_todo_app/injection_container.dart';
//Modelos
import 'package:dash_todo_app/features/home_view/data/model/local/task_local_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class TaskLocalDataSource {
  Future<void> saveOrUpdateTask({
    required TaskLocalModel infoTask,
  });

  Stream<Box<TaskLocalModel>> getTask();

  Future<void> deleteTask(String taskId);
  Stream<List<TaskLocalModel>> getAllTaskList();

  Future<TaskLocalModel?> getTaskById(String taskId);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final Box<TaskLocalModel> taskBox = sl<Box<TaskLocalModel>>();

  @override
  Future<void> saveOrUpdateTask({
    required TaskLocalModel infoTask,
  }) async {
    return taskBox.put(infoTask.taskId, infoTask);
  }

  @override
  Stream<List<TaskLocalModel>> getAllTaskList() {
    return Stream.value(taskBox.values.toList());
    /* return taskBox.watch().map((event) {
      return taskBox.values.toList();
    }); */
  }

  @override
  Stream<Box<TaskLocalModel>> getTask() {
    return Stream.value(taskBox);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await taskBox.delete(taskId);
  }

  @override
  Future<TaskLocalModel?> getTaskById(String taskId) async {
    return taskBox.get(taskId);
  }
}
