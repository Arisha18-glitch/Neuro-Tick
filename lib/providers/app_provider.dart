import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/quiz_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final QuizService _quizService = QuizService();

  // Add dark mode variable
  bool _isDarkMode = false;

  // Auth getters
  bool get isLoggedIn => _authService.isLoggedIn;
  String? get userName => _authService.userName;
  int get loginCount => _authService.loginCount;

  // Quiz getters
  int get totalQuizzesTaken => _quizService.totalQuizzesTaken;
  int get totalScore => _quizService.totalScore;
  Map<String, int> get subjectScores => _quizService.subjectScores;
  List<Map<String, dynamic>> get recentQuizzes => _quizService.recentQuizzes;

  // Dark mode getters
  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  // Constructor to load saved settings
  AppProvider() {
    _loadSettings();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    notifyListeners();
  }

  // Dark mode methods
  void setDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    notifyListeners();
  }

  void toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
    notifyListeners();
  }

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