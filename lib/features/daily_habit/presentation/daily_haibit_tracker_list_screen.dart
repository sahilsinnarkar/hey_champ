import 'package:flutter/material.dart';
import 'package:hey_champ_app/common/widgets/screen_name.dart';
import 'package:hey_champ_app/core/constants/color_constants.dart';
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryText,
          foregroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () {
            router.push('/create-habit-screen');
          },
          child: Icon(Icons.add, size: 30),
        ),
        body: Column(
          children: [
            ScreenName(name: "Daily Habits"),
            Expanded(
              child: habits.isEmpty
                  ? Center(
                      child: Text(
                        "No habits...",
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: habits.length,
                      itemBuilder: (context, index) {
                        final habit = habits[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryText,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            title: Text(
                              habit.title,
                              style: const TextStyle(
                                color: AppColors.background,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(
                              "${habit.tasks.length} task${habit.tasks.length == 1 ? '' : 's'}",
                              style: const TextStyle(
                                color: AppColors.background,
                              ),
                            ),
                            onTap: () {
                              router.push('/habit-detail-screen', extra: habit);
                            },
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: AppColors.background,
                              ),
                              onPressed: () {
                                context.read<HabitController>().deleteHabit(
                                  habit.id,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
