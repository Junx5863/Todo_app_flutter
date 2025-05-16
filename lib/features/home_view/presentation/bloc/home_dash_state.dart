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
    required this.errorMessage,
    required this.titleController,
  });

  factory HomeDashState.initial() => HomeDashState(
        isDone: false,
        dueTo: 'Today',
        tasks: [],
        dateTime: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        category: 'Design',
        errorMessage: '',
        status: HomeDashStatus.initial,
        titleController: TextEditingController(),
      );
  final bool isDone;
  final String dueTo;
  final String dateTime;
  final String category;
  final String errorMessage;
  final List<TaskInfoModel> tasks;
  final HomeDashStatus status;
  final TextEditingController titleController;

  HomeDashState copyWith({
    bool? isDone,
    String? dueTo,
    String? dateTime,
    String? category,
    String? errorMessage,
    HomeDashStatus? status,
    List<TaskInfoModel>? tasks,
    TextEditingController? titleController,
  }) {
    return HomeDashState(
      isDone: isDone ?? this.isDone,
      dueTo: dueTo ?? this.dueTo,
      tasks: tasks ?? this.tasks,
      status: status ?? this.status,
      category: category ?? this.category,
      dateTime: dateTime ?? this.dateTime,
      errorMessage: errorMessage ?? this.errorMessage,
      titleController: titleController ?? this.titleController,
    );
  }
}
