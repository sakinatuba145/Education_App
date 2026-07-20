import 'dart:ui';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/theme.dart';
import '../core/I18n/messages.dart';
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ThemeColors.gradient1,
                  ThemeColors.gradient2,
                  ThemeColors.gradient3,
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
                          color: Colors.white.withOpacity(.18),
                          border: Border.all(
                            color: Colors.white.withOpacity(.4),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(.25),
                              blurRadius: 50,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            "assets/images/hazara.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: Text(
                      "HSAI",
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),


                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: Text(
                      'Hazara Students Association - India ',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: Text(
                      AppMessages.start.tr,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  FadeInUp(
                    delay: const Duration(milliseconds: 700),
                    child: Text(
                      AppMessages.discover.tr,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
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
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primaryLight,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(.35),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Text(
                                AppMessages.getStarted.tr,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Icon(
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
                    AppMessages.poweredBy.tr,
                    style: Theme.of(context).textTheme.bodySmall,
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
          color: AppColors.primaryLight.withOpacity(.25),
        ),
      ),
    );
  }
}