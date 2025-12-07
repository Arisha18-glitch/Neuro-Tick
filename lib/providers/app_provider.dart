import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/quiz_service.dart';

class AppProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final QuizService _quizService = QuizService();

  // Auth getters
  bool get isLoggedIn => _authService.isLoggedIn;
  String? get userName => _authService.userName;
  int get loginCount => _authService.loginCount;

  // Quiz getters
  int get totalQuizzesTaken => _quizService.totalQuizzesTaken;
  int get totalScore => _quizService.totalScore;
  Map<String, int> get subjectScores => _quizService.subjectScores;
  List<Map<String, dynamic>> get recentQuizzes => _quizService.recentQuizzes;

  // Auth methods
  Future<void> login(String email, String password) async {
    await _authService.login(email, password);
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }

  // Quiz methods
  Future<void> submitQuizScore({
    required String subject,
    required int score,
    required int totalQuestions,
    required int level,
  }) async {
    await _quizService.submitQuizScore(
      subject: subject,
      score: score,
      totalQuestions: totalQuestions,
      level: level,
    );
    notifyListeners();
  }

  Map<String, dynamic> getUserProgress() {
    return _quizService.getUserProgress();
  }

  void resetQuizData() {
    _quizService.resetData();
    notifyListeners();
  }
}