import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/progress_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  int? _selectedAnswerIndex;
  bool _showExplanation = false;
  String _selectedSubject = 'Astronomy';

  final List<Map<String, dynamic>> _astronomyQuestions = [
    {
      'question': 'How many planets are in our solar system?',
      'options': ['7', '8', '9', '10'],
      'correctAnswer': 1,
      'explanation': 'There are 8 planets in our solar system: Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, and Neptune.',
    },
    {
      'question': 'Which planet is known as the Red Planet?',
      'options': ['Venus', 'Mars', 'Jupiter', 'Saturn'],
      'correctAnswer': 1,
      'explanation': 'Mars is called the Red Planet due to iron oxide (rust) on its surface.',
    },
    {
      'question': 'What is the largest planet in our solar system?',
      'options': ['Earth', 'Saturn', 'Jupiter', 'Neptune'],
      'correctAnswer': 2,
      'explanation': 'Jupiter is the largest planet - it could fit all other planets inside it!',
    },
    {
      'question': 'Which planet has the most moons?',
      'options': ['Jupiter', 'Saturn', 'Uranus', 'Neptune'],
      'correctAnswer': 1,
      'explanation': 'Saturn has over 140 moons, more than any other planet!',
    },
    {
      'question': 'What is Earth\'s only natural satellite?',
      'options': ['Mars', 'The Sun', 'The Moon', 'Venus'],
      'correctAnswer': 2,
      'explanation': 'The Moon is Earth\'s only natural satellite and orbits our planet.',
    },
  ];

  final List<Map<String, dynamic>> _biologyQuestions = [
    {
      'question': 'How many chambers does the human heart have?',
      'options': ['2', '3', '4', '5'],
      'correctAnswer': 2,
      'explanation': 'The human heart has 4 chambers: left/right atria and left/right ventricles.',
    },
    {
      'question': 'What is the powerhouse of the cell?',
      'options': ['Nucleus', 'Mitochondria', 'Ribosome', 'Cell membrane'],
      'correctAnswer': 1,
      'explanation': 'Mitochondria are called the powerhouse because they produce energy (ATP) for the cell.',
    },
    {
      'question': 'Which gas do plants absorb during photosynthesis?',
      'options': ['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Hydrogen'],
      'correctAnswer': 1,
      'explanation': 'Plants absorb carbon dioxide and release oxygen during photosynthesis.',
    },
    {
      'question': 'What is the basic unit of life?',
      'options': ['Atom', 'Cell', 'Molecule', 'Organ'],
      'correctAnswer': 1,
      'explanation': 'The cell is the basic structural and functional unit of all living organisms.',
    },
    {
      'question': 'Which system includes the heart and blood vessels?',
      'options': ['Nervous System', 'Digestive System', 'Circulatory System', 'Respiratory System'],
      'correctAnswer': 2,
      'explanation': 'The circulatory system transports blood, nutrients, and oxygen throughout the body.',
    },
  ];

  final List<Map<String, dynamic>> _chemistryQuestions = [
    {
      'question': 'What is H2O commonly known as?',
      'options': ['Oxygen', 'Hydrogen', 'Water', 'Carbon dioxide'],
      'correctAnswer': 2,
      'explanation': 'H2O is the chemical formula for water - two hydrogen atoms and one oxygen atom.',
    },
    {
      'question': 'Which element has the chemical symbol "O"?',
      'options': ['Gold', 'Oxygen', 'Osmium', 'Oganesson'],
      'correctAnswer': 1,
      'explanation': 'O is the chemical symbol for Oxygen, essential for breathing and combustion.',
    },
    {
      'question': 'What is the atomic number of Carbon?',
      'options': ['6', '12', '14', '16'],
      'correctAnswer': 0,
      'explanation': 'Carbon has atomic number 6, meaning it has 6 protons in its nucleus.',
    },
    {
      'question': 'Which of these is a noble gas?',
      'options': ['Oxygen', 'Helium', 'Chlorine', 'Nitrogen'],
      'correctAnswer': 1,
      'explanation': 'Helium is a noble gas - these elements are very stable and rarely react with others.',
    },
    {
      'question': 'What does pH measure?',
      'options': ['Pressure', 'Temperature', 'Acidity/Basicity', 'Density'],
      'correctAnswer': 2,
      'explanation': 'pH measures how acidic or basic a solution is on a scale from 0-14.',
    },
  ];

  List<Map<String, dynamic>> get _currentQuestions {
    switch (_selectedSubject) {
      case 'Biology':
        return _biologyQuestions;
      case 'Chemistry':
        return _chemistryQuestions;
      case 'Astronomy':
      default:
        return _astronomyQuestions;
    }
  }

  Color _getSubjectColor(String subject) {
    switch (subject) {
      case 'Biology':
        return Colors.green;
      case 'Chemistry':
        return Colors.orange;
      case 'Astronomy':
      default:
        return Colors.teal;
    }
  }
// Update the _answerQuestion method
  void _answerQuestion(int selectedIndex) {
    setState(() {
      _selectedAnswerIndex = selectedIndex;
      _showExplanation = true;
    });

    // Show result after delay
    Future.delayed(Duration(milliseconds: 2000), () async {
      if (selectedIndex == _currentQuestions[_currentQuestionIndex]['correctAnswer']) {
        setState(() {
          _score++;
        });
      }

      if (_currentQuestionIndex < _currentQuestions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _selectedAnswerIndex = null;
          _showExplanation = false;
        });
      } else {
        // Save progress when quiz is completed
        await ProgressService.saveQuizScore(_selectedSubject, _score, _currentQuestions.length);

        setState(() {
          _quizCompleted = true;
        });
      }
    });
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _quizCompleted = false;
      _selectedAnswerIndex = null;
      _showExplanation = false;
    });
  }

  void _changeSubject(String subject) {
    setState(() {
      _selectedSubject = subject;
      _currentQuestionIndex = 0;
      _score = 0;
      _quizCompleted = false;
      _selectedAnswerIndex = null;
      _showExplanation = false;
    });
  }

  Color _getOptionColor(int optionIndex) {
    if (_selectedAnswerIndex == null) return _getSubjectColor(_selectedSubject);

    if (optionIndex == _currentQuestions[_currentQuestionIndex]['correctAnswer']) {
      return Colors.green;
    } else if (optionIndex == _selectedAnswerIndex) {
      return Colors.red;
    }
    return _getSubjectColor(_selectedSubject).withOpacity(0.3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe0f7fa),
      appBar: AppBar(
        title: Text('$_selectedSubject Quiz', style: GoogleFonts.poppins()),
        backgroundColor: _getSubjectColor(_selectedSubject),
      ),
      body: _quizCompleted ? _buildResults() : _buildQuiz(),
    );
  }

  Widget _buildQuiz() {
    final currentQuestion = _currentQuestions[_currentQuestionIndex];

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subject Selection
          Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSubjectButton('Astronomy', Icons.rocket),
                  _buildSubjectButton('Biology', Icons.eco),
                  _buildSubjectButton('Chemistry', Icons.science),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          // Progress Bar
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _currentQuestions.length,
            backgroundColor: _getSubjectColor(_selectedSubject).withOpacity(0.3),
            color: _getSubjectColor(_selectedSubject),
          ),
          SizedBox(height: 20),

          // Question Counter and Score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1}/${_currentQuestions.length}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: _getSubjectColor(_selectedSubject).withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Score: $_score',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: _getSubjectColor(_selectedSubject).withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 30),

          // Question Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    currentQuestion['question'],
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo[900],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),

                  // Options
                  Column(
                    children: List.generate(
                      currentQuestion['options'].length,
                          (index) => Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: ElevatedButton(
                          onPressed: _selectedAnswerIndex == null ? () => _answerQuestion(index) : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getOptionColor(index),
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            currentQuestion['options'][index],
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Explanation (shown after answer)
                  if (_showExplanation) ...[
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getSubjectColor(_selectedSubject).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _getSubjectColor(_selectedSubject)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                _selectedAnswerIndex == currentQuestion['correctAnswer']
                                    ? Icons.check_circle
                                    : Icons.info,
                                color: _selectedAnswerIndex == currentQuestion['correctAnswer']
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              SizedBox(width: 8),
                              Text(
                                _selectedAnswerIndex == currentQuestion['correctAnswer']
                                    ? 'Correct! 🎉'
                                    : 'Good try!',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: _selectedAnswerIndex == currentQuestion['correctAnswer']
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            currentQuestion['explanation'],
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectButton(String subject, IconData icon) {
    return GestureDetector(
      onTap: () => _changeSubject(subject),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _selectedSubject == subject
              ? _getSubjectColor(subject)
              : _getSubjectColor(subject).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _getSubjectColor(subject),
            width: _selectedSubject == subject ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: _selectedSubject == subject ? Colors.white : _getSubjectColor(subject)),
            SizedBox(width: 6),
            Text(
              subject,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _selectedSubject == subject ? Colors.white : _getSubjectColor(subject),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    double percentage = (_score / _currentQuestions.length) * 100;
    Color subjectColor = _getSubjectColor(_selectedSubject);

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Result Icon
          Icon(
            percentage == 100 ? Icons.celebration :
            percentage >= 70 ? Icons.emoji_events : Icons.school,
            size: 80,
            color: percentage == 100 ? Colors.amber :
            percentage >= 70 ? subjectColor : Colors.orange,
          ),
          SizedBox(height: 20),

          // Result Title
          Text(
            'Quiz Completed!',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: subjectColor.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 10),

          // Score
          Text(
            'Your Score: $_score/${_currentQuestions.length}',
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: subjectColor.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 5),

          // Percentage
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: percentage == 100 ? Colors.amber :
              percentage >= 70 ? Colors.green : Colors.orange,
            ),
          ),
          SizedBox(height: 20),

          // Performance Message
          Text(
            _getPerformanceMessage(percentage),
            style: GoogleFonts.poppins(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),

          // Restart Button
          ElevatedButton(
            onPressed: _restartQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: subjectColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Restart Quiz', style: GoogleFonts.poppins(fontSize: 16)),
          ),
          SizedBox(height: 16),

          // Back to Home
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Back to Home', style: GoogleFonts.poppins(color: subjectColor)),
          ),
        ],
      ),
    );
  }

  String _getPerformanceMessage(double percentage) {
    switch (_selectedSubject) {
      case 'Astronomy':
        return percentage == 100 ? 'Perfect! You\'re an astronomy expert! 🌟' :
        percentage >= 70 ? 'Great job! You know your planets! 🚀' :
        percentage >= 50 ? 'Good effort! Keep learning about space! 📚' :
        'Nice try! The solar system is amazing to explore! 🌌';

      case 'Biology':
        return percentage == 100 ? 'Excellent! You\'re a biology whiz! 🔬' :
        percentage >= 70 ? 'Great work! You understand life sciences! 🌿' :
        percentage >= 50 ? 'Good start! Biology gets more fascinating! 🧬' :
        'Keep exploring! Biology is the study of life! ❤️';

      case 'Chemistry':
        return percentage == 100 ? 'Brilliant! You\'re a chemistry pro! 🧪' :
        percentage >= 70 ? 'Well done! You know your elements! ⚗️' :
        percentage >= 50 ? 'Good going! Chemistry is all around us! 🔥' :
        'Nice attempt! Chemistry reveals how things work! 🌡️';

      default:
        return 'Quiz completed! Great learning!';
    }
  }
}