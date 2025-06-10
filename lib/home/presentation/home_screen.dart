import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hey_champ_app/common/widgets/animated_typing_text.dart';
import 'package:hey_champ_app/common/widgets/image_buttons.dart';
import 'package:hey_champ_app/core/constants/color_constants.dart';
import 'package:hey_champ_app/routes/app_routes.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String time;
  late String formattedDate;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime(); // initialize immediately
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      time = DateFormat('hh:mm a').format(now);
      formattedDate = DateFormat('dd/MM/yyyy').format(now);
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // always cancel timers in dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 50),
              width: w * 0.95,
              height: h * 0.2,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        time,
                        style: GoogleFonts.rubik(
                          textStyle: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: GoogleFonts.rubik(
                          textStyle: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Welcome back, Champ!",
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    "assets/images/trophy.png",
                    fit: BoxFit.contain,
                    width: 130,
                    height: 130,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(20),
              height: h * 0.7,
              width: w,
              decoration: BoxDecoration(
                color: AppColors.primaryText,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Container(
                width: w * 0.8,
                height: h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        router.push('/chatbot-screen');
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        width: w,
                        height: h * 0.15,
                        decoration: BoxDecoration(
                          color: AppColors.primaryText,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.whiteShadow,
                              blurRadius: 10,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      alignment: Alignment.centerLeft,
                                      height: h * 0.07,
                                      width: w * 0.47,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.secondaryText,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: AnimatedTypingText(
                                        text: "Ask anything...!",
                                        style: GoogleFonts.rubik(
                                          textStyle: TextStyle(
                                            color: AppColors.background,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Introducing our Chatbot!",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.buttonBackground,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: w * 0.3,
                                height: h * 0.3,
                                child: Image.asset(
                                  "assets/images/bot.jpg",
                                  fit: BoxFit.contain,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: GridView.count(
                        physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        mainAxisSpacing: 30.0,
                        crossAxisSpacing: 50.0,
                        padding: const EdgeInsets.all(10.0),
                        children: [
                          ImageButtons(
                            imageUrl: "assets/images/reminder.png",
                            screenName: 'reminder',
                          ),
                          ImageButtons(
                            imageUrl: "assets/images/todo.png",
                            screenName: 'todo-screen',
                          ),
                          ImageButtons(
                            imageUrl: "assets/images/take_note.png",
                            screenName: 'note-list-screen',
                          ),
                          ImageButtons(
                            imageUrl: "assets/images/study.png",
                            screenName: 'subject-screen',
                          ),
                          ImageButtons(
                            imageUrl: "assets/images/habits.png",
                            screenName: 'daily-habit-tracker-list-screen',
                          ),
                          ImageButtons(
                            imageUrl: "assets/images/expenses.png",
                            screenName: 'expenses-list-screen',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
