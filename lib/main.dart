import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:neurotick/screens/login_screen.dart';
import 'package:neurotick/screens/splash_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('🚀 Starting app...');

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBFEe9aUlf2uAHsDGIfaQgdYwWOY76HfhI",
        appId: "1:482587836394:android:7b501a54983c70568afc93",
        messagingSenderId: "482587836394",
        projectId: "neurotick-e47a4",
      ),
    );
    print('✅ Firebase initialized successfully!');
  } catch (e) {
    print('❌ Firebase error: $e');
  }


    runApp(MyApp());
  }

  class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
  title: 'NeuroTick',
  theme: ThemeData(
  primarySwatch: Colors.deepPurple, // Changed to match your app
  useMaterial3: true,
  ),
  home: SplashScreen(), // Temporary - to test login
  debugShowCheckedModeBanner: false,
  );
  }
  }