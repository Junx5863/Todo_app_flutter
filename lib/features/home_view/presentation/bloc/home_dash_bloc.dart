import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dash_todo_app/core/base/base_usecase.dart';
import 'package:dash_todo_app/core/errors/failure.dart';
import 'package:dash_todo_app/features/home_view/data/model/remotes/categories_model.dart';
import 'package:dash_todo_app/features/home_view/data/model/remotes/task_info_model.dart';
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

  void init(BuildContext context) async {
    emit(state.copyWith(status: HomeDashStatusVariables.loading));
    getCategories();
    final hasIntenet = await hasInternetConnection();

    _getTaskUseCase.callStream(GetTaskParams(hasConnection: hasIntenet)).listen(
      (result) {
        result.fold(
          (dynamic fail) {
            emit(
              state.copyWith(
                status: HomeDashStatusVariables.error,
                errorMessage: 'Failed to load tasks',
              ),
            );
          },
          (List<TaskInfoModel> tasks) {
            state.titleController.clear();
            state.descriptionController.clear();
            emit(state.copyWith(
              tasks: tasks,
            ));
          },
        );
      },
    );
  }

  void getCategories() async {
    emit(state.copyWith(status: HomeDashStatusVariables.loading));

    final result = await _getCategoriesUseCase(NoParams());

    result.fold(
      (dynamic fail) {
        emit(state.copyWith(
          status: HomeDashStatusVariables.error,
          errorMessage: 'Failed to load categories',
        ));
      },
      (List<CategoryModel> r) {
        emit(state.copyWith(
          status: HomeDashStatusVariables.initial,
          categories: r,
        ));
      },
    );
  }

  void updateTaskState({
    String? category,
    String? statusId,
    String? status,
  }) {
    emit(state.copyWith(
      category: category ?? state.category,
      statusId: statusId ?? state.statusId,
      statusTask: status ?? state.statusTask,
    ));
  }

  void createTask() async {
    bool isValid = _validateTaskData();

    if (!isValid) return;

    final hasIntenet = await hasInternetConnection();

    final result = await _addTaskUseCase(
      CreateTaskUseParams(
        hasConnection: hasIntenet,
        infoTask: {
          'nameTask': state.titleController.text,
          'descripTask': state.descriptionController.text,
          'dateCreate':
              DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
          'categoryName': state.category,
          'categoryId': state.statusId,
        },
      ),
    );
    result.fold((dynamic fail) {
      emit(state.copyWith(
        status: HomeDashStatusVariables.error,
        errorStatus: 'error',
        errorMessage: 'Failed to create task',
      ));
    }, (dynamic r) {
      emit(state.copyWith(
        status: HomeDashStatusVariables.successTask,
        errorStatus: 'successTask',
        dateTime: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      ));
    });
    state.titleController.clear();
    state.descriptionController.clear();
  }

  void deleteTask({required String taskId}) async {
    emit(state.copyWith(status: HomeDashStatusVariables.loading));
    final hasIntenet = await hasInternetConnection();

    final result = await _deleteTaskUseCase(
      DeleteTaskUseParams(taskId: taskId, hasConnection: hasIntenet),
    );

    result.fold((dynamic fail) {
      emit(state.copyWith(
        status: HomeDashStatusVariables.error,
        errorStatus: 'error',
        errorMessage: 'Failed to delete task',
      ));
    }, (response) {
      emit(state.copyWith(
        status: HomeDashStatusVariables.deleteTask,
        errorMessage: 'Task deleted successfully',
      ));
    });
  }

  Future<void> updateTaskInfo({
    required String taskId,
  }) async {
    emit(state.copyWith(
      status: HomeDashStatusVariables.loading,
    ));

    // Validar los datos antes de actualizar
    //_validateTaskData();

    final result = await _updateTaskUseCase(
      UpdateTaskUseParams(taskId: taskId, updateTaskInfo: {
        'nameTask': state.titleController.text,
        'descripTask': state.descriptionController.text,
        'dateCreate':
            DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
        'categoryName': state.category,
        'categoryId': state.statusId,
      }),
    );

    result.fold(
      (dynamic fail) {
        // Manejo detallado de errores
        if (fail is UpdateTaskFailure) {
          emit(state.copyWith(
            status: HomeDashStatusVariables.error,
            errorMessage: 'Failed to update task. Please try again.',
          ));
        }
      },
      (response) {
        emit(state.copyWith(
          status: HomeDashStatusVariables.successTask,
          errorMessage: 'Task updated successfully',
        ));
      },
    );
  }

// Función privada para validar los datos de la tarea
  bool _validateTaskData() {
    if (state.titleController.text.isEmpty) {
      emit(state.copyWith(
        status: HomeDashStatusVariables.error,
        errorStatus: 'error',
        errorMessage: 'Please enter a title',
      ));
      /* showErrorsModal(
        context: context,
        title: 'Upps something went wrong',
        errorMessage: 'Please enter a title',
      ); */
      return false;
    }
    if (state.descriptionController.text.isEmpty) {
      emit(state.copyWith(
        status: HomeDashStatusVariables.error,
        errorStatus: 'error',
        errorMessage: 'Please enter a description',
      ));
      /* showErrorsModal(
        context: context,
        title: 'Upps something went wrong',
        errorMessage: 'Please enter a description',
      ); */
      return false;
    }
    return true;
  }

  void setTextTask({
    String? titleTask,
    String? descriptionTask,
  }) {
    state.titleController.text = titleTask ?? state.titleController.text;
    state.descriptionController.text =
        descriptionTask ?? state.descriptionController.text;
  }

  void updateTaskId({
    required String taskId,
    required String categoryName,
    required String categoryId,
  }) async {
    final result = await _updateTaskUseCase(
      UpdateTaskUseParams(
        taskId: taskId,
        updateTaskInfo: {
          'categoryName': categoryName,
          'categoryId': categoryId,
        },
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
          status: HomeDashStatusVariables.error,
          errorMessage: errorMessage,
        ));
      },
      (response) {
        emit(state.copyWith(
          status: HomeDashStatusVariables.initial,
        ));
      },
    );
  }

  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      return true; // Hay conexión a Internet
    } else {
      return false; // No hay conexión a Internet
    }
  }
}
