// ignore_for_file: unrelated_type_equality_checks

import 'package:dash_todo_app/core/base/base_page.dart';
import 'package:dash_todo_app/core/styles/app_them.dart';
import 'package:dash_todo_app/core/utils/modals/error_page.dart';
import 'package:dash_todo_app/features/home_view/presentation/pages/widgets/modal_bottom_sheet.dart';
import 'package:dash_todo_app/features/home_view/presentation/bloc/home_dash_bloc.dart';
import 'package:dash_todo_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeDashView extends BasePage<HomeDashState, HomeDashCubit> {
  const HomeDashView({super.key});

  @override
  HomeDashCubit createBloc(BuildContext context) => sl<HomeDashCubit>()..init();

  @override
  Widget buildPage(
      BuildContext context, HomeDashState state, HomeDashCubit bloc) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocListener<HomeDashCubit, HomeDashState>(
            listener: (context, state) {
              if (state.status == HomeDashStatus.error) {
                showErrorsModal(
                  context: context,
                  title: 'Upps something went wrong',
                  errorMessage: state.errorMessage,
                );
              }
            },
            child: state.tasks.isEmpty
                ? const Center(
                    child: Text(
                      "No tasks available",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderWidget(),
                      CategoryWidget(),
                      ListTaskWidget(
                        bloc: bloc,
                        state: state,
                      ),
                    ],
                  )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          modalBottomSheetCard(
            context: context,
            title: "Add Task",
            cubit: bloc,
            state: state,
            onSelected: () {
              bloc.createTask();
              context.pop();
            },
          );
        },
        backgroundColor: AppColors.primary,
        child: Icon(
          Icons.add,
          color: AppColors.white,
          size: 30,
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Menú + Texto
              Row(
                children: [
                  Icon(
                    Icons.menu,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              // Búsqueda y notificaciones
              Row(
                children: [
                  Icon(
                    Icons.search,
                    color: AppColors.primary,
                    size: 26,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.notifications,
                    color: AppColors.primary,
                    size: 26,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              "What's up, Joy!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                "Categories",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                onPressed: () {
                  /* modalBottomSheetCard(
                      context: context,
                      title: "Add Category",
                      onSelected: () {}); */
                },
                icon:
                    Icon(Icons.add_circle, color: AppColors.primary, size: 28),
              ),
            ),
          ],
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.15,
          margin: const EdgeInsets.only(left: 16, right: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.white,
                          blurRadius: 10,
                          offset: const Offset(0, 1),
                        ),
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "40 Taks",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w200,
                              color: AppColors.grey600,
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.010),
                          Text(
                            "Business",
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: AppColors.background,
                            ),
                          ),
                        ],
                      ),
                      LinearProgressIndicator(
                        value: 0.7,
                        backgroundColor: AppColors.grey200,
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ListTaskWidget extends StatelessWidget {
  const ListTaskWidget({
    super.key,
    required this.bloc,
    required this.state,
  });
  final HomeDashCubit bloc;
  final HomeDashState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Tasks",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.46,
            child: state.status == HomeDashStatus.loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                : ListView.builder(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final ValueNotifier<bool> valueCheckTask =
                          ValueNotifier(state.tasks[index].isDone!);
                      return ValueListenableBuilder(
                          valueListenable: valueCheckTask,
                          builder: (context, value, child) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: GestureDetector(
                                onTap: () {
                                  bloc.setTextAndDate(
                                    titleTask: state.tasks[index].title!,
                                    dateTime: state.tasks[index].dueDate,
                                  );
                                  if (state.dateTime.isNotEmpty) {
                                    modalBottomSheetCard(
                                      context: context,
                                      title: 'Update Task',
                                      cubit: bloc,
                                      state: state,
                                      category: state.tasks[index].category,
                                      dateTime: state.tasks[index].dueDate,
                                      dueTo: state.dueTo,
                                      isChecked: valueCheckTask.value,
                                      onSelected: () {
                                        bloc.updateTaskInfo(
                                          taskId: state.tasks[index].idTask!,
                                        );
                                        context.pop();
                                      },
                                    );
                                  }
                                },
                                child: Dismissible(
                                  resizeDuration:
                                      const Duration(milliseconds: 200),
                                  onDismissed: (direction) {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      bloc.deleteTask(
                                        taskId: state.tasks[index].idTask!,
                                      );
                                    }
                                  },
                                  key: Key(state.tasks[index].idTask!),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.red[300],
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "The task will be delete",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Icon(Icons.delete_rounded,
                                            color: Colors.white)
                                      ],
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          state.tasks[index].title!,
                                          style: TextStyle(
                                            decoration: valueCheckTask.value
                                                ? TextDecoration.lineThrough
                                                : null,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.background,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            valueCheckTask.value =
                                                !valueCheckTask.value;
                                            bloc.updateTaskDone(
                                              taskId:
                                                  state.tasks[index].idTask!,
                                              isDone: valueCheckTask.value,
                                            );
                                          },
                                          icon: Icon(
                                            valueCheckTask.value
                                                ? Icons.check_circle
                                                : Icons.circle_outlined,
                                            color: AppColors.primary,
                                            size: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
