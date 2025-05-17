part of 'home_dash_bloc.dart';

enum HomeDashStatus {
  initial,
  loading,
  error,
}

class HomeDashState {
  const HomeDashState({
    required this.isDone,
    required this.dueTo,
    required this.tasks,
    required this.status,
    required this.dateTime,
    required this.category,
    required this.statusTask,
    required this.categories,
    required this.statusId,
    required this.errorMessage,
    required this.categoryCounts,
    required this.titleController,
    required this.categoryProgress,
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
        categoryCounts: {},
        categoryProgress: {},
        status: HomeDashStatus.initial,
        titleController: TextEditingController(),
        descriptionController: TextEditingController(),
        dateTime: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
  final bool isDone;
  final String dueTo;
  final String dateTime;
  final String category;
  final String statusTask;
  final String statusId;
  final String errorMessage;
  final HomeDashStatus status;
  final List<TaskInfoModel> tasks;
  final List<CategoryModel> categories;
  final Map<String, int> categoryCounts;
  final Map<String, double> categoryProgress;
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  HomeDashState copyWith({
    bool? isDone,
    String? dueTo,
    String? dateTime,
    String? category,
    String? statusId,
    String? statusTask,
    String? errorMessage,
    HomeDashStatus? status,
    List<TaskInfoModel>? tasks,
    List<CategoryModel>? categories,
    Map<String, int>? categoryCounts,
    Map<String, double>? categoryProgress,
    TextEditingController? titleController,
    TextEditingController? descriptionController,
  }) {
    return HomeDashState(
      dueTo: dueTo ?? this.dueTo,
      tasks: tasks ?? this.tasks,
      isDone: isDone ?? this.isDone,
      status: status ?? this.status,
      category: category ?? this.category,
      dateTime: dateTime ?? this.dateTime,
      statusId: statusId ?? this.statusId,
      statusTask: statusTask ?? this.statusTask,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
      categoryCounts: categoryCounts ?? this.categoryCounts,
      titleController: titleController ?? this.titleController,
      categoryProgress: categoryProgress ?? this.categoryProgress,
      descriptionController:
          descriptionController ?? this.descriptionController,
    );
  }
}
