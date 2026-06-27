import 'package:education_app/courses/course_screen.dart';
import 'package:education_app/quiz/quiz_model.dart';
import 'package:education_app/quiz/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'features/forgot_password.dart';
import 'firebase_options.dart';

import 'courses/course_bloc.dart';
import 'theme_provider.dart';

import 'core/constants/theme.dart';
import 'core/helpers/shared_preferences_helper.dart';
import 'features/welcome_screen.dart';
import 'features/login_screen.dart';
import 'features/register_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'teacher/screens/teacher_dashboard_screen.dart';
import 'teacher/screens/course_creation_screen.dart';
import 'quiz/create_exam_screen.dart';
import 'profile/profile_screen.dart';
import 'profile/settings_screen.dart';
import 'profile/progress_screen.dart';
import 'profile/favorites_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SharedPreferencesHelper.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseBloc()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..loadTheme()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        ForgotPasswordScreen.id: (context) => ForgotPasswordScreen(),
        DashboardScreen.id: (context) => DashboardScreen(),
        TeacherDashboardScreen.id: (context) => const TeacherDashboardScreen(),
        CourseCreationScreen.id: (context) => const CourseCreationScreen(),
        'profile_screen': (context) => const ProfileScreen(),
        'settings_screen': (context) => const SettingsScreen(),
        'progress_screen': (context) => const ProgressScreen(),
        'favorites_screen': (context) => const FavoritesScreen(),
        'teacher_create_exam': (context) => const TeacherCreateExamScreen(),
        CourseScreen.id: (context) => CourseScreen(),
        QuizScreen.id: (context) => QuizScreen(
              exam: ModalRoute.of(context)!.settings.arguments as ExamModel,
            ),
      },
      initialRoute: WelcomeScreen.id,
    );
  }
}
