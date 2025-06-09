import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hey_champ_app/core/constants/color_constants.dart';
import 'package:hey_champ_app/features/reminder/application/reminder_controller.dart';
import 'package:hey_champ_app/routes/app_routes.dart';
import 'package:intl/intl.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {

  @override
  Widget build(BuildContext context) {
    final reminders = ReminderController.getReminders();

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Reminder",
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            reminders.isEmpty
                ? Center(
                    child: Text(
                      'No reminders',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : Expanded(
                  child: ListView.builder(
                      itemCount: reminders.length,
                      itemBuilder: (context, index) {
                        final reminder = reminders[index];
                        return ListTile(
                          title: Text(
                            reminder.title,
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat('MMM d, yyyy • hh:mm a').format(reminder.dateTime).toString(),
                            style: TextStyle(
                              color: AppColors.primaryText,
                            ),
                          ),
                          trailing: Text(
                            reminder.repeat,
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 15,
                            ),
                          ),
                        );
                      },
                    ),
                ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            router.push('/new-reminder');
          },
          backgroundColor: AppColors.primaryText,
          shape: CircleBorder(),
          tooltip: 'Add Reminder',
          child: const Icon(Icons.add, color: AppColors.background),
        ),
      ),
    );
  }
}
