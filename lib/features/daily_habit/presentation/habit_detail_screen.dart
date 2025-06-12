import 'package:flutter/material.dart';
import 'package:hey_champ_app/common/widgets/screen_name.dart';
import 'package:hey_champ_app/core/constants/color_constants.dart';
import 'package:hey_champ_app/features/daily_habit/application/habit_model.dart';
import 'package:provider/provider.dart';
import '../application/habit_controller.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;
  const HabitDetailScreen({super.key, required this.habit});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  bool _isEditing = false;
  late TextEditingController _titleController;
  late int _days;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.habit.title);
    _days = widget.habit.durationDays;
    super.initState();
  }

  void _toggleComplete(String date, String task) {
    context.read<HabitController>().toggleTaskStatus(
      widget.habit.id,
      date,
      task,
    );
  }

  void _saveChanges() {
    if (_days < 7) return;
    widget.habit.title = _titleController.text;
    widget.habit.durationDays = _days;
    context.read<HabitController>().updateHabit(widget.habit);
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final habit = widget.habit;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            ScreenName(name: "Habit Details"),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _isEditing
                              ? TextField(
                                  controller: _titleController,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryText,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                )
                              : Text(
                                  habit.title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isEditing ? Icons.check : Icons.edit,
                            color: AppColors.primaryText,
                          ),
                          onPressed: () {
                            setState(() {
                              if (_isEditing) {
                                _saveChanges();
                              } else {
                                _isEditing = true;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (_isEditing)
                      Slider(
                        value: _days.toDouble(),
                        min: 7,
                        max: 30,
                        divisions: 23,
                        activeColor: AppColors.divider,
                        thumbColor: AppColors.primaryText,
                        label: _days.toString(),
                        onChanged: (v) => setState(() => _days = v.toInt()),
                      ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Consumer<HabitController>(
                        builder: (context, controller, _) {
                          final updatedHabit = controller.habits.firstWhere(
                            (h) => h.id == habit.id,
                            orElse: () => habit,
                          );

                          return ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: updatedHabit.dailyStatus.entries.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final entry = updatedHabit.dailyStatus.entries
                                  .elementAt(index);
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.key,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                    ...entry.value.entries.map(
                                      (task) => CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        activeColor: AppColors.primaryText,
                                        checkColor: AppColors.background,
                                        value: task.value,
                                        title: Text(
                                          task.key,
                                          style: const TextStyle(
                                            color: AppColors.primaryText,
                                            fontSize: 16,
                                          ),
                                        ),
                                        onChanged: (_) => _toggleComplete(
                                          entry.key,
                                          task.key,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
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
