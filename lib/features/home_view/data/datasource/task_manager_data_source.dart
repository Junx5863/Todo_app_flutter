import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_todo_app/features/home_view/data/model/categories_model.dart';
import 'package:dash_todo_app/features/home_view/data/model/task_info_model.dart';
import 'package:dash_todo_app/injection_container.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class TaskManagerDataSource {
  Future<void> addTask({
    required Map<String, dynamic> infoTask,
  });

  Future<void> updateTask({
    required String taskId,
    required Map<String, dynamic> updateTaskInfo,
  });

  Future<void> deleteTask({required String taskId});

  Stream<List<TaskInfoModel>> getTasksList();
  Future<List<CategoryModel>> getCategoriesList();
}

class TaskManagerDataSourceImpl extends TaskManagerDataSource {
  final FirebaseAuth _auth = sl<FirebaseAuth>();
  final FirebaseFirestore _db = sl<FirebaseFirestore>();

  @override
  Future<void> addTask({
    required Map<String, dynamic> infoTask,
  }) async {
    try {
      final refDb = _db.collection('task').doc();
      final result = await refDb.set({
        ...infoTask,
        'userId': _auth.currentUser?.uid,
        'taskId': refDb.id,
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
            (snapshot) => snapshot.docs.map((doc) {
              return TaskInfoModel.fromJson(doc.data());
            }).toList(),
          );
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateTask({
    required String taskId,
    required Map<String, dynamic> updateTaskInfo,
  }) {
    try {
      final refDb = _db.collection('task').doc(taskId);

      return refDb.update(
        updateTaskInfo,
      );
    } on FirebaseException catch (e) {
      // Handle error
      throw Exception('Failed to update task: $e');
    } catch (e) {
      // Handle error
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getCategoriesList() async {
    try {
      final snapshot = await _db.collection('categories').get();
      final categories = snapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data()))
          .toList();
      return categories;
    } on FirebaseException catch (e) {
      // Handle error
      throw Exception('Failed to get categories: $e');
    } catch (e) {
      // Handle error
      throw Exception('Failed to get categories: $e');
    }
  }
}
