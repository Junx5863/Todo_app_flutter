import 'package:dash_todo_app/core/styles/app_them.dart';
import 'package:dash_todo_app/features/home_view/presentation/bloc/home_dash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

Future<dynamic> modalBottomSheetCard({
  required BuildContext context,
  required String title,
  required void Function() onSelected,
  required HomeDashCubit cubit,
  required HomeDashState state,
  String? dueTo,
  DateTime? dateTime,
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
                          vertical: 16,
                        ),
                        child: TextField(
                          controller: state.titleController,
                          decoration: InputDecoration(
                            labelText: 'Task Name',
                            labelStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade500),
                            ),
                          ),
                        ),
                      ),
                      if (!title.contains('Add Task')) ...[
                        IsDoneCheckBox(
                          bloc: cubit,
                          isChecked: isChecked ?? false,
                        ),
                      ],
                      DaySelectTask(
                        cubit: cubit,
                        dateTime: dateTime,
                        dueTo: dueTo,
                      ),
                      CategorySelector(
                        cubit: cubit,
                        state: state,
                        category: category,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: ElevatedButton(
                          onPressed: onSelected,
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

class IsDoneCheckBox extends StatelessWidget {
  final bool isChecked;
  final HomeDashCubit bloc;
  IsDoneCheckBox({
    super.key,
    required this.bloc,
    this.isChecked = false,
  }) : valueIsDone = ValueNotifier(isChecked);

  final ValueNotifier<bool> valueIsDone;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: valueIsDone,
        builder: (BuildContext context, bool isChecked, Widget? child) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
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
            child: CheckboxListTile(
              title: Text(
                'Task Completed',
                style: TextStyle(
                  color: AppColors.grey600,
                  fontSize: 14,
                ),
              ),
              value: isChecked,
              onChanged: (value) {
                valueIsDone.value = value!;
                bloc.setCheckIsDone(isDone: value);
              },
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColors.primary,
              checkColor: AppColors.white,
            ),
          );
        });
  }
}

class DaySelectTask extends StatelessWidget {
  DaySelectTask({
    super.key,
    required this.cubit,
    this.dueTo,
    this.dateTime,
  }) : indexCustom = ValueNotifier(dueTo ?? 'Today');

  final String? dueTo;
  final DateTime? dateTime;
  final List<String> options = ['Today', 'Tomorrow', 'Custom'];
  final ValueNotifier<String> indexCustom;
  final HomeDashCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
        valueListenable: indexCustom,
        builder: (BuildContext context, String selectedOption, Widget? child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Due To',
                style: TextStyle(
                  color: AppColors.grey600,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: List.generate(
                  options.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        indexCustom.value = options[index];
                        cubit.dateTask(dueTo: indexCustom.value);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: indexCustom.value == options[index]
                              ? AppColors.primary
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black12,
                              blurRadius: 10,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          options[index],
                          style: TextStyle(
                            color: indexCustom.value == options[index]
                                ? AppColors.white
                                : AppColors.grey600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (indexCustom.value == 'Custom') ...[
                // Show custom date picker if "Custom" is selected
                const SizedBox(height: 16),
                Text(
                  'Select a date',
                  style: TextStyle(
                    color: AppColors.grey600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                ScrollableWeekDaySelector(
                  weekLimit: 4,
                  cubit: cubit,
                  dateTime: dateTime ?? DateTime.now(),
                )
              ],
            ],
          );
        });
  }
}

class ScrollableWeekDaySelector extends StatefulWidget {
  final int weekLimit;
  final HomeDashCubit cubit;
  final DateTime? dateTime;

  const ScrollableWeekDaySelector({
    super.key,
    this.weekLimit = 4,
    this.dateTime,
    required this.cubit,
  });

  @override
  State<ScrollableWeekDaySelector> createState() =>
      _ScrollableWeekDaySelectorState();
}

class _ScrollableWeekDaySelectorState extends State<ScrollableWeekDaySelector> {
  DateTime today = DateTime.now();
  late List<DateTime> allDates;
  late ValueNotifier<DateTime> selectedDate;

  @override
  void initState() {
    super.initState();
    _generateDates();
    selectedDate = ValueNotifier(widget.dateTime ?? today);
  }

  @override
  void dispose() {
    selectedDate.dispose();
    super.dispose();
  }

  void _generateDates() {
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday % 7));
    int totalDays = widget.weekLimit * 7;
    allDates =
        List.generate(totalDays, (i) => startOfWeek.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ValueListenableBuilder<DateTime>(
          valueListenable: selectedDate,
          builder: (BuildContext context, DateTime selectedDateValue,
              Widget? child) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: allDates.length,
              itemBuilder: (context, index) {
                DateTime date = allDates[index];
                bool isPast =
                    date.isBefore(DateTime(today.year, today.month, today.day));
                bool isSelected = _isSameDate(date, selectedDateValue);

                return GestureDetector(
                  onTap: isPast
                      ? null
                      : () {
                          selectedDate.value = DateTime.parse(
                              DateFormat(date.toString()).format(date));
                          widget.cubit.dateTask(
                            dueTo: 'Custom',
                            dateTime: selectedDate.value.toString(),
                          );
                        },
                  child: Container(
                    width: 50,
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.grey.shade700
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('E').format(date).toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getDayColor(date),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isPast ? AppColors.black45 : AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  bool _isSameDate(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  Color _getDayColor(DateTime date) {
    switch (date.weekday) {
      case DateTime.saturday:
      case DateTime.sunday:
        return AppColors.red700;
      default:
        return Colors.white;
    }
  }
}

class CategorySelector extends StatefulWidget {
  const CategorySelector({
    super.key,
    required this.cubit,
    required this.state,
    this.category,
  });
  final HomeDashCubit cubit;
  final HomeDashState state;
  final String? category;
  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late ValueNotifier<String> selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = ValueNotifier(widget.category ?? '');
  }

  @override
  void dispose() {
    selectedCategory.dispose();
    super.dispose();
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
                  'Categories',
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
                          widget.state.categories[index].name;

                      return GestureDetector(
                        onTap: () {
                          selectedCategory.value =
                              widget.state.categories[index].name!;

                          widget.cubit.categoryTask(
                            category: widget.state.categories[index].name!,
                            categoryId:
                                widget.state.categories[index].idcategory!,
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
                              widget.state.categories[index].name!,
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
