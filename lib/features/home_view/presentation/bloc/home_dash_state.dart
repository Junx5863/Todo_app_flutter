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
    required this.categories,
    required this.categoryId,
    required this.errorMessage,
    required this.categoryCounts,
    required this.categoryProgress,
    required this.titleController,
  });

  factory HomeDashState.initial() => HomeDashState(
        tasks: [],
        isDone: false,
        dueTo: 'Today',
        categoryId: '',
        categories: [],
        errorMessage: '',
        category: '',
        categoryCounts: {},
        categoryProgress: {},
        status: HomeDashStatus.initial,
        titleController: TextEditingController(),
        dateTime: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
  final bool isDone;
  final String dueTo;
  final String dateTime;
  final String category;
  final String categoryId;
  final String errorMessage;
  final HomeDashStatus status;
  final List<TaskInfoModel> tasks;
  final List<CategoryModel> categories;
  final Map<String, int> categoryCounts;
  final Map<String, double> categoryProgress;
  final TextEditingController titleController;

  HomeDashState copyWith({
    bool? isDone,
    String? dueTo,
    String? dateTime,
    String? category,
    String? categoryId,
    String? errorMessage,
    HomeDashStatus? status,
    List<TaskInfoModel>? tasks,
    List<CategoryModel>? categories,
    Map<String, int>? categoryCounts,
    Map<String, double>? categoryProgress,
    TextEditingController? titleController,
  }) {
    return HomeDashState(
      dueTo: dueTo ?? this.dueTo,
      tasks: tasks ?? this.tasks,
      isDone: isDone ?? this.isDone,
      status: status ?? this.status,
      category: category ?? this.category,
      dateTime: dateTime ?? this.dateTime,
      categoryId: categoryId ?? this.categoryId,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
      categoryCounts: categoryCounts ?? this.categoryCounts,
      titleController: titleController ?? this.titleController,
      categoryProgress: categoryProgress ?? this.categoryProgress,
    );
  }
}
