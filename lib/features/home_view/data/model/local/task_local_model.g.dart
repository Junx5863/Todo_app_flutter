// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_local_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskLocalModelAdapter extends TypeAdapter<TaskLocalModel> {
  @override
  final int typeId = 0;

  @override
  TaskLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskLocalModel(
      taskId: fields[0] as String,
      nameTask: fields[1] as String,
      categoryId: fields[5] as String,
      categoryName: fields[4] as String,
      descripTask: fields[2] as String,
      dateCreate: fields[3] as DateTime,
      pendingTaskId: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TaskLocalModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.taskId)
      ..writeByte(1)
      ..write(obj.nameTask)
      ..writeByte(2)
      ..write(obj.descripTask)
      ..writeByte(3)
      ..write(obj.dateCreate)
      ..writeByte(4)
      ..write(obj.categoryName)
      ..writeByte(5)
      ..write(obj.categoryId)
      ..writeByte(6)
      ..write(obj.pendingTaskId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
