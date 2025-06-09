import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hey_champ_app/common/widgets/my_button.dart';
import 'package:hey_champ_app/common/widgets/my_textfield.dart';
import 'package:hey_champ_app/core/constants/color_constants.dart';
import 'package:hey_champ_app/features/auth/application/auth_service.dart';
import 'package:hey_champ_app/routes/app_routes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signin() async {
    try {
      await authServices.value.signin(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          Container(color: Colors.white),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: w,
              color: AppColors.background,
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        "Sign In",
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Sign in to your account",
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(top: 15),
                    width: w,
                    height: h * 0.38,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          MyTextField(
                            controller: emailController,
                            hintText: "Email",
                          ),
                          const SizedBox(height: 20),
                          MyTextField(
                            controller: passwordController,
                            hintText: "Password",
                          ),
                          const SizedBox(height: 30),
                          MyButton(
                            text: "Sign In",
                            onPressed: () {
                              signin();
                              router.push('/home');
                            },
                            isFilled: true,
                          ),
                          const SizedBox(height: 15),
                          RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Register!',
                                  style: const TextStyle(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Navigate to sign-up screen using GoRouter
                                      context.push('/signup');
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
