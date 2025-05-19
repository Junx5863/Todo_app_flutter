part of 'home_dash_bloc.dart';

enum HomeDashStatusVariables {
  initial,
  loading,
  successTask,
  deleteTask,
  syncOffline,
  error,
}

class HomeDashState {
  HomeDashState({
    required this.isDone,
    required this.dueTo,
    required this.tasks,
    required this.status,
    required this.category,
    required this.statusId,
    required this.statusTask,
    required this.categories,
    required this.errorStatus,
    required this.errorMessage,
    required this.titleController,
    required this.descriptionController,
  });

  factory HomeDashState.initial() => HomeDashState(
        tasks: [],
        isDone: false,
        dueTo: 'Today',
        statusId: '',
        categories: [],
        errorMessage: '',
        category: '',
        statusTask: '',
        errorStatus: '',
        status: HomeDashStatusVariables.initial,
        titleController: TextEditingController(),
        descriptionController: TextEditingController(),
      );
  final bool isDone;
  final String dueTo;

  final String category;
  final String statusId;
  final String statusTask;
  final String errorStatus;
  final String errorMessage;
  final List<TaskInfoModel> tasks;
  final List<CategoryModel> categories;
  final HomeDashStatusVariables status;
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  HomeDashState copyWith({
    bool? isDone,
    String? dueTo,
    String? category,
    String? statusId,
    String? statusTask,
    String? errorStatus,
    String? errorMessage,
    List<TaskInfoModel>? tasks,
    List<CategoryModel>? categories,
    HomeDashStatusVariables? status,
    TextEditingController? titleController,
    TextEditingController? descriptionController,
  }) {
    return HomeDashState(
      dueTo: dueTo ?? this.dueTo,
      tasks: tasks ?? this.tasks,
      isDone: isDone ?? this.isDone,
      status: status ?? this.status,
      category: category ?? this.category,
      statusId: statusId ?? this.statusId,
      statusTask: statusTask ?? this.statusTask,
      categories: categories ?? this.categories,
      errorStatus: errorStatus ?? this.errorStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      titleController: titleController ?? this.titleController,
      descriptionController:
          descriptionController ?? this.descriptionController,
    );
  }
}
