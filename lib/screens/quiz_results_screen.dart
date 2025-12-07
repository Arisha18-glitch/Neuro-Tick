import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class QuizResultsScreen extends StatelessWidget {
  final String subject;
  final int level;
  final int score;
  final int totalQuestions;

  const QuizResultsScreen({
    Key? key,
    required this.subject,
    required this.level,
    required this.score,
    required this.totalQuestions,
  }) : super(key: key);

  int get maxPossibleScore => totalQuestions * (10 + ((level - 1) * 5));
  double get percentage => maxPossibleScore > 0 ? (score / maxPossibleScore) * 100 : 0;

  Color _getSubjectColor() {
    switch (subject) {
      case 'Biology': return Colors.green;
      case 'Chemistry': return Colors.orange;
      case 'Physics': return Colors.purple;
      case 'Mathematics': return Colors.blue;
      case 'Astronomy': default: return Colors.teal;
    }
  }

  String _getLevelText() {
    switch (level) {
      case 1: return 'Easy';
      case 2: return 'Medium';
      case 3: return 'Hard';
      default: return 'Easy';
    }
  }

  IconData _getResultIcon() {
    if (percentage == 100) return Icons.celebration;
    if (percentage >= 70) return Icons.emoji_events;
    if (percentage >= 50) return Icons.school;
    return Icons.auto_awesome;
  }

  String _getResultMessage() {
    if (percentage == 100) {
      return 'Perfect score! You\'re a $subject master! 🏆';
    } else if (percentage >= 80) {
      return 'Excellent! You aced the $_getLevelText() level! 🌟';
    } else if (percentage >= 60) {
      return 'Great job! You handled $_getLevelText() level well! 👍';
    } else if (percentage >= 40) {
      return 'Good effort! $_getLevelText() level can be challenging! 💪';
    } else {
      return 'Nice try! Practice makes perfect! 📚';
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjectColor = _getSubjectColor();
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFe0f7fa),
      appBar: AppBar(
        title: Text('Quiz Results', style: GoogleFonts.poppins()),
        backgroundColor: subjectColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Result Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: subjectColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(color: subjectColor, width: 3),
                ),
                child: Icon(
                  _getResultIcon(),
                  size: 60,
                  color: subjectColor,
                ),
              ),

              const SizedBox(height: 24),

              // Subject & Level Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: subjectColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: subjectColor, width: 1),
                ),
                child: Text(
                  '$subject - $_getLevelText() Level',
                  style: GoogleFonts.poppins(
                    color: subjectColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Score
              Text(
                'Your Score',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 32),
                  const SizedBox(width: 8),
                  Text(
                    '$score',
                    style: GoogleFonts.poppins(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[700],
                    ),
                  ),
                  Text(
                    ' / $maxPossibleScore',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Percentage
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: percentage == 100 ? Colors.amber :
                  percentage >= 70 ? Colors.green : Colors.orange,
                ),
              ),

              const SizedBox(height: 32),

              // Message
              Text(
                _getResultMessage(),
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Actions
              Column(
                children: [
                  // Restart Same Level
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate back to the quiz screen with the same level
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: subjectColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Try Again (Same Level)',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Back to Subjects
                  TextButton(
                    onPressed: () {
                      // Navigate all the way back to home
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Text(
                      'Back to Subjects',
                      style: GoogleFonts.poppins(
                        color: subjectColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}