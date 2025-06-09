import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/color_constants.dart';

/// Custom Date Picker Field
class MyDatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const MyDatePickerField({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: w * 0.45,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            style: BorderStyle.solid,
            width: 2,
            color: AppColors.primaryText,
          ),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          selectedDate != null
              ? DateFormat('dd/MM/yyyy').format(selectedDate!)
              : "Select Date",
          style: TextStyle(
            color: selectedDate != null
                ? AppColors.primaryText
                : AppColors.secondaryText,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

/// Custom Time Picker Field
class MyTimePickerField extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final VoidCallback onTap;

  const MyTimePickerField({
    super.key,
    required this.selectedTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: w * 0.45,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            style: BorderStyle.solid,
            width: 2,
            color: AppColors.primaryText,
          ),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          selectedTime != null
              ? selectedTime!.format(context)
              : "Select Time",
          style: TextStyle(
            color: selectedTime != null
                ? AppColors.primaryText
                : AppColors.secondaryText,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
