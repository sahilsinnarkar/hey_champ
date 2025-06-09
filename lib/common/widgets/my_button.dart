import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isFilled;
  final double width;
  final double height;

  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isFilled = true,
    this.width = double.infinity,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isFilled ? Colors.white : Colors.transparent,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isFilled ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }
}
