import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hey_champ_app/common/widgets/my_button.dart';
import 'package:hey_champ_app/common/widgets/my_date_time_fields.dart';
import 'package:hey_champ_app/common/widgets/my_textfield.dart';
import 'package:hey_champ_app/common/widgets/screen_name.dart';
import 'package:hey_champ_app/core/constants/color_constants.dart';
import 'package:hey_champ_app/features/reminder/application/reminder_controller.dart';
import 'package:hey_champ_app/features/reminder/application/reminder_model.dart';

class NewReminderScreen extends StatefulWidget {
  const NewReminderScreen({super.key});

  @override
  State<NewReminderScreen> createState() => _NewReminderScreenState();
}

class _NewReminderScreenState extends State<NewReminderScreen> {
  final titleController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String repeat = 'None';

  @override
  void initState() {
    super.initState();
    ReminderController.initNotifications();
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      barrierColor: AppColors.background.withAlpha(200),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      barrierColor: AppColors.background.withAlpha(200),
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  void _saveReminder() {
    if (titleController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please complete all fields")));
      return;
    }

    final dt = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final reminder = Reminder(
      title: titleController.text,
      dateTime: dt,
      repeat: repeat,
    );

    ReminderController.scheduleReminder(reminder);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              ScreenName(name: "New Reminder"),
              Container(
                padding: const EdgeInsets.all(10),
                width: w,
                height: h,
                child: Column(
                  children: [
                    MyTextField(
                      controller: titleController,
                      hintText: "Title",
                      height: 80,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyDatePickerField(
                          onTap: () {
                            _pickDate();
                          },
                          selectedDate: selectedDate,
                        ),
                        MyTimePickerField(
                          onTap: () {
                            _pickTime();
                          },
                          selectedTime: selectedTime,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(left: 12),
                      height: h * 0.08,
                      width: w,
                      decoration: BoxDecoration(
                        border: Border.all(
                          style: BorderStyle.solid,
                          width: 2,
                          color: AppColors.primaryText,
                        ),
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Repeat: ",
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 10),
                          DropdownButton<String>(
                            value: repeat,
                            dropdownColor: AppColors.background,
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 16,
                            ),
                            items: ['None', 'Daily', 'Weekly', 'Monthly']
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                repeat = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    MyButton(onPressed: _saveReminder, text: "Save"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
