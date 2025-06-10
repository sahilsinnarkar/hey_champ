import 'package:flutter/material.dart';
import 'package:hey_champ_app/core/constants/color_constants.dart';
import 'package:hey_champ_app/routes/app_routes.dart';

// ignore: must_be_immutable
class ImageButtons extends StatelessWidget {
  String imageUrl;
  String screenName;

  ImageButtons({super.key, required this.imageUrl, required this.screenName});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        router.push('/$screenName');
      },
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(10),
        width: w * 0.3,
        height: h * 0.12,
        decoration: BoxDecoration(
          color: AppColors.primaryText,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.whiteShadow,
              blurRadius: 10,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Image.asset(
          imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
