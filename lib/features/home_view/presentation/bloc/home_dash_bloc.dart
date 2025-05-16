import 'package:bloc/bloc.dart';
import 'package:dash_todo_app/core/base/base_usecase.dart';
import 'package:dash_todo_app/core/errors/failure.dart';
import 'package:dash_todo_app/features/home_view/data/model/categories_model.dart';
import 'package:dash_todo_app/features/home_view/data/model/task_info_model.dart';
import 'package:dash_todo_app/features/home_view/domain/usecases/add_task_use_case.dart';
import 'package:dash_todo_app/features/home_view/domain/usecases/delete_task_use_case.dart';
import 'package:dash_todo_app/features/home_view/domain/usecases/get_categories_use_case.dart';
import 'package:dash_todo_app/features/home_view/domain/usecases/get_task_use_case.dart';
import 'package:dash_todo_app/features/home_view/domain/usecases/update_task_use_case.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'home_dash_state.dart';

class HomeDashCubit extends Cubit<HomeDashState> {
  HomeDashCubit({
    required GetTaskUseCase getTaskUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
    required CreateTaskUseCase addTaskUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
  })  : _getTaskUseCase = getTaskUseCase,
        _updateTaskUseCase = updateTaskUseCase,
        _deleteTaskUseCase = deleteTaskUseCase,
        _addTaskUseCase = addTaskUseCase,
        _getCategoriesUseCase = getCategoriesUseCase,
        super(HomeDashState.initial());

  final GetTaskUseCase _getTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final CreateTaskUseCase _addTaskUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  void init() async {
    emit(state.copyWith(status: HomeDashStatus.loading));
    getCategories();

    _getTaskUseCase.callStream(NoParams()).listen(
      (result) {
        result.fold((dynamic fail) {
          emit(state.copyWith(
            status: HomeDashStatus.error,
            errorMessage: 'Failed to load tasks',
          ));
        }, (List<TaskInfoModel> tasks) {
          final Map<String, int> categoryCounts = {};

          for (final task in tasks) {
            final category = task.category ?? 'Unknown';
            categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
          }

          final totalTasks =
              categoryCounts.values.fold<int>(0, (sum, count) => sum + count);

          final Map<String, double> categoryProgress = {};
          for (final entry in categoryCounts.entries) {
            categoryProgress[entry.key] =
                totalTasks > 0 ? entry.value / totalTasks : 0.0;
          }

          emit(state.copyWith(
            status: HomeDashStatus.initial,
            tasks: tasks,
            categoryCounts: categoryCounts,
            categoryProgress: categoryProgress, // ← nuevo campo
          ));
        });
      },
    );
  }

  void getCategories() async {
    emit(state.copyWith(status: HomeDashStatus.loading));

    final result = await _getCategoriesUseCase(NoParams());

    result.fold(
      (dynamic fail) {
        emit(state.copyWith(
          status: HomeDashStatus.error,
          errorMessage: 'Failed to load categories',
        ));
      },
      (List<CategoryModel> r) {
        emit(state.copyWith(
          status: HomeDashStatus.initial,
          categories: r,
        ));
      },
    );
  }

  void dateTask({
    String? dueTo,
    String? dateTime,
  }) {
    switch (dueTo) {
      case 'Today':
        emit(state.copyWith(
          dateTime: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        ));
        break;
      case 'Tomorrow':
        emit(state.copyWith(
          dateTime: DateFormat('yyyy-MM-dd')
              .format(DateTime.now().add(const Duration(days: 1))),
        ));
        break;
      case 'Custom':
        emit(state.copyWith(
          dateTime: dateTime,
        ));
        break;
      default:
        emit(state.copyWith(
          dateTime: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        ));
    }
  }

  void categoryTask({
    String? category,
    String? categoryId,
  }) {
    emit(state.copyWith(
      category: category,
      categoryId: categoryId,
    ));
  }

  void createTask() async {
    emit(state.copyWith(status: HomeDashStatus.loading));

    final validationError = _validateTaskData();
    if (validationError != null) {
      emit(state.copyWith(
        status: HomeDashStatus.error,
        errorMessage: validationError,
      ));
      return;
    }

    final result = await _addTaskUseCase(
      CreateTaskUseParams(
        title: state.titleController.text,
        dueDate: state.dateTime,
        category: state.category,
        isDone: state.isDone,
        categoryId: state.categoryId,
      ),
    );

    result.fold((dynamic fail) {
      emit(state.copyWith(
        status: HomeDashStatus.error,
      ));
    }, (response) {
      emit(state.copyWith(
        status: HomeDashStatus.initial,
        titleController: TextEditingController(),
        dateTime: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        category: 'Design',
      ));
    });
  }

  void deleteTask({required String taskId}) async {
    emit(state.copyWith(status: HomeDashStatus.loading));

    final result = await _deleteTaskUseCase(
      DeleteTaskUseParams(taskId: taskId),
    );

    result.fold((dynamic fail) {
      emit(state.copyWith(
        status: HomeDashStatus.error,
      ));
    }, (response) {
      emit(state.copyWith(status: HomeDashStatus.initial));
    });
  }

  void setCheckIsDone({
    required bool isDone,
  }) {
    emit(state.copyWith(
      isDone: isDone,
    ));
  }

  void setTextAndDate({
    required String titleTask,
    DateTime? dateTime,
  }) {
    final dateFormat = DateFormat('yyyy-MM-dd').format(dateTime!);

    if (dateFormat ==
        DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(const Duration(days: 1)))) {
      emit(state.copyWith(
        dueTo: 'Tomorrow',
        titleController: state.titleController..text = titleTask,
      ));
      return;
    }
    emit(state.copyWith(
      dueTo: 'Custom',
      titleController: state.titleController..text = titleTask,
    ));
  }

  void updateTaskInfo({
    required String taskId,
    bool? isDone,
  }) async {
    // Validar los datos antes de actualizar
    final validationError = _validateTaskData();
    if (validationError != null) {
      emit(state.copyWith(
        status: HomeDashStatus.error,
        errorMessage: validationError,
      ));
      return;
    }

    // Llamar a la función genérica para actualizar la tarea
    await _updateTask(
      taskId: taskId,
      isDone: isDone,
    );
  }

  void updateTaskDone({
    required String taskId,
    bool? isDone,
  }) async {
    // Llamar a la función genérica para actualizar la tarea
    await _updateTask(
      taskId: taskId,
      isDone: isDone,
    );
  }

// Función privada para actualizar una tarea
  Future<void> _updateTask({
    required String taskId,
    bool? isDone,
  }) async {
    emit(state.copyWith(
      status: HomeDashStatus.loading,
      isDone: isDone,
    ));

    final result = await _updateTaskUseCase(
      UpdateTaskUseParams(
        taskId: taskId,
        title: state.titleController.text,
        dueDate: state.dateTime,
        category: state.category,
        isDone: state.isDone,
      ),
    );

    result.fold(
      (dynamic fail) {
        // Manejo detallado de errores
        String errorMessage = 'An error occurred';
        if (fail is UpdateTaskFailure) {
          errorMessage = 'Failed to update task. Please try again.';
        }

        emit(state.copyWith(
          status: HomeDashStatus.error,
          errorMessage: errorMessage,
        ));
      },
      (response) {
        emit(state.copyWith(status: HomeDashStatus.initial));
      },
    );
  }

// Función privada para validar los datos de la tarea
  String? _validateTaskData() {
    if (state.titleController.text.isEmpty) {
      return 'Please enter a title';
    } else if (state.category.isEmpty || state.categoryId.isEmpty) {
      return 'Please select a category';
    }
    return null; // No hay errores
  }
}
