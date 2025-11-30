import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ar_view_screen.dart';
import '../services/progress_service.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({Key? key}) : super(key: key);

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  final List<Map<String, dynamic>> _assignments = [
    {
      'title': 'Solar System Model',
      'subject': 'Astronomy',
      'dueDate': '3 days left',
      'description': 'Create a 3D model of our solar system showing all 8 planets in correct order from the Sun.',
      'status': 'pending', // pending, completed, late
      'points': 100,
    },
    {
      'title': 'Heart Anatomy Diagram',
      'subject': 'Biology',
      'dueDate': '1 week left',
      'description': 'Label all major parts of the human heart and explain blood flow through the chambers.',
      'status': 'pending',
      'points': 85,
    },
    {
      'title': 'Photosynthesis Experiment',
      'subject': 'Biology',
      'dueDate': '2 weeks left',
      'description': 'Conduct an experiment showing how plants produce oxygen through photosynthesis.',
      'status': 'pending',
      'points': 95,
    },
    {
      'title': 'Volcano Eruption Report',
      'subject': 'Geography',
      'dueDate': 'Completed',
      'description': 'Research and report on volcanic eruptions and their impact on the environment.',
      'status': 'completed',
      'points': 90,
    },
  ];
// Update the _markAsComplete method
  void _markAsComplete(int index) async {
    // Save to progress
    await ProgressService.markAssignmentComplete(_assignments[index]['title']);

    setState(() {
      _assignments[index]['status'] = 'completed';
      _assignments[index]['dueDate'] = 'Completed';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_assignments[index]['title']} marked as complete! 🎉')),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed': return Colors.green;
      case 'late': return Colors.red;
      case 'pending': return Colors.orange;
      default: return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'completed': return Icons.check_circle;
      case 'late': return Icons.error;
      case 'pending': return Icons.pending;
      default: return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe0f7fa),
      appBar: AppBar(
        title: Text('My Assignments', style: GoogleFonts.poppins()),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Stats Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('Total', _assignments.length.toString(), Icons.assignment),
                    _buildStat('Completed',
                        _assignments.where((a) => a['status'] == 'completed').length.toString(),
                        Icons.check_circle
                    ),
                    _buildStat('Pending',
                        _assignments.where((a) => a['status'] == 'pending').length.toString(),
                        Icons.pending
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Assignments List
            Expanded(
              child: ListView.builder(
                itemCount: _assignments.length,
                itemBuilder: (context, index) {
                  final assignment = _assignments[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Fixed Row with Flexible widgets to prevent overflow
                          Row(
                            children: [
                              Icon(
                                _getStatusIcon(assignment['status']),
                                color: _getStatusColor(assignment['status']),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  assignment['title'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(assignment['status']).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  assignment['dueDate'],
                                  style: TextStyle(
                                    color: _getStatusColor(assignment['status']),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            assignment['subject'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            assignment['description'],
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${assignment['points']} points',
                                style: TextStyle(
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (assignment['status'] == 'pending')
                                ElevatedButton(
                                  onPressed: () => _markAsComplete(index),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('Mark Complete'),
                                )
                              else
                                Text(
                                  'Completed ✅',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ARViewScreen(
                topicName: 'Assignment Helper',
                topicDescription: 'Use AR to visualize your assignment topics',
              ),
            ),
          );
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.view_in_ar, color: Colors.white),
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange, size: 30),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}