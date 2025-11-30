import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _startAnimation();
  }

  void _startAnimation() async {
    // Start fade-in animation
    await _controller.forward();

    // Wait additional time after animation completes
    await Future.delayed(Duration(milliseconds: 1000));

    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    // Check if user is already logged in
    final user = FirebaseAuth.instance.currentUser;

    // Navigate to appropriate screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => user != null ? HomeScreen() : LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F7FF), // Soft lavender background
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Purple Logo Container
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE2E0FF), Color(0xFF9370DB)], // Soft lavender to medium purple
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF9370DB).withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              SizedBox(height: 30),

              // App Name
              Text(
                'NeuroTick',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A5ACD), // Elegant slate blue
                ),
              ),
              SizedBox(height: 10),

              // Tagline
              Text(
                'AR Learning Platform',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF7B68EE), // Medium slate blue
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 20),

              // Loading Indicator
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF9370DB), // Medium purple
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}