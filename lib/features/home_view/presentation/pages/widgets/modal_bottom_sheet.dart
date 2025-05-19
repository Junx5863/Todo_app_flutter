import 'package:dash_todo_app/core/styles/app_them.dart';
import 'package:dash_todo_app/features/home_view/presentation/bloc/home_dash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';

Future<dynamic> modalBottomSheetCard({
  required BuildContext context,
  required String title,
  required void Function() onSelected,
  required HomeDashCubit cubit,
  required HomeDashState state,
  String? category,
  bool? isChecked,
}) {
  return showModalBottomSheet(
    context: context,
    scrollControlDisabledMaxHeightRatio: 20,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return KeyboardDismissOnTap(
        dismissOnCapturedTaps: true,
        child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.85,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Wrap(
                    children: [
                      Center(
                        child: Container(
                          height: 4,
                          width: 40,
                          color: Colors.grey[300],
                          margin: const EdgeInsets.only(bottom: 16),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.background,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black12,
                                  blurRadius: 10,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () => context.pop(),
                              icon: Icon(Icons.close, color: AppColors.grey600),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: textFielInfoTask(
                          state: state,
                          cubit: cubit,
                          controller: state.titleController,
                          labelText: 'Task Name',
                          onChanged: (value) {
                            cubit.setTextTask(
                              titleTask: value,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 0,
                        ),
                        child: textFielInfoTask(
                          state: state,
                          cubit: cubit,
                          controller: state.descriptionController,
                          labelText: 'Description Name',
                          maxLines: 3,
                          maxLength: 100,
                          onChanged: (value) {
                            cubit.setTextTask(
                              descriptionTask: value,
                            );
                          },
                        ),
                      ),
                      StatusSelector(
                        cubit: cubit,
                        state: state,
                        statusTask: category,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: ElevatedButton(
                          onPressed: () => onSelected,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Save',
                              style: TextStyle(
                                color: AppColors.buttonText,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      );
    },
  );
}

TextField textFielInfoTask({
  required HomeDashState state,
  required HomeDashCubit cubit,
  required void Function(String) onChanged,
  required String labelText,
  required TextEditingController controller,
  int? maxLines,
  int? maxLength,
}) {
  return TextField(
    controller: controller,
    onChanged: onChanged,
    maxLength: maxLength,
    maxLines: maxLines ?? 1,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.grey[600],
        fontSize: 14,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade500),
      ),
    ),
  );
}

class StatusSelector extends StatefulWidget {
  const StatusSelector({
    super.key,
    required this.cubit,
    required this.state,
    this.statusTask,
  });
  final HomeDashCubit cubit;
  final HomeDashState state;
  final String? statusTask;
  @override
  State<StatusSelector> createState() => _StatusSelectorState();
}

class _StatusSelectorState extends State<StatusSelector> {
  late ValueNotifier<String> selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = ValueNotifier(widget.statusTask ?? '');
    updateSelectedCategory(
      widget.statusTask ?? widget.state.categories.first.statuName!,
    );
  }

  @override
  void dispose() {
    selectedCategory.dispose();
    super.dispose();
  }

  void updateSelectedCategory(String newCategory) {
    widget.cubit.updateTaskState(
      category: newCategory,
      statusId: widget.state.categories
          .firstWhere((category) => category.statuName == newCategory)
          .statusId!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ValueListenableBuilder<String>(
          valueListenable: selectedCategory,
          builder: (BuildContext context, String selectedIndex, Widget? child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.state.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      bool isSelected = selectedCategory.value ==
                          widget.state.categories[index].statuName;

                      return GestureDetector(
                        onTap: () {
                          selectedCategory.value =
                              widget.state.categories[index].statuName!;

                          updateSelectedCategory(
                            widget.state.categories[index].statuName!,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.state.categories[index].statuName!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}
