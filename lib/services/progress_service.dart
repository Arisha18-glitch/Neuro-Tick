import 'package:shared_preferences/shared_preferences.dart';
// Add this import
import '../services/achievement_service.dart';

class ProgressService {
  static const String _quizScoresKey = 'quiz_scores';
  static const String _completedAssignmentsKey = 'completed_assignments';

  // Save quiz score
  static Future<void> saveQuizScore(String subject, int score, int total) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_quizScoresKey}_$subject';
    final scores = prefs.getStringList(key) ?? [];
    scores.add('$score/$total-${DateTime.now().millisecondsSinceEpoch}');
    await prefs.setStringList(key, scores);
  }

  // Get quiz scores for a subject
  static Future<List<String>> getQuizScores(String subject) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_quizScoresKey}_$subject';
    return prefs.getStringList(key) ?? [];
  }

  // Save completed assignment
  static Future<void> markAssignmentComplete(String assignmentTitle) async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getStringList(_completedAssignmentsKey) ?? [];
    if (!completed.contains(assignmentTitle)) {
      completed.add(assignmentTitle);
      await prefs.setStringList(_completedAssignmentsKey, completed);
    }
  }

  // Get completed assignments
  static Future<List<String>> getCompletedAssignments() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_completedAssignmentsKey) ?? [];
  }



  // Get total quiz attempts
  static Future<int> getTotalQuizAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    final subjects = ['Astronomy', 'Biology', 'Chemistry'];
    int total = 0;
    for (var subject in subjects) {
      final key = '${_quizScoresKey}_$subject';
      total += prefs.getStringList(key)?.length ?? 0;
    }
    return total;
  }

  // Clear all progress (for testing)
  static Future<void> clearAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}