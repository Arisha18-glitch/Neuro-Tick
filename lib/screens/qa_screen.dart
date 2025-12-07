import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/qa_service.dart';
// Check these imports exist

class QAScreen extends StatefulWidget {
  const QAScreen({Key? key}) : super(key: key);

  @override
  _QAScreenState createState() => _QAScreenState();
}

class _QAScreenState extends State<QAScreen> {
  final TextEditingController _questionController = TextEditingController();
  String _answer = '';
  bool _isLoading = false;
  bool _showSuggestions = true;
  List<Map<String, dynamic>> _history = [];
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Astronomy',
    'Biology',
    'Chemistry',
    'Physics',
    'Mathematics',
  ];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    // Load some example history for demo
    setState(() {
      _history = [
        {
          'question': 'How many planets are in our solar system?',
          'answer': 'There are 8 planets in our solar system.',
          'timestamp': DateTime.now().subtract(Duration(hours: 2)),
        },
        {
          'question': 'What is the powerhouse of the cell?',
          'answer': 'Mitochondria are known as the powerhouse of the cell.',
          'timestamp': DateTime.now().subtract(Duration(hours: 5)),
        },
        {
          'question': 'What is H2O?',
          'answer': 'H2O is the chemical formula for water.',
          'timestamp': DateTime.now().subtract(Duration(days: 1)),
        },
      ];
    });
  }

  void _askQuestion() async {
    if (_questionController.text.trim().isEmpty) return;

    final question = _questionController.text.trim();

    setState(() {
      _isLoading = true;
      _answer = '';
      _showSuggestions = false;
    });

    // Get answer from service
    final answer = await QAService.getAnswer(question);

    // Add to history
    _history.insert(0, {
      'question': question,
      'answer': answer,
      'timestamp': DateTime.now(),
    });

    setState(() {
      _answer = answer;
      _isLoading = false;
    });

    // Clear question field
    _questionController.clear();
  }

  void _useSuggestion(String suggestion) {
    _questionController.text = suggestion;
    _askQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f5),
      appBar: AppBar(
        title: Text('Ask NeuroTick', style: GoogleFonts.poppins()),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.live_help, color: Colors.white, size: 40),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question & Answer',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Ask anything about science, math, or technology',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Question Input
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _questionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Type your question here...',
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.poppins(color: Colors.grey),
                      ),
                      style: GoogleFonts.poppins(fontSize: 16),
                      onSubmitted: (_) => _askQuestion(),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Category Filter
                        DropdownButton<String>(
                          value: _selectedCategory,
                          items: _categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category, style: GoogleFonts.poppins()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                        ),
                        ElevatedButton.icon(
                          onPressed: _askQuestion,
                          icon: Icon(Icons.send),
                          label: Text('Ask', style: GoogleFonts.poppins()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Loading Indicator
            if (_isLoading)
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: Colors.deepPurple),
                    SizedBox(height: 10),
                    Text(
                      'Thinking...',
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  ],
                ),
              ),

            // Answer Section
            if (_answer.isNotEmpty && !_isLoading) ...[
              Text(
                'Answer:',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.amber),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _answer,
                        style: GoogleFonts.poppins(fontSize: 16, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.copy, color: Colors.deepPurple),
                    onPressed: () {
                      // Implement copy to clipboard
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Answer copied to clipboard'),
                          backgroundColor: Colors.deepPurple,
                        ),
                      );
                    },
                    tooltip: 'Copy answer',
                  ),
                  IconButton(
                    icon: Icon(Icons.share, color: Colors.deepPurple),
                    onPressed: () {
                      // Implement share
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Sharing feature coming soon'),
                          backgroundColor: Colors.deepPurple,
                        ),
                      );
                    },
                    tooltip: 'Share answer',
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],

            // Question Suggestions
            if (_showSuggestions && _answer.isEmpty) ...[
              Text(
                'Try asking:',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: QAService.getQuestionSuggestions(_selectedCategory)
                    .map((suggestion) => FilterChip(
                  label: Text(suggestion, style: GoogleFonts.poppins()),
                  onSelected: (_) => _useSuggestion(suggestion),
                  backgroundColor: Colors.white,
                  selectedColor: Colors.deepPurple.withOpacity(0.2),
                  shape: StadiumBorder(
                    side: BorderSide(color: Colors.deepPurple),
                  ),
                ))
                    .toList(),
              ),
              SizedBox(height: 20),
            ],

            // History Section
            if (_history.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Questions',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: _loadHistory,
                    tooltip: 'Refresh history',
                  ),
                ],
              ),
              SizedBox(height: 10),
              ..._history.map((item) {
                return Card(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple.withOpacity(0.1),
                      child: Icon(Icons.question_answer, color: Colors.deepPurple),
                    ),
                    title: Text(
                      item['question'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      item['answer'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    trailing: Text(
                      _formatTimeAgo(item['timestamp'] as DateTime),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _answer = item['answer'];
                        _showSuggestions = false;
                      });
                    },
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }
}