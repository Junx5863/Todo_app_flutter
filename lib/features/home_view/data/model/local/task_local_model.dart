import 'package:hive/hive.dart';

part 'task_local_model.g.dart';

@HiveType(typeId: 0)
class TaskLocalModel extends HiveObject {
  @HiveField(0)
  final String taskId;
  @HiveField(1)
  final String nameTask;
  @HiveField(2)
  final String descripTask;
  @HiveField(3)
  final DateTime dateCreate;
  @HiveField(4)
  final String categoryName;
  @HiveField(5)
  final String categoryId;
  @HiveField(6)
  final String pendingTaskId;

  TaskLocalModel({
    required this.taskId,
    required this.nameTask,
    required this.categoryId,
    required this.categoryName,
    required this.descripTask,
    required this.dateCreate,
    required this.pendingTaskId,
  });
}
