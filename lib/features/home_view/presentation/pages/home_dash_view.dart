// ignore_for_file: unrelated_type_equality_checks

import 'package:dash_todo_app/core/base/base_page.dart';
import 'package:dash_todo_app/core/styles/app_them.dart';
import 'package:dash_todo_app/features/home_view/data/model/remotes/task_info_model.dart';
import 'package:dash_todo_app/features/home_view/presentation/pages/widgets/modal_bottom_sheet.dart';
import 'package:dash_todo_app/features/home_view/presentation/bloc/home_dash_bloc.dart';
import 'package:dash_todo_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boardview/board_item.dart';
import 'package:flutter_boardview/board_list.dart';
import 'package:flutter_boardview/boardview.dart';
import 'package:flutter_boardview/boardview_controller.dart';
import 'package:go_router/go_router.dart';

class HomeDashView extends BasePage<HomeDashState, HomeDashCubit> {
  const HomeDashView({super.key});

  @override
  HomeDashCubit createBloc(BuildContext context) =>
      sl<HomeDashCubit>()..init(context);

  @override
  Widget buildPage(
    BuildContext context,
    HomeDashState state,
    HomeDashCubit bloc,
  ) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(
              state: state,
            ),
            DashBoardWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modalBottomSheetCard(
            context: context,
            title: "Add Task",
            cubit: bloc,
            state: state,
            category: 'New Task',
            onSelected: () {
              bloc.createTask(
                context,
              );
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
  HeaderWidget({
    super.key,
    required this.state,
  });
  final HomeDashState state;
  final bloc = sl<HomeDashCubit>();

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
                  IconButton(
                    onPressed: () {
                      bloc.signOut(
                        context,
                      );
                    },
                    icon: Icon(
                      Icons.logout_sharp,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "What's up,",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Booton Refresh Data
                  GestureDetector(
                      onTap: () {
                        context.read<HomeDashCubit>().init(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Text(
                          'Refresh',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.white,
                          ),
                        ),
                      )),
                ],
              )),
        ],
      ),
    );
  }
}

class DashBoardWidget extends StatefulWidget {
  const DashBoardWidget({super.key});

  @override
  State<DashBoardWidget> createState() => _DashBoardWidgetState();
}

class _DashBoardWidgetState extends State<DashBoardWidget> {
  final bloc = sl<HomeDashCubit>();
  BoardViewController boardViewController = BoardViewController();
  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeDashCubit>().state;
    return state.tasks.isEmpty
        ? const Center(
            child: Text(
              'No tasks available',
              style: TextStyle(
                fontSize: 20,
                color: AppColors.primary,
              ),
            ),
          )
        : Expanded(
            child: BoardView(
              boardViewController: boardViewController,
              width: 350,
              lists: state.categories.map((columnName) {
                return BoardList(
                  draggable: true,
                  headerBackgroundColor: AppColors.primary,
                  backgroundColor: AppColors.grey200,
                  boardView: BoardViewState(),
                  footer: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        modalBottomSheetCard(
                          context: context,
                          title: "Add Task",
                          cubit: bloc,
                          state: state,
                          category: columnName.statuName,
                          onSelected: () {
                            bloc.createTask(context);
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primary,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: AppColors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Add Task',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  header: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          columnName.statuName!,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  items: state.tasks
                      .where(
                          (task) => task.categoryName == columnName.statuName)
                      .map((taskInfo) {
                    return BoardItem(
                      // Controlador para el movimiento de los elementos
                      onDragItem:
                          (item, fromList, toList, fromIndex, toIndex) {},
                      // Actualiza el estado de la tarea al soltarla
                      onDropItem: (listIndex, itemIndex, oldListIndex,
                          oldItemIndex, boardItemState) {
                        bloc.updateTaskId(
                          context: context,
                          taskId: taskInfo.taskId!,
                          categoryName: state.categories[listIndex!].statuName!,
                          categoryId: state.categories[listIndex].statusId!,
                        );
                      },

                      item: taskWidget(
                        state,
                        bloc,
                        taskInfo,
                        context,
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          );
  }

  Widget taskWidget(
    HomeDashState state,
    HomeDashCubit bloc,
    TaskInfoModel taskInfo,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        state.titleController.text = taskInfo.nameTask!;
        state.descriptionController.text = taskInfo.descripTask!;
        modalBottomSheetCard(
          context: context,
          title: 'Update Task',
          cubit: bloc,
          state: state,
          category: taskInfo.categoryName,
          onSelected: () {
            bloc.updateTaskInfo(
              context: context,
              taskId: taskInfo.taskId!,
            );
          },
        );
      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border(
              left: BorderSide(
                color: setColorCard(taskName: taskInfo.categoryName!),
                width: 6,
              ),
            ),
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                taskInfo.nameTask!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  taskInfo.descripTask!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppColors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${taskInfo.dateCreate!.day}/${taskInfo.dateCreate!.month}/${taskInfo.dateCreate!.year}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      bloc.deleteTask(
                          context: context, taskId: taskInfo.taskId!);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Deleted',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Color setColorCard({required String taskName}) {
    // Cambia el color del contenedor según el estado de la tarea
    if (taskName == 'New Task') {
      return Colors.blue;
    } else if (taskName == 'In Progress') {
      return Colors.yellow;
    } else if (taskName == 'Blocked') {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}
