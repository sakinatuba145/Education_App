import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:education_app/features/login_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  static String id = 'welcome_screen';

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [


          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xffFFF8F0),
                  Color(0xffFFE0B2),
                  Color(0xffFFD180),
                ],
              ),
            ),
          ),

          Positioned(
            top: -80,
            right: -50,
            child: _blurCircle(220),
          ),

          Positioned(
            bottom: -100,
            left: -60,
            child: _blurCircle(250),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                children: [

                  const Spacer(),


                  FadeInDown(
                    duration: const Duration(milliseconds: 1200),
                    child: Hero(
                      tag: "logo",
                      child: Container(
                        height: 220,
                        width: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white.withOpacity(.45),
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(.25),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            "assets/images/EDU.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: const Text(
                      "EduAf",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: const Text(
                      "Learn • Grow • Build Your Future",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  FadeInUp(
                    delay: const Duration(milliseconds: 700),
                    child: Text(
                      "Discover a new way of learning with modern courses, expert teachers and unlimited opportunities.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  const Spacer(),


                  FadeInUp(
                    delay: const Duration(milliseconds: 1000),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          LoginScreen.id,
                        );
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                        color:Color(0xFFf5b400),

                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Text(
                                "Get Started",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "Powered by EduAf",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _blurCircle(double size) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 80,
        sigmaY: 80,
      ),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.orange.withOpacity(.25),
        ),
      ),
    );
  }
}