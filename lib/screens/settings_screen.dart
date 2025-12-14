import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _notificationsEnabled = true;
  bool _darkMode = false;
  bool _vibration = true;
  String _selectedLanguage = 'English';
  double _volume = 0.7;
  String _username = 'Student';

  @override
  void initState() {
    super.initState();
    _loadSettings();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _darkMode = prefs.getBool('darkMode') ?? false;
      _vibration = prefs.getBool('vibration') ?? true;
      _selectedLanguage = prefs.getString('language') ?? 'English';
      _volume = prefs.getDouble('volume') ?? 0.7;
      _username = prefs.getString('username') ?? 'Student';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: child,
            ),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Colors.deepPurple,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                _showSnackBar('Settings saved!');
              },
              tooltip: 'Save Settings',
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Section with Hero Animation
              Hero(
                tag: 'settings_profile',
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 25),
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
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Animated Avatar
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: Center(
                          child: Icon(
                            appProvider.isLoggedIn ? Icons.person : Icons.person_outline,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              child: Text(
                                appProvider.isLoggedIn
                                    ? 'Hi, ${appProvider.userName}!'
                                    : 'Hi, Guest!',
                              ),
                            ),
                            const SizedBox(height: 5),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: 0.9,
                              child: Text(
                                appProvider.isLoggedIn
                                    ? 'Logged in • ${appProvider.loginCount} sessions'
                                    : 'Login to save progress',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Animated Login/Logout Button
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: appProvider.isLoggedIn
                            ? IconButton(
                          key: const ValueKey('logout'),
                          icon: const Icon(Icons.logout, color: Colors.white),
                          onPressed: () async {
                            await appProvider.logout();
                            _showSnackBar('Logged out successfully');
                          },
                        )
                            : IconButton(
                          key: const ValueKey('login'),
                          icon: const Icon(Icons.login, color: Colors.white),
                          onPressed: () async {
                            await appProvider.login('student@neurotick.com', 'password123');
                            _showSnackBar('Logged in as Demo User');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Settings Categories with Animations
              _buildSettingsCategory(
                title: 'App Settings',
                icon: Icons.settings,
                color: Colors.blue,
                children: [
                  _buildAnimatedSettingItem(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    trailing: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Switch(
                        key: ValueKey(_notificationsEnabled),
                        value: _notificationsEnabled,
                        activeColor: Colors.blue,
                        onChanged: (value) {
                          setState(() => _notificationsEnabled = value);
                          _saveSetting('notifications', value);
                        },
                      ),
                    ),
                  ),
                  _buildAnimatedSettingItem(
                    icon: Icons.dark_mode,
                    title: 'Dark Mode',
                    trailing: Consumer<AppProvider>(
                      builder: (context, appProvider, child) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Switch(
                            key: ValueKey(appProvider.isDarkMode),
                            value: appProvider.isDarkMode,
                            activeColor: Colors.deepPurple,
                            onChanged: (value) {
                              // 1. Update Provider state
                              appProvider.setDarkMode(value);
                              // 2. Save to SharedPreferences
                              _saveSetting('darkMode', value);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  _buildAnimatedSettingItem(
                    icon: Icons.vibration,
                    title: 'Vibration',
                    trailing: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Switch(
                        key: ValueKey(_vibration),
                        value: _vibration,
                        activeColor: Colors.green,
                        onChanged: (value) {
                          setState(() => _vibration = value);
                          _saveSetting('vibration', value);
                        },
                      ),
                    ),
                  ),
                  _buildAnimatedSettingItem(
                    icon: Icons.volume_up,
                    title: 'Volume',
                    trailing: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 120,
                      child: Slider(
                        value: _volume,
                        min: 0,
                        max: 1,
                        divisions: 10,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.blue.withOpacity(0.3),
                        onChanged: (value) {
                          setState(() => _volume = value);
                          _saveSetting('volume', value);
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Language Settings with Animation
              _buildSettingsCategory(
                title: 'Language & Region',
                icon: Icons.language,
                color: Colors.green,
                children: [
                  _buildAnimatedSettingItem(
                    icon: Icons.translate,
                    title: 'Language',
                    subtitle: _selectedLanguage,
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      onSelected: (value) {
                        setState(() => _selectedLanguage = value);
                        _saveSetting('language', value);
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'English',
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              'English',
                              key: ValueKey(_selectedLanguage == 'English'),
                              style: TextStyle(
                                color: _selectedLanguage == 'English'
                                    ? Colors.deepPurple
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'Hindi',
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              'Hindi',
                              key: ValueKey(_selectedLanguage == 'Hindi'),
                              style: TextStyle(
                                color: _selectedLanguage == 'Hindi'
                                    ? Colors.deepPurple
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'Spanish',
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              'Spanish',
                              key: ValueKey(_selectedLanguage == 'Spanish'),
                              style: TextStyle(
                                color: _selectedLanguage == 'Spanish'
                                    ? Colors.deepPurple
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Data Management with Provider
              _buildSettingsCategory(
                title: 'Data Management',
                icon: Icons.storage,
                color: Colors.orange,
                children: [
                  _buildAnimatedSettingItem(
                    icon: Icons.bar_chart,
                    title: 'Quiz Statistics',
                    subtitle: '${appProvider.totalQuizzesTaken} quizzes taken',
                    trailing: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${appProvider.totalScore} pts',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                  _buildAnimatedSettingItem(
                    icon: Icons.delete,
                    title: 'Clear All Data',
                    subtitle: 'Reset app to default',
                    trailing: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: IconButton(
                        icon: const Icon(Icons.delete_forever, color: Colors.red),
                        onPressed: () {
                          _showConfirmationDialog(
                            title: 'Clear All Data',
                            message: 'This will reset all quiz progress and settings. Are you sure?',
                            onConfirm: () {
                              appProvider.resetQuizData();
                              _showSnackBar('All data cleared successfully');
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // About Section with Animation
              _buildSettingsCategory(
                title: 'About',
                icon: Icons.info,
                color: Colors.purple,
                children: [
                  _buildAnimatedSettingItem(
                    icon: Icons.code,
                    title: 'App Version',
                    subtitle: 'NeuroTick v1.0.0',
                    trailing: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Latest',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  _buildAnimatedSettingItem(
                    icon: Icons.privacy_tip,
                    title: 'Privacy Policy',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                      _showPrivacyPolicy();
                    },
                  ),
                  _buildAnimatedSettingItem(
                    icon: Icons.star,
                    title: 'Rate App',
                    trailing: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (index) => Icon(
                          Icons.star,
                          size: 16,
                          color: index < 4 ? Colors.amber : Colors.grey[300],
                        )),
                      ),
                    ),
                    onTap: () {
                      _showSnackBar('Opening Play Store...');
                    },
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Save Settings Button with Animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _controller.reverse().then((_) {
                      _controller.forward();
                      _showSnackBar('Settings saved successfully!');
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: Colors.deepPurple.withOpacity(0.3),
                  ),
                  icon: AnimatedRotation(
                    duration: const Duration(milliseconds: 1000),
                    turns: 1.0,
                    child: const Icon(Icons.save, color: Colors.white),
                  ),
                  label: const Text(
                    'SAVE ALL SETTINGS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCategory({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header with Animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  child: Text(title),
                ),
              ],
            ),
          ),
          // Settings Items
          ...children,
        ],
      ),
    );
  }

  Widget _buildAnimatedSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.1)),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.deepPurple),
        ),
        title: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          child: Text(title),
        ),
        subtitle: subtitle != null
            ? AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: 0.7,
          child: Text(
            subtitle,
            style: const TextStyle(fontSize: 12),
          ),
        )
            : null,
        trailing: trailing,
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showConfirmationDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'NeuroTick respects your privacy. We collect minimal data to improve your learning experience. '
                  'All quiz scores and progress are stored locally on your device.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}