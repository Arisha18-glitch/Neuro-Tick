import 'package:flutter/foundation.dart';
import '../data/quiz_questions.dart';

class QuizService extends ChangeNotifier {
  int _totalQuizzesTaken = 0;
  int _totalScore = 0;
  Map<String, int> _subjectScores = {};
  List<Map<String, dynamic>> _recentQuizzes = [];

  int get totalQuizzesTaken => _totalQuizzesTaken;
  int get totalScore => _totalScore;
  Map<String, int> get subjectScores => _subjectScores;
  List<Map<String, dynamic>> get recentQuizzes => _recentQuizzes;

  // Submit quiz score
  Future<void> submitQuizScore({
    required String subject,
    required int score,
    required int totalQuestions,
    required int level,
  }) async {
    _totalQuizzesTaken++;
    _totalScore += score;

    // Update subject score
    _subjectScores.update(
      subject,
          (value) => value + score,
      ifAbsent: () => score,
    );

    // Add to recent quizzes
    _recentQuizzes.insert(0, {
      'subject': subject,
      'score': score,
      'total': totalQuestions,
      'level': level,
      'date': DateTime.now(),
    });

    // Keep only last 5 quizzes
    if (_recentQuizzes.length > 5) {
      _recentQuizzes.removeLast();
    }

    notifyListeners();
  }

  // Get user progress
  Map<String, dynamic> getUserProgress() {
    return {
      'totalQuizzes': _totalQuizzesTaken,
      'averageScore': _totalQuizzesTaken > 0
          ? (_totalScore / _totalQuizzesTaken).toStringAsFixed(1)
          : '0.0',
      'favoriteSubject': _getFavoriteSubject(),
      'totalScore': _totalScore,
    };
  }

  String _getFavoriteSubject() {
    if (_subjectScores.isEmpty) return 'None';

    return _subjectScores.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  // Reset all data
  void resetData() {
    _totalQuizzesTaken = 0;
    _totalScore = 0;
    _subjectScores.clear();
    _recentQuizzes.clear();
    notifyListeners();
  }
}