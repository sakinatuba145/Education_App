import 'package:education_app/quiz/quiz_model.dart';
import 'package:education_app/quiz/quiz_services.dart';

class QuizRepository {
  final QuizService service = QuizService();

  Future<List<QuizModel>> fetchQuizzes() {
    return service.getQuizzes();
  }

  Future<QuizModel> fetchQuiz(String id) {
    return service.getQuizById(id);
 }

  Future<void> sendResult(String id, int score) {
    return service.submitResult(quizId: id, score: score);
  }
}
