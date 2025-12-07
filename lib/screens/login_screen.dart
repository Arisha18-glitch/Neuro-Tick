import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String _errorMessage = '';
  bool _isLoading = false;
  bool _isLogin = true;

  void _submit() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    if (_passwordController.text.length < 6) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      UserCredential userCredential;

      if (_isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }

      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _getErrorMessage(e.code);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return 'Password is too weak';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email address';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              // Back button and title
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.deepPurple),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  SizedBox(width: 8),
                  Text(
                    _isLogin ? 'Welcome Back' : 'Create Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                _isLogin
                    ? 'Sign in to continue your learning journey'
                    : 'Join NeuroTick and start exploring with AR',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 32),

              // Email Field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),

              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.deepPurple),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              SizedBox(height: 20),

              // Error Message
              if (_errorMessage.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red[800], fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: _errorMessage.isNotEmpty ? 20 : 0),

              // Login Button
              _isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.deepPurple))
                  : ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  _isLogin ? 'Sign In' : 'Create Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

              SizedBox(height: 16),

              // Toggle between Login/Register
              TextButton(
                onPressed: _toggleMode,
                child: RichText(
                  text: TextSpan(
                    text: _isLogin
                        ? "Don't have an account? "
                        : "Already have an account? ",
                    style: TextStyle(color: Colors.grey[600]),
                    children: [
                      TextSpan(
                        text: _isLogin ? "Sign Up" : "Sign In",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Spacer to push content up
              Spacer(),

              // Brand footer
              Column(
                children: [
                  SizedBox(height: 8),
                  Text(
                    'NeuroTick',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}