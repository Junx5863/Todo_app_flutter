import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dash_todo_app/core/base/base_usecase.dart';
import 'package:dash_todo_app/core/errors/failure.dart';
import 'package:dash_todo_app/core/navigation/name_router.dart';
import 'package:dash_todo_app/core/styles/app_them.dart';
import 'package:dash_todo_app/features/home_view/data/model/remotes/categories_model.dart';
import 'package:dash_todo_app/features/home_view/data/model/remotes/task_info_model.dart';
import 'package:dash_todo_app/features/home_view/domain/usecases/add_task_use_case.dart';
import 'package:dash_todo_app/features/home_view/domain/usecases/delete_task_use_case.dart';
import 'package:dash_todo_app/features/home_view/domain/usecases/get_categories_use_case.dart';
import 'package:dash_todo_app/features/home_view/domain/usecases/get_task_use_case.dart';
import 'package:dash_todo_app/features/home_view/domain/usecases/logout_use_case.dart';
import 'package:dash_todo_app/features/home_view/domain/usecases/update_task_use_case.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_dash_state.dart';

class HomeDashCubit extends Cubit<HomeDashState> {
  HomeDashCubit({
    required GetTaskUseCase getTaskUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
    required CreateTaskUseCase addTaskUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required SignOutUseCase signOutUseCase,
    required SharedPreferences sharedPreferences,
  })  : _getTaskUseCase = getTaskUseCase,
        _updateTaskUseCase = updateTaskUseCase,
        _deleteTaskUseCase = deleteTaskUseCase,
        _addTaskUseCase = addTaskUseCase,
        _getCategoriesUseCase = getCategoriesUseCase,
        _signOutUseCase = signOutUseCase,
        _sharedPreferences = sharedPreferences,
        super(HomeDashState.initial());

  final GetTaskUseCase _getTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final CreateTaskUseCase _addTaskUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final SignOutUseCase _signOutUseCase;
  final SharedPreferences _sharedPreferences;

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
            modalShowResponse(
              context: context,
              message: 'Failed to load tasks',
              status: 'error',
            );
          },
          (List<TaskInfoModel> tasks) {
            state.titleController.clear();
            state.descriptionController.clear();
            emit(state.copyWith(
              status: HomeDashStatusVariables.syncOffline,
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

  void createTask(BuildContext context) async {
    bool isValid = _validateTaskData(context);

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
      modalShowResponse(
        context: context,
        message: 'Failed to create task',
        status: 'error',
      );
    }, (dynamic r) {
      modalShowResponse(
        context: context,
        message: 'Task created successfully',
        status: 'successTask',
      );
    });
  }

  void deleteTask({
    required String taskId,
    required BuildContext context,
  }) async {
    emit(state.copyWith(status: HomeDashStatusVariables.loading));
    final hasIntenet = await hasInternetConnection();

    final result = await _deleteTaskUseCase(
      DeleteTaskUseParams(taskId: taskId, hasConnection: hasIntenet),
    );

    result.fold((dynamic fail) {
      modalShowResponse(
        context: context,
        message: 'Failed to delete task',
        status: 'error',
      );
    }, (response) {
      emit(state.copyWith(
        status: HomeDashStatusVariables.syncOffline,
      ));
      modalShowResponse(
        context: context,
        message: 'Task deleted successfully',
        status: 'successTask',
      );
    });
  }

  Future<void> updateTaskInfo({
    required String taskId,
    required BuildContext context,
  }) async {
    emit(state.copyWith(
      status: HomeDashStatusVariables.loading,
    ));

    final validateTextField = _validateTaskData(context);
    if (!validateTextField) return;

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
          modalShowResponse(
            context: context,
            message: 'Failed to update task. Please try again.',
            status: 'error',
          );
        }
      },
      (response) {
        modalShowResponse(
          context: context,
          message: 'Task updated successfully',
          status: 'successTask',
        );
      },
    );
  }

// Función privada para validar los datos de la tarea
  bool _validateTaskData(BuildContext context) {
    if (state.titleController.text.isEmpty) {
      modalShowResponse(
        context: context,
        message: 'Please enter a title',
        status: 'errorTitleBox',
      );
      return false;
    }
    if (state.descriptionController.text.isEmpty) {
      emit(state.copyWith(
        status: HomeDashStatusVariables.error,
        errorStatus: 'error',
        errorMessage: 'Please enter a description',
      ));
      modalShowResponse(
        context: context,
        message: 'Please enter a description',
        status: 'errorTitleBox',
      );
      return false;
    }
    return true;
  }

  void setTextTask({
    String? titleTask,
    String? descriptionTask,
  }) async {
    state.titleController.text = titleTask ?? state.titleController.text;
    state.descriptionController.text =
        descriptionTask ?? state.descriptionController.text;
    emit(state.copyWith());
  }

  void updateTaskId({
    required String taskId,
    required String categoryName,
    required String categoryId,
    required BuildContext context,
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
        if (fail is UpdateTaskFailure) {
          modalShowResponse(
            context: context,
            message: 'Failed to update task. Please try again.',
            status: 'error',
          );
        } else {
          modalShowResponse(
            context: context,
            message: 'Failed to update task. Please try again.',
            status: 'error',
          );
        }
      },
      (response) {
        modalShowResponse(
          context: context,
          message: 'Task updated successfully',
          status: 'successTask',
        );
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

  void modalShowResponse(
      {required String status,
      required String message,
      required BuildContext context}) {
    switch (status) {
      case 'error':
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.red700,
          content: Text(
            message,
            style: const TextStyle(color: Colors.white, letterSpacing: 0.5),
          ),
        ));

        break;
      case 'successTask':
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.green700,
          content: Text(
            message,
            style: const TextStyle(color: Colors.white, letterSpacing: 0.5),
          ),
        ));

        SnackBar(
          backgroundColor: AppColors.green700,
          content: Text(
            message,
            style: const TextStyle(color: Colors.white, letterSpacing: 0.5),
          ),
        );
        break;
      case 'errorTitleBox':
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.red700,
          content: Text(
            message,
            style: const TextStyle(color: Colors.white, letterSpacing: 0.5),
          ),
        ));

      default:
    }
  }

  Future<void> signOut(BuildContext context) async {
    final result = await _signOutUseCase(NoParams());
    // ignore: unawaited_futures
    result.fold((dynamic l) {
      if (l is SignOutFailure) {
        modalShowResponse(
          context: context,
          message: 'Failed to sign out. Please try again.',
          status: 'error',
        );
      }
    }, (bool r) async {
      modalShowResponse(
        context: context,
        message: 'Sign out successfully',
        status: 'successTask',
      );

      _sharedPreferences.clear();
      context.go(RoutePathsName.login);
    });
  }
}
