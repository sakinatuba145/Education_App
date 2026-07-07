import 'package:education_app/core/I18n/app_locales.dart';
import 'package:education_app/core/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'core/I18n/translations.dart';
import 'features/forgot_password.dart';
import 'firebase_options.dart';
import 'theme_provider.dart';
import 'core/helpers/shared_preferences_helper.dart';
import 'features/welcome_screen.dart';
import 'features/login_screen.dart';
import 'features/register_screen.dart';
import 'teacher/screens/teacher_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SharedPreferencesHelper.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..loadTheme(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: AppLocales.deviceLocale,
      fallbackLocale: Locale('en'),

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        ForgotPasswordScreen.id: (context) => ForgotPasswordScreen(),
        TeacherDashboardScreen.id: (context) => TeacherDashboardScreen(),
      },

      initialRoute: WelcomeScreen.id,
    );
  }
}
