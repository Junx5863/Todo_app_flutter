import 'package:equatable/equatable.dart';

class RouteParametersModel extends Equatable {
  const RouteParametersModel({
    this.title,
    this.message,
    this.data,
  });

  final String? title;
  final String? message;
  final Map<String, dynamic>? data;

  @override
  List<Object?> get props => [];
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'data': data,
    };
  }
}
