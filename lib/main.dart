import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import './screens/home_screen.dart';
import './providers/app_provider.dart';
import './screens/splash_screen.dart';

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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroTick - Learn with AR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: SplashScreen(), // Start with splash screen
    );
  }
}