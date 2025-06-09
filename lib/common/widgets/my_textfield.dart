import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';

class MyTextField extends StatelessWidget {

  final TextEditingController controller;
  final String hintText;
  final double height;

  const MyTextField({super.key, required this.controller, required this.hintText, this.height = 50});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(left: 10),
      width: w,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          style: BorderStyle.solid,
          width: 2,
          color: AppColors.primaryText,
        ),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
