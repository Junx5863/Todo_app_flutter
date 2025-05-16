import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_todo_app/features/home_view/data/model/task_info_model_dart';
import 'package:dash_todo_app/injection_container.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class TaskManagerDataSource {
  Future<void> addTask({
    required String title,
    required String dueDate,
    required String category,
  });

  Future<void> updateTask({
    required String taskId,
    required String title,
    required String dueDate,
    required String category,
    required bool isDone,
  });

  Future<void> deleteTask({required String taskId});

  Stream<List<TaskInfoModel>> getTasksList();
}

class TaskManagerDataSourceImpl extends TaskManagerDataSource {
  final FirebaseAuth _auth = sl<FirebaseAuth>();
  final FirebaseFirestore _db = sl<FirebaseFirestore>();

  @override
  Future<void> addTask({
    required String title,
    required String dueDate,
    required String category,
  }) async {
    try {
      final refDb = _db.collection('task').doc();
      final result = await refDb.set({
        'title': title,
        'dueDate': dueDate,
        'category': category,
        'userId': _auth.currentUser?.uid,
        'isDone': false,
        'idTask': refDb.id,
      });
      return result;
    } catch (e) {
      // Handle error
      throw Exception('Failed to add task: $e');
    }
  }

  @override
  Future<void> deleteTask({required String taskId}) {
    try {
      final refDb = _db.collection('task').doc(taskId);
      return refDb.delete();
    } on FirebaseException catch (e) {
      // Handle error
      throw Exception('Failed to delete task: $e');
    } catch (e) {
      // Handle error
      throw Exception('Failed to delete task: $e');
    }
  }

  @override
  Stream<List<TaskInfoModel>> getTasksList() {
    try {
      return FirebaseFirestore.instance.collection('task').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => TaskInfoModel.fromJson(doc.data()))
              .toList());
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateTask({
    required String taskId,
    required String title,
    required String dueDate,
    required String category,
    required bool isDone,
  }) {
    try {
      final refDb = _db.collection('task').doc(taskId);
      if (title.isEmpty) {
        return refDb.update({
          'isDone': isDone,
        });
      }
      return refDb.update({
        'title': title,
        'dueDate': dueDate,
        'category': category,
        'isDone': isDone,
      });
    } on FirebaseException catch (e) {
      // Handle error
      throw Exception('Failed to update task: $e');
    } catch (e) {
      // Handle error
      throw Exception('Failed to update task: $e');
    }
  }
}
