import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neurotick/screens/notes_screen.dart';
import '../widgets/input_cart.dart';
import '../widgets/topic_chip.dart';
import '../models/fake_data.dart';  // ADD THIS IMPORT
import 'login_screen.dart';
import 'quiz_screen.dart'; // ADD THIS IMPORT
import 'assignments_screen.dart'; // ADD THIS IMPORT
import 'community_screen.dart'; // ADD THIS IMPORT
import 'ar_view_screen.dart'; // ADD THIS IMPORT
import 'progress_screen.dart';
import 'library_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0f7fa), Color(0xFF80deea)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ✅ Header
                // ✅ Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Neuro Tick',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.indigo[900],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.analytics, color: Colors.indigo),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProgressScreen()),
                              );
                            },
                            tooltip: 'View Progress',
                          ),
                          IconButton(
                            icon: Icon(Icons.logout, color: Colors.indigo), // 🆕 LOGOUT BUTTON
                            onPressed: () => _logout(context), // 🆕 CALL LOGOUT METHOD
                            tooltip: 'Logout',
                          ),
                          IconButton(
                              icon: Icon(Icons.settings_rounded, color: Colors.indigo),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Settings coming soon!')),
                                );
                              }
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ✅ Hero Banner
                Container(
                  height: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1600880292203-757bb62b4baf?auto=format&fit=crop&w=800&q=60'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
                  ),
                ),
                const SizedBox(height: 20),

                // ✅ Quick Action Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildCardButton(context, icon: Icons.school_rounded, title: 'Learn', color: Colors.indigo),
                      const SizedBox(width: 16),
                      _buildCardButton(context, icon: Icons.quiz_rounded, title: 'Quiz', color: Colors.teal),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildCardButton(context, icon: Icons.assignment_rounded, title: 'Assignments', color: Colors.orange),
                      const SizedBox(width: 16),
                      _buildCardButton(context, icon: Icons.forum_rounded, title: 'Community', color: Colors.pink),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // ✅ Topics Section

                const SizedBox(height: 30),

                // ✅ Featured Topics Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        'Featured Topics',
                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo[900])
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ✅ Featured Topics List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: FakeData.featuredTopics.map((topic) {
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        // In the Featured Topics List section, update the ListTile:
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.indigo[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.auto_awesome, color: Colors.indigo),
                          ),
                          title: Text(
                            topic.name,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(topic.description),
                          trailing: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.indigo[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              topic.category,
                              style: TextStyle(fontSize: 12, color: Colors.indigo[800]),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ARViewScreen(
                                  topicName: topic.name,
                                  topicDescription: topic.description,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 30),

                // ✅ Recent Topics Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        'Recent Topics',
                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo[900])
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ✅ Recent Topics List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: FakeData.recentTopics.map((topic) {
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.teal[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.history, color: Colors.teal),
                          ),
                          title: Text(
                            topic.name,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(topic.description),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.schedule, size: 12, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(
                                    topic.lastViewed,
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Opening ${topic.name} in AR...')),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 30),

                // ✅ Input Cards Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      InputCard(
                          icon: Icons.chat_rounded,
                          title: 'Ask a Question',
                          subtitle: 'Get AI-powered answers instantly',
                          color: Colors.indigo,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Ask a Question is clicked')),
                            );
                          }
                      ),
                      const SizedBox(height: 16),
                      InputCard(
                          icon: Icons.note_rounded,
                          title: 'Notes',
                          subtitle: 'Save your learning progress',
                          color: Colors.purple, // Changed to match purple theme
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NotesScreen()),
                            );
                          }
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
  //✔️ login
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
  Widget _buildCardButton(BuildContext context, {required IconData icon, required String title, required Color color}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (title == 'Learn') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You are already on Learn screen')),
            );
          } else if (title == 'Quiz') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuizScreen()),
            );
          } else if (title == 'Assignments') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AssignmentsScreen()),
            );
          } else if (title == 'Community') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CommunityScreen()),
            );
          }
        },

        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.4),
                  blurRadius: 12,
                  offset: Offset(0, 6))
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(height: 10),
              Text(title, style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}