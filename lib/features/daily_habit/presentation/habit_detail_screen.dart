import 'package:flutter/material.dart';
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
    context.read<HabitController>().toggleTaskStatus(widget.habit.id, date, task);
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Habit Details"),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () => setState(() {
              if (_isEditing) {
                _saveChanges();
              } else {
                _isEditing = true;
              }
            }),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          if (_isEditing)
            TextField(controller: _titleController)
          else
            Text(habit.title, style: Theme.of(context).textTheme.titleLarge),
          if (_isEditing)
            Slider(
              value: _days.toDouble(),
              min: 7,
              max: 30,
              divisions: 23,
              label: _days.toString(),
              onChanged: (v) => setState(() => _days = v.toInt()),
            ),
          Expanded(
            child: ListView(
              children: habit.dailyStatus.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold)),
                    ...entry.value.entries.map((task) => CheckboxListTile(
                          value: task.value,
                          title: Text(task.key),
                          onChanged: (val) => _toggleComplete(entry.key, task.key),
                        )),
                  ],
                );
              }).toList(),
            ),
          ),
        ]),
      ),
    );
  }
}
