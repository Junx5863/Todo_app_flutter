// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) =>
    List<CategoryModel>.from(
        json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
  final String? statusId;
  final String? statuName;

  CategoryModel({
    this.statusId,
    this.statuName,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        statusId: json["statusId"],
        statuName: json["statusName"],
      );

  Map<String, dynamic> toJson() => {
        "statusId": statusId,
        "statusName": statuName,
      };
}
