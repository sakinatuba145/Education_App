import 'package:dio/dio.dart';
import 'package:education_app/quiz/quiz_model.dart';

class QuizService {

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://your-api.com/',
      connectTimeout: const Duration(seconds: 10),
    ),
  );

  // GET all quizzes
  Future<List<QuizModel>> getQuizzes() async {

    final response = await dio.get('quizzes');

    return (response.data as List)
        .map((e) => QuizModel.fromJson(e))
        .toList();
  }

  // GET single quiz
  Future<QuizModel> getQuizById(String id) async {

    final response = await dio.get('quizzes/$id');

    return QuizModel.fromJson(response.data);
  }

  // POST result
  Future<void> submitResult({
    required String quizId,
    required int score,
  }) async {

    await dio.post(
      'quiz-result',
      data: {
        "quizId": quizId,
        "score": score,
      },
    );
  }
}