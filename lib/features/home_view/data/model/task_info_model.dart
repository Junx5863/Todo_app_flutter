// To parse this JSON data, do
//
//     final taskInfoModel = taskInfoModelFromJson(jsonString);

import 'dart:convert';

List<TaskInfoModel> taskInfoModelFromJson(String str) =>
    List<TaskInfoModel>.from(
        json.decode(str).map((x) => TaskInfoModel.fromJson(x)));

String taskInfoModelToJson(List<TaskInfoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaskInfoModel {
  final DateTime? dueDate;
  final String? title;
  final String? category;
  final String? userId;
  final bool? isDone;
  final String? idTask;
  final String? categoryId;

  TaskInfoModel({
    this.dueDate,
    this.title,
    this.category,
    this.userId,
    this.isDone,
    this.idTask,
    this.categoryId,
  });

  factory TaskInfoModel.fromJson(Map<String, dynamic> json) => TaskInfoModel(
        dueDate:
            json["dueDate"] == null ? null : DateTime.parse(json["dueDate"]),
        title: json["title"],
        category: json["category"],
        userId: json["userId"],
        isDone: json["isDone"],
        idTask: json["idTask"],
        categoryId: json["categoryId"],
      );

  Map<String, dynamic> toJson() => {
        "dueDate":
            "${dueDate!.year.toString().padLeft(4, '0')}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}",
        "title": title,
        "category": category,
        "userId": userId,
        "isDone": isDone,
        "idTask": idTask,
        "categoryId": categoryId,
      };
}
