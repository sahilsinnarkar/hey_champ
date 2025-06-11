import 'package:flutter/material.dart';
import 'package:hey_champ_app/common/widgets/screen_name.dart';
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
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            ScreenName(name: "Reminders"),
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
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.05,
                            vertical: h * 0.01,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: w * 0.05,
                              vertical: h * 0.01,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            tileColor: AppColors.secondaryText,
                            title: Text(
                              reminder.title,
                              style: TextStyle(
                                color: AppColors.background,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              DateFormat(
                                'MMM d, yyyy • hh:mm a',
                              ).format(reminder.dateTime).toString(),
                              style: TextStyle(color: AppColors.background),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  reminder.repeat,
                                  style: TextStyle(
                                    color: AppColors.background,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 5),
                                IconButton(
                                  icon: Icon(Icons.delete, color: const Color.fromARGB(255, 118, 13, 5)),
                                  onPressed: () async {
                                    await ReminderController.deleteReminder(
                                      reminder,
                                    );
                                    setState(() {}); // Refresh UI
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Reminder deleted"),
                                      ),
                                    );
                                  },
                                ),
                              ],
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
