import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'settings_screen.dart'; // Import your settings screen

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final progress = appProvider.getUserProgress();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            backgroundColor: Colors.deepPurple,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(),
                    ),
                  );
                },
                tooltip: 'Settings',
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // User Info Card with Animation
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.deepPurple, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Animated Avatar
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: Center(
                            child: Icon(
                              appProvider.isLoggedIn ? Icons.person : Icons.person_outline,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          child: Text(
                            appProvider.isLoggedIn
                                ? 'Welcome, ${appProvider.userName}!'
                                : 'Guest User',
                          ),
                        ),
                        const SizedBox(height: 10),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: appProvider.isLoggedIn ? 1.0 : 0.7,
                          child: Text(
                            appProvider.isLoggedIn
                                ? 'Login Count: ${appProvider.loginCount}'
                                : 'Please login to track progress',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Profile Options Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildProfileOption(
                            icon: Icons.person,
                            title: 'Edit Profile',
                            subtitle: 'Update your personal information',
                            onTap: () {
                              // Navigate to edit profile screen
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Edit Profile feature coming soon!')),
                              );
                            },
                          ),
                          Divider(height: 1, color: Colors.grey[300]),
                          _buildProfileOption(
                            icon: Icons.settings,
                            title: 'Settings',
                            subtitle: 'App preferences and configurations',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsScreen(),
                                ),
                              );
                            },
                          ),
                          Divider(height: 1, color: Colors.grey[300]),
                          _buildProfileOption(
                            icon: Icons.notifications,
                            title: 'Notifications',
                            subtitle: 'Manage your notification preferences',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsScreen(),
                                ),
                              );
                            },
                          ),
                          Divider(height: 1, color: Colors.grey[300]),
                          _buildProfileOption(
                            icon: Icons.security,
                            title: 'Privacy & Security',
                            subtitle: 'Manage your account security',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Progress Stats with Animations
                  AnimatedSlide(
                    duration: const Duration(milliseconds: 600),
                    offset: Offset.zero,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text(
                              'Learning Progress',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Animated Progress Items
                            _buildStatItem(
                              'Total Quizzes',
                              '${progress['totalQuizzes']}',
                              Icons.quiz,
                              Colors.blue,
                            ),
                            _buildStatItem(
                              'Average Score',
                              '${progress['averageScore']}',
                              Icons.star,
                              Colors.amber,
                            ),
                            _buildStatItem(
                              'Favorite Subject',
                              progress['favoriteSubject'],
                              Icons.favorite,
                              Colors.red,
                            ),
                            _buildStatItem(
                              'Total Score',
                              '${progress['totalScore']}',
                              Icons.emoji_events,
                              Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Subject Scores with Animation
                  if (appProvider.subjectScores.isNotEmpty)
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 800),
                      opacity: 1.0,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Subject Scores',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.refresh, size: 20),
                                    onPressed: appProvider.resetQuizData,
                                    tooltip: 'Reset Data',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              ...appProvider.subjectScores.entries.map(
                                    (entry) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          entry.key,
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      AnimatedDefaultTextStyle(
                                        duration: const Duration(milliseconds: 300),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                        ),
                                        child: Text('${entry.value} pts'),
                                      ),
                                    ],
                                  ),
                                ),
                              ).toList(),
                            ],
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Login/Logout Button with Animation
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (appProvider.isLoggedIn) {
                          await appProvider.logout();
                        } else {
                          // Simulate login
                          await appProvider.login('student@neurotick.com', 'password123');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appProvider.isLoggedIn ? Colors.red : Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: appProvider.isLoggedIn
                            ? const Text('Logout', style: TextStyle(color: Colors.white))
                            : const Text('Login as Demo User', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.deepPurple),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}