import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                margin: const EdgeInsets.only(
                  top: 30,
                  left: 30,
                  right: 30,
                ),
                width: w * 0.8,
                height: h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          router.push('/todo-screen');
                        }, 
                        child: Text(
                          "Todo",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
