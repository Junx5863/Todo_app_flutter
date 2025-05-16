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
  final String? idcategory;
  final String? name;

  CategoryModel({
    this.idcategory,
    this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        idcategory: json["idCategory"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "idCategory": idcategory,
        "name": name,
      };
}
