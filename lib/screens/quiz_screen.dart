import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quiz_subject_screen.dart';
import 'quiz_questions_screen.dart';
import 'quiz_results_screen.dart';

class QuizScreen extends StatelessWidget {
  final String? initialSubject;
  final int? initialLevel;

  const QuizScreen({
    Key? key,
    this.initialSubject,
    this.initialLevel = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _QuizNavigator(
        initialSubject: initialSubject,
        initialLevel: initialLevel,
      ),
    );
  }
}

class _QuizNavigator extends StatefulWidget {
  final String? initialSubject;
  final int? initialLevel;

  const _QuizNavigator({
    Key? key,
    this.initialSubject,
    this.initialLevel,
  }) : super(key: key);

  @override
  State<_QuizNavigator> createState() => _QuizNavigatorState();
}

class _QuizNavigatorState extends State<_QuizNavigator> {
  String? _currentSubject;
  int? _currentLevel;
  int? _finalScore;
  int? _totalQuestions;

  @override
  void initState() {
    super.initState();
    _currentSubject = widget.initialSubject;
    _currentLevel = widget.initialLevel ?? 1;
  }

  void _onSubjectSelected(String subject) {
    setState(() {
      _currentSubject = subject;
    });
  }

  void _onLevelChanged(int level) {
    setState(() {
      _currentLevel = level;
    });
  }

  void _onQuizCompleted(int score, int totalQuestions) {
    setState(() {
      _finalScore = score;
      _totalQuestions = totalQuestions;
    });
  }

  void _onRestartQuiz() {
    setState(() {
      _currentSubject = null;
      _currentLevel = 1;
      _finalScore = null;
      _totalQuestions = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show Subject Selection if no subject is selected
    if (_currentSubject == null) {
      return QuizSubjectScreen(
        onSubjectSelected: _onSubjectSelected,
      );
    }

    // Show Results if quiz is completed
    if (_finalScore != null && _totalQuestions != null && _currentSubject != null) {
      return QuizResultsScreen(
        subject: _currentSubject!,
        level: _currentLevel ?? 1,
        score: _finalScore!,
        totalQuestions: _totalQuestions!,
      );
    }

    // Show Questions Screen
    return QuizQuestionsScreen(
      subject: _currentSubject!,
      initialLevel: _currentLevel ?? 1,
      onLevelChanged: _onLevelChanged,
      onQuizCompleted: _onQuizCompleted,
    );
  }
}