import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/progress_service.dart';
import '../services/achievement_service.dart';  // ✅ ADD THIS IMPORT

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late Future<Map<String, dynamic>> _progressData;

  @override
  void initState() {
    super.initState();
    _progressData = _loadProgressData();
  }

  Future<Map<String, dynamic>> _loadProgressData() async {
    final astronomyScores = await ProgressService.getQuizScores('Astronomy');
    final biologyScores = await ProgressService.getQuizScores('Biology');
    final chemistryScores = await ProgressService.getQuizScores('Chemistry');
    final completedAssignments = await ProgressService.getCompletedAssignments();
    final totalAttempts = await ProgressService.getTotalQuizAttempts();

    return {
      'astronomyScores': astronomyScores,
      'biologyScores': biologyScores,
      'chemistryScores': chemistryScores,
      'completedAssignments': completedAssignments,
      'totalAttempts': totalAttempts,
    };
  }

  void _refreshProgress() {
    setState(() {
      _progressData = _loadProgressData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe0f7fa),
      appBar: AppBar(
        title: Text('Learning Progress', style: GoogleFonts.poppins()),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshProgress,
            tooltip: 'Refresh Progress',
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _progressData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading progress'));
          }

          final data = snapshot.data!;
          final astronomyScores = data['astronomyScores'] as List<String>;
          final biologyScores = data['biologyScores'] as List<String>;
          final chemistryScores = data['chemistryScores'] as List<String>;
          final completedAssignments = data['completedAssignments'] as List<String>;
          final totalAttempts = data['totalAttempts'] as int;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Overall Stats Card
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'Learning Overview',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[800],
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatCard('Quiz Attempts', '$totalAttempts', Icons.quiz, Colors.blue),
                            _buildStatCard('Assignments Done', '${completedAssignments.length}', Icons.assignment_turned_in, Colors.green),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Quiz Progress
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quiz Progress',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildSubjectProgress('Astronomy', astronomyScores, Colors.teal),
                        SizedBox(height: 12),
                        _buildSubjectProgress('Biology', biologyScores, Colors.green),
                        SizedBox(height: 12),
                        _buildSubjectProgress('Chemistry', chemistryScores, Colors.orange),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Completed Assignments
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Completed Assignments',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        if (completedAssignments.isEmpty)
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'No assignments completed yet. Start learning!',
                              style: GoogleFonts.poppins(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          )
                        else
                          ...completedAssignments.map((assignment) => Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green, size: 20),
                                SizedBox(width: 8),
                                Expanded(child: Text(assignment, style: GoogleFonts.poppins())),
                              ],
                            ),
                          )).toList(),
                      ],
                    ),
                  ),
                ),

                // ✅ ADD THIS ACHIEVEMENTS SECTION
                SizedBox(height: 20),

                // Achievements Card
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Achievements',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        FutureBuilder<List<String>>(
                          future: AchievementService.getUnlockedAchievements(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            final unlocked = snapshot.data ?? [];
                            final allAchievements = AchievementService.getAllAchievements();

                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: allAchievements.entries.map((entry) {
                                final isUnlocked = unlocked.contains(entry.key);

                                return Container(
                                  width: 100,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isUnlocked ? Colors.amber[100] : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isUnlocked ? Colors.amber : Colors.grey,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        entry.value['icon'],
                                        style: TextStyle(fontSize: 24),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        entry.value['title'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: isUnlocked ? Colors.amber[800] : Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        SizedBox(height: 8),
        Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSubjectProgress(String subject, List<String> scores, Color color) {
    final bestScore = _getBestScore(scores);

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.quiz, color: Colors.white, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text(
                  'Attempts: ${scores.length}',
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),
                if (bestScore.isNotEmpty)
                  Text(
                    'Best: $bestScore',
                    style: GoogleFonts.poppins(fontSize: 12, color: color),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getBestScore(List<String> scores) {
    if (scores.isEmpty) return 'No attempts';

    int bestPercentage = 0;
    for (var score in scores) {
      final parts = score.split('/');
      if (parts.length == 2) {
        final scorePart = parts[0];
        final totalPart = parts[1].split('-')[0];
        final percentage = (int.parse(scorePart) / int.parse(totalPart)) * 100;
        if (percentage > bestPercentage) {
          bestPercentage = percentage.round();
        }
      }
    }

    return '$bestPercentage%';
  }
}