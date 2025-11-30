import 'package:shared_preferences/shared_preferences.dart';

class AchievementService {
  static const String _achievementsKey = 'unlocked_achievements';

  static final Map<String, Map<String, dynamic>> _allAchievements = {
    'quiz_master': {
      'title': 'Quiz Master',
      'description': 'Complete 5 quizzes',
      'icon': '🏆',
      'requiredCount': 5,
    },
    'assignment_expert': {
      'title': 'Assignment Expert',
      'description': 'Complete 3 assignments',
      'icon': '📚',
      'requiredCount': 3,
    },
    'astronomy_pro': {
      'title': 'Astronomy Pro',
      'description': 'Score 100% in Astronomy quiz',
      'icon': '🚀',
      'requiredCount': 1,
    },
    'biology_whiz': {
      'title': 'Biology Whiz',
      'description': 'Score 100% in Biology quiz',
      'icon': '🔬',
      'requiredCount': 1,
    },
    'chemistry_genius': {
      'title': 'Chemistry Genius',
      'description': 'Score 100% in Chemistry quiz',
      'icon': '🧪',
      'requiredCount': 1,
    },
  };

  static Future<List<String>> getUnlockedAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_achievementsKey) ?? [];
  }

  static Future<void> checkQuizAchievements(int totalAttempts, Map<String, int> subjectScores) async {
    final prefs = await SharedPreferences.getInstance();
    final unlocked = prefs.getStringList(_achievementsKey) ?? [];
    final newAchievements = <String>[];

    // Quiz Master - Complete 5 quizzes
    if (totalAttempts >= 5 && !unlocked.contains('quiz_master')) {
      unlocked.add('quiz_master');
      newAchievements.add('quiz_master');
    }

    // Subject mastery achievements
    if (subjectScores['Astronomy'] == 100 && !unlocked.contains('astronomy_pro')) {
      unlocked.add('astronomy_pro');
      newAchievements.add('astronomy_pro');
    }

    if (subjectScores['Biology'] == 100 && !unlocked.contains('biology_whiz')) {
      unlocked.add('biology_whiz');
      newAchievements.add('biology_whiz');
    }

    if (subjectScores['Chemistry'] == 100 && !unlocked.contains('chemistry_genius')) {
      unlocked.add('chemistry_genius');
      newAchievements.add('chemistry_genius');
    }

    if (newAchievements.isNotEmpty) {
      await prefs.setStringList(_achievementsKey, unlocked);
    }
  }

  static Future<void> checkAssignmentAchievements(int completedCount) async {
    final prefs = await SharedPreferences.getInstance();
    final unlocked = prefs.getStringList(_achievementsKey) ?? [];

    if (completedCount >= 3 && !unlocked.contains('assignment_expert')) {
      unlocked.add('assignment_expert');
      await prefs.setStringList(_achievementsKey, unlocked);
    }
  }

  static Map<String, Map<String, dynamic>> getAllAchievements() {
    return _allAchievements;
  }
}