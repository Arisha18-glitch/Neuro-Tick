import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/quiz_questions.dart';

class QuizQuestionsScreen extends StatefulWidget {
  final String subject;
  final int initialLevel;
  final Function(int) onLevelChanged;
  final Function(int, int) onQuizCompleted;

  const QuizQuestionsScreen({
    Key? key,
    required this.subject,
    this.initialLevel = 1,
    required this.onLevelChanged,
    required this.onQuizCompleted,
  }) : super(key: key);

  @override
  State<QuizQuestionsScreen> createState() => _QuizQuestionsScreenState();
}

class _QuizQuestionsScreenState extends State<QuizQuestionsScreen> {
  int _currentLevel = 1;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  bool _showExplanation = false;

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.initialLevel;
  }

  List<Map<String, dynamic>> get _questions {
    return QuizQuestions.getQuestionsBySubjectAndLevel(widget.subject, _currentLevel);
  }

  Color _getSubjectColor() {
    switch (widget.subject) {
      case 'Biology': return Colors.green;
      case 'Chemistry': return Colors.orange;
      case 'Physics': return Colors.purple;
      case 'Mathematics': return Colors.blue;
      case 'Astronomy': default: return Colors.teal;
    }
  }

  Color _getLevelColor() {
    switch (_currentLevel) {
      case 1: return Colors.green;
      case 2: return Colors.orange;
      case 3: return Colors.red;
      default: return Colors.green;
    }
  }

  String _getLevelText() {
    switch (_currentLevel) {
      case 1: return 'Easy';
      case 2: return 'Medium';
      case 3: return 'Hard';
      default: return 'Easy';
    }
  }

  void _handleAnswer(int selectedIndex) {
    setState(() {
      _selectedAnswerIndex = selectedIndex;
      _showExplanation = true;
    });

    if (selectedIndex == _questions[_currentQuestionIndex]['correctAnswer']) {
      setState(() {
        _score += (10 + ((_currentLevel - 1) * 5));
      });
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _selectedAnswerIndex = null;
          _showExplanation = false;
        });
      } else {
        // Notify parent about quiz completion
        widget.onQuizCompleted(_score, _questions.length);
      }
    });
  }

  void _changeLevel(int level) {
    setState(() {
      _currentLevel = level;
      _currentQuestionIndex = 0;
      _score = 0;
      _selectedAnswerIndex = null;
      _showExplanation = false;
    });
    widget.onLevelChanged(level);
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return _buildEmptyState();
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    final subjectColor = _getSubjectColor();

    return Scaffold(
      backgroundColor: const Color(0xFFe0f7fa),
      appBar: AppBar(
        title: Text('${widget.subject} Quiz', style: GoogleFonts.poppins()),
        backgroundColor: subjectColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Level selector
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: PopupMenuButton<int>(
              onSelected: _changeLevel,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text('Easy Level'),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text('Medium Level'),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Text('Hard Level'),
                ),
              ],
              child: Row(
                children: [
                  Text(_getLevelText(), style: GoogleFonts.poppins(color: Colors.white)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress & Score
            _buildProgressHeader(subjectColor),

            const SizedBox(height: 24),

            // Question Card
            Expanded(
              child: SingleChildScrollView(
                child: _buildQuestionCard(currentQuestion, subjectColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader(Color subjectColor) {
    return Column(
      children: [
        // Progress Bar
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _questions.length,
          backgroundColor: subjectColor.withOpacity(0.2),
          color: subjectColor,
        ),

        const SizedBox(height: 16),

        // Question Counter & Score
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: subjectColor,
                fontWeight: FontWeight.w500,
              ),
            ),

            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  '$_score',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.amber[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question, Color subjectColor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question
            Text(
              question['question'],
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.indigo[900],
              ),
            ),

            const SizedBox(height: 24),

            // Options
            Column(
              children: List.generate(
                question['options'].length,
                    (index) => _buildOptionButton(index, question, subjectColor),
              ),
            ),

            const SizedBox(height: 24),

            // Explanation (if shown)
            if (_showExplanation)
              _buildExplanation(question, subjectColor),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(int index, Map<String, dynamic> question, Color subjectColor) {
    bool isSelected = _selectedAnswerIndex == index;
    bool isCorrect = index == question['correctAnswer'];

    Color backgroundColor = subjectColor.withOpacity(0.1);
    Color borderColor = subjectColor.withOpacity(0.3);

    if (isSelected) {
      backgroundColor = isCorrect ? Colors.green : Colors.red;
      borderColor = isCorrect ? Colors.green : Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _selectedAnswerIndex == null ? () => _handleAnswer(index) : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Option letter
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : subjectColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index), // A, B, C, D
                      style: GoogleFonts.poppins(
                        color: isSelected ? subjectColor : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Option text
                Expanded(
                  child: Text(
                    question['options'][index],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),

                // Check or X mark
                if (isSelected)
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: Colors.white,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExplanation(Map<String, dynamic> question, Color subjectColor) {
    bool isCorrect = _selectedAnswerIndex == question['correctAnswer'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isCorrect ? Colors.green : Colors.orange).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCorrect ? 'Correct! 🎉' : 'Not quite right',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: isCorrect ? Colors.green : Colors.orange,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            question['explanation'],
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Scaffold(
      backgroundColor: const Color(0xFFe0f7fa),
      appBar: AppBar(
        title: Text('${widget.subject} Quiz', style: GoogleFonts.poppins()),
        backgroundColor: _getSubjectColor(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.question_mark, size: 60, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                'No questions available',
                style: GoogleFonts.poppins(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Try a different level or subject',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}