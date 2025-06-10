import 'package:flutter/material.dart';
import 'package:hey_champ_app/routes/app_routes.dart';
import 'package:provider/provider.dart';
import '../application/habit_controller.dart';

class DailyHabitTrackerListScreen extends StatefulWidget {
  const DailyHabitTrackerListScreen({super.key});

  @override
  State<DailyHabitTrackerListScreen> createState() =>
      _DailyHabitTrackerListScreenState();
}

class _DailyHabitTrackerListScreenState
    extends State<DailyHabitTrackerListScreen> {
  @override
  Widget build(BuildContext context) {
    final habits = context.watch<HabitController>().habits;

    return Scaffold(
      appBar: AppBar(title: Text("Daily Habit Tracker")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          router.push('/create-habit-screen');
        },
        child: Icon(Icons.add),
      ),
      body: habits.isEmpty
          ? Center(child: Text("No habits..."))
          : ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                return ListTile(
                  title: Text(habit.title),
                  subtitle: Text("${habit.tasks.length} tasks"),
                  onTap: () {
                    router.push('/habit-detail-screen', extra: habit);
                  }
                );
              },
            ),
    );
  }
}
