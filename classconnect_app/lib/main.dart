import 'package:flutter/material.dart';
import 'auth.dart'; // Ensure this matches your filename
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClassConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Using a cleaner color scheme that fits your design
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006D77),
          primary: const Color(0xFF006D77),
        ),
        fontFamily: 'Georgia', // Matching the ClassConnect branding
      ),
      // The app starts at the HomePage
      home: const HomePage(), 
      
      // Named routes for easier navigation
      routes: {
        '/home': (context) => const HomePage(),
        // We define specific routes for the different auth modes
        '/student_signup': (context) => const AuthPage(isSignUp: true, isTeacher: false),
        '/teacher_signup': (context) => const AuthPage(isSignUp: true, isTeacher: true),
        '/student_login': (context) => const AuthPage(isSignUp: false, isTeacher: false),
        '/teacher_login': (context) => const AuthPage(isSignUp: false, isTeacher: true),
      },
    );
  }
}