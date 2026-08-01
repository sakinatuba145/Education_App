import 'package:flutter/material.dart';

import '../../constants/theme.dart';


class QuizLoadingView extends StatelessWidget {
  const QuizLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        title: const Text('Quizzes'),
        elevation: 0,
        centerTitle: true,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}