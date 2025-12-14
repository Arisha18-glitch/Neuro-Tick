import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizSubjectScreen extends StatelessWidget {
  final Function(String) onSubjectSelected;

  const QuizSubjectScreen({
    Key? key,
    required this.onSubjectSelected,
  }) : super(key: key);

  Color _getSubjectColor(String subject) {
    switch (subject) {
      case 'Biology': return Colors.green;
      case 'Chemistry': return Colors.orange;
      case 'Physics': return Colors.purple;
      case 'Mathematics': return Colors.blue;
      case 'Astronomy': default: return Colors.teal;
    }
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject) {
      case 'Biology': return Icons.eco;
      case 'Chemistry': return Icons.science;
      case 'Physics': return Icons.bolt;
      case 'Mathematics': return Icons.calculate;
      case 'Astronomy': default: return Icons.rocket;
    }
  }

  Widget _buildSubjectCard(BuildContext context, String subject) {
    final color = _getSubjectColor(subject);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => onSubjectSelected(subject),
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.8), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getSubjectIcon(subject),
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(height: 12),
              // Fixed: Using FittedBox to prevent overflow
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  subject,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap to start quiz',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subjects = ['Astronomy', 'Biology', 'Chemistry', 'Physics', 'Mathematics'];

    return Scaffold(
      backgroundColor: const Color(0xFFe0f7fa),
      appBar: AppBar(
        title: Text('Select Subject', style: GoogleFonts.poppins()),
        backgroundColor: Colors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.quiz, color: Colors.teal, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Test Your Knowledge',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Choose a subject to start the quiz',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.teal.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Grid of Subjects
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return _buildSubjectCard(context, subjects[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}