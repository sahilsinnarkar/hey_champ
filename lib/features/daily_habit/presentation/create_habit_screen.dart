import 'package:flutter/material.dart';
import 'package:hey_champ_app/common/widgets/my_button.dart';
import 'package:hey_champ_app/common/widgets/my_textfield.dart';
import 'package:hey_champ_app/common/widgets/screen_name.dart';
import 'package:hey_champ_app/core/constants/color_constants.dart';
import 'package:hey_champ_app/features/daily_habit/application/habit_model.dart';
import 'package:hey_champ_app/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../application/habit_controller.dart';

class CreateHabitScreen extends StatefulWidget {
  const CreateHabitScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateHabitScreenState createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  final _titleController = TextEditingController();
  final _taskController = TextEditingController();
  final List<String> _tasks = [];
  int _days = 7;

  void _addHabit() {
    if (_titleController.text.trim().isEmpty || _tasks.isEmpty || _days < 7) {
      return;
    }

    final startDate = DateTime.now();
    final dailyStatus = {
      for (int i = 0; i < _days; i++)
        startDate.add(Duration(days: i)).toIso8601String().split('T')[0]: {
          for (var t in _tasks) t: false,
        },
    };

    final habit = Habit(
      id: Uuid().v4(),
      title: _titleController.text.trim(),
      tasks: List.from(_tasks),
      startDate: startDate,
      durationDays: _days,
      dailyStatus: dailyStatus,
    );

    context.read<HabitController>().addHabit(habit);
    router.pop();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            ScreenName(name: "Create Habit"),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    MyTextField(
                      controller: _titleController,
                      hintText: "Habit Title",
                      height: h * 0.06,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "Days: ",
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 16,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            activeColor: AppColors.divider,
                            inactiveColor: AppColors.divider,
                            thumbColor: AppColors.primaryText,
                            value: _days.toDouble(),
                            min: 7,
                            max: 30,
                            divisions: 23,
                            label: _days.toString(),
                            onChanged: (v) => setState(() => _days = v.toInt()),
                          ),
                        ),
                        Text(
                          "$_days",
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            controller: _taskController,
                            hintText: "Enter task",
                            height: h * 0.06,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: h * 0.06,
                          width: h * 0.06,
                          decoration: BoxDecoration(
                            color: AppColors.primaryText,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: AppColors.background,
                            ),
                            onPressed: () {
                              final value = _taskController.text.trim();
                              if (value.isNotEmpty) {
                                setState(() {
                                  _tasks.add(value);
                                  _taskController.clear();
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 8,
                      children: _tasks
                          .map((e) => Chip(
                            label: Text(
                              e,
                              style: TextStyle(
                                color: AppColors.background,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: AppColors.primaryText,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ))
                          .toList(),
                    ),
                    MyButton(text: "Save", onPressed: _addHabit),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
