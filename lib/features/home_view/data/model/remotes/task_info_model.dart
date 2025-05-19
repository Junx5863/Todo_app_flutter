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
  final String? nameTask;
  final String? descripTask;
  final DateTime? dateCreate;
  final String? taskId;
  final String? categoryName;
  final String? categoryId;

  TaskInfoModel({
    this.nameTask,
    this.descripTask,
    this.dateCreate,
    this.taskId,
    this.categoryName,
    this.categoryId,
  });

  factory TaskInfoModel.fromJson(Map<String, dynamic> json) => TaskInfoModel(
        nameTask: json["nameTask"],
        descripTask: json["descripTask"],
        dateCreate: json["dateCreate"] == null
            ? null
            : DateTime.parse(json["dateCreate"]),
        taskId: json["taskId"],
        categoryName: json["categoryName"] ?? '',
        categoryId: json["categoryId"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "nameTask": nameTask,
        "descripTask": descripTask,
        "dateCreate":
            "${dateCreate!.year.toString().padLeft(4, '0')}-${dateCreate!.month.toString().padLeft(2, '0')}-${dateCreate!.day.toString().padLeft(2, '0')}",
        "taskId": taskId,
        "categoryName": categoryName,
        "categoryId": categoryId,
      };
}
