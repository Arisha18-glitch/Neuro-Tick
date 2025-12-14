import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_provider.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({Key? key}) : super(key: key);

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  // Assignment database
  final List<Map<String, dynamic>> _allAssignments = [
    {
      'id': 'w1-1',
      'title': 'Solar System Presentation',
      'subject': 'Astronomy',
      'description': 'Create a 5-slide presentation about our solar system planets.',
      'week': 1,
      'points': 100,
      'type': 'presentation',
      'difficulty': 'Medium',
      'estimatedTime': '2 hours',
    },
    {
      'id': 'w1-2',
      'title': 'Cell Structure Diagram',
      'subject': 'Biology',
      'description': 'Draw and label plant and animal cell structures.',
      'week': 1,
      'points': 85,
      'type': 'diagram',
      'difficulty': 'Easy',
      'estimatedTime': '1.5 hours',
    },
    // Add all other assignments here...
  ];

  late List<Map<String, dynamic>> _currentWeekAssignments;
  late int _currentWeek;
  late DateTime _weekStartDate;
  late Map<String, dynamic> _progressData;
  double _completionPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();

    // Get current week
    final now = DateTime.now();
    final appStartDate = DateTime(2024, 1, 1);
    final daysSinceStart = now.difference(appStartDate).inDays;
    _currentWeek = (daysSinceStart ~/ 7) % 4 + 1;

    // Set week start date (Monday)
    _weekStartDate = now.subtract(Duration(days: now.weekday - 1));

    // Load progress data
    _progressData = {
      'totalPoints': prefs.getInt('total_points') ?? 0,
      'completedAssignments': prefs.getStringList('completed_assignments') ?? [],
      'weekPoints': prefs.getInt('week_$_currentWeek') ?? 0,
    };

    // Get current week's assignments
    _currentWeekAssignments = _allAssignments
        .where((assignment) => assignment['week'] == _currentWeek)
        .toList();

    // Initialize assignment status with DateTime objects
    for (var assignment in _currentWeekAssignments) {
      assignment['status'] = _progressData['completedAssignments'].contains(assignment['id'])
          ? 'completed'
          : 'pending';
      assignment['dueDate'] = _weekStartDate.add(Duration(days: 6)); // This creates DateTime
      if (assignment['status'] == 'completed') {
        assignment['completedDate'] = DateTime.now(); // Make sure this is DateTime
      }
    }

    _calculateCompletion();
    setState(() {});
  }

  void _calculateCompletion() {
    final completedCount = _currentWeekAssignments
        .where((a) => a['status'] == 'completed')
        .length;
    _completionPercentage = (completedCount / _currentWeekAssignments.length) * 100;
  }

  Future<void> _markAsComplete(int index) async {
    final assignment = _currentWeekAssignments[index];
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    setState(() {
      assignment['status'] = 'completed';
      assignment['completedDate'] = DateTime.now(); // Store as DateTime
    });

    // Update progress data
    _progressData['totalPoints'] += assignment['points'];
    _progressData['weekPoints'] += assignment['points'];
    if (!_progressData['completedAssignments'].contains(assignment['id'])) {
      _progressData['completedAssignments'].add(assignment['id']);
    }

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total_points', _progressData['totalPoints']);
    await prefs.setInt('week_$_currentWeek', _progressData['weekPoints']);
    await prefs.setStringList('completed_assignments', _progressData['completedAssignments']);

    // Update AppProvider
    appProvider.submitQuizScore(
      subject: assignment['subject'],
      score: assignment['points'],
      totalQuestions: 10,
      level: assignment['difficulty'] == 'Easy' ? 1 :
      assignment['difficulty'] == 'Medium' ? 2 : 3,
    );

    _calculateCompletion();

    // SHOW FUN APPRECIATION MESSAGE
    _showAppreciationMessage(assignment['title'], assignment['points']);
  }

  void _showAppreciationMessage(String title, int points) {
    final messages = [
      "🎉 Amazing work! You've mastered $title!",
      "🌟 Outstanding! +$points points earned!",
      "🚀 You're on fire! Assignment completed!",
      "💫 Brilliant! Your knowledge is growing!",
      "🏆 Champion move! Another assignment down!",
      "✨ Incredible! You're becoming an expert!",
      "⭐ Superstar! Your dedication is inspiring!",
      "🔥 Fantastic! Keep up the great work!"
    ];

    final randomMessage = messages[DateTime.now().millisecondsSinceEpoch % messages.length];

    // Show celebratory dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.orange[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.celebration,
              size: 60,
              color: Colors.orange,
            ),
            SizedBox(height: 16),
            Text(
              'CONGRATULATIONS!',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange[700],
              ),
            ),
            SizedBox(height: 12),
            Text(
              randomMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Continue Learning'),
            ),
          ],
        ),
      ),
    ).then((_) {
      // Show snackbar after dialog closes
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.star, color: Colors.yellow),
              SizedBox(width: 10),
              Text('+$points points added to your total!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed': return Colors.green;
      case 'pending': return Colors.orange;
      default: return Colors.grey;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy': return Colors.green;
      case 'Medium': return Colors.orange;
      case 'Hard': return Colors.red;
      default: return Colors.grey;
    }
  }

  // Helper functions for date formatting (NO intl package needed)
  String _formatDate(DateTime date) {
    final month = _getMonthName(date.month);
    final day = date.day;
    return '$month $day';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _formatDueDate(DateTime date) {
    final dayName = _getDayName(date.weekday);
    final month = _getMonthName(date.month);
    final day = date.day;
    return '$dayName, $month $day';
  }

  Widget _buildProgressCard() {
    final weekEndDate = _weekStartDate.add(Duration(days: 6));
    final weekRange = '${_formatDate(_weekStartDate)} - ${_formatDate(weekEndDate)}';

    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Week $_currentWeek',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(weekRange, style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Chip(
                  label: Text(
                    '${_progressData['weekPoints']} pts',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.orange,
                ),
              ],
            ),
            SizedBox(height: 16),

            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Weekly Progress', style: TextStyle(fontWeight: FontWeight.w500)),
                    Text('${_completionPercentage.toStringAsFixed(0)}%',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                  ],
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _completionPercentage / 100,
                  backgroundColor: Colors.grey[200],
                  color: Colors.orange,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(5),
                ),
                SizedBox(height: 8),
                Text(
                  '${_currentWeekAssignments.where((a) => a['status'] == 'completed').length} of ${_currentWeekAssignments.length} assignments completed',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total Points', '${_progressData['totalPoints']}', Icons.emoji_events),
                _buildStatItem('Week Points', '${_progressData['weekPoints']}', Icons.trending_up),
                _buildStatItem('Completed', '${_currentWeekAssignments.where((a) => a['status'] == 'completed').length}', Icons.check_circle),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange, size: 24),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe0f7fa),
      appBar: AppBar(
        title: Text('Weekly Assignments', style: GoogleFonts.poppins()),
        backgroundColor: Colors.orange,
      ),
      body: _currentWeekAssignments.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Progress Card
          _buildProgressCard(),

          // Assignments List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _currentWeekAssignments.length,
              itemBuilder: (context, index) {
                final assignment = _currentWeekAssignments[index];
                final isCompleted = assignment['status'] == 'completed';

                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _getStatusColor(assignment['status']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                isCompleted ? Icons.check_circle : Icons.assignment,
                                color: _getStatusColor(assignment['status']),
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    assignment['title'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    assignment['subject'],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Chip(
                              label: Text(
                                '${assignment['points']} pts',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ],
                        ),

                        SizedBox(height: 12),

                        // Description
                        Text(
                          assignment['description'],
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),

                        SizedBox(height: 12),

                        // Details Row
                        Row(
                          children: [
                            // Difficulty
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getDifficultyColor(assignment['difficulty']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: _getDifficultyColor(assignment['difficulty']).withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                assignment['difficulty'],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _getDifficultyColor(assignment['difficulty']),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            SizedBox(width: 8),

                            // Time estimate
                            Row(
                              children: [
                                Icon(Icons.timer, size: 14, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(
                                  assignment['estimatedTime'],
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),

                            Spacer(),

                            // Due date - Fixed the error here
                            if (assignment['dueDate'] is DateTime)
                              Text(
                                'Due: ${_formatDueDate(assignment['dueDate'] as DateTime)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ),

                        SizedBox(height: 12),

                        // Action Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: isCompleted
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.check, color: Colors.green, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Completed!',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                              : ElevatedButton(
                            onPressed: () => _markAsComplete(index),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            ),
                            child: Text('Mark as Complete'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}