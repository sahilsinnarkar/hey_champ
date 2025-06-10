import 'package:flutter/material.dart';
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
    if (_titleController.text.trim().isEmpty || _tasks.isEmpty || _days < 7) return;

    final startDate = DateTime.now();
    final dailyStatus = {
      for (int i = 0; i < _days; i++)
        startDate.add(Duration(days: i)).toIso8601String().split('T')[0]: {
          for (var t in _tasks) t: false
        }
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
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Habit")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: "Habit Title")),
            Row(
              children: [
                Text("Days: "),
                Expanded(
                  child: Slider(
                    value: _days.toDouble(),
                    min: 7,
                    max: 30,
                    divisions: 23,
                    label: _days.toString(),
                    onChanged: (v) => setState(() => _days = v.toInt()),
                  ),
                ),
                Text("$_days"),
              ],
            ),
            TextField(
              controller: _taskController,
              decoration: InputDecoration(labelText: "Add Task"),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  setState(() {
                    _tasks.add(value.trim());
                    _taskController.clear();
                  });
                }
              },
            ),
            Wrap(
              spacing: 8,
              children: _tasks.map((e) => Chip(label: Text(e))).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addHabit();
                router.pop();
              }, 
              child: Text(
                "Save Habit",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
