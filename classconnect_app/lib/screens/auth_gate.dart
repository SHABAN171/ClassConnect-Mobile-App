import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../services/auth_service.dart';
import 'auth/login_screen.dart';
import 'student/student_home_screen.dart';
import 'teacher/teacher_home_screen.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key});

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = authSnapshot.data;
        if (user == null) {
          return const LoginScreen();
        }

        return FutureBuilder<AppUser?>(
          future: _authService.getUserProfile(user.uid),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final profile = profileSnapshot.data;
            if (profile == null) {
              return const Scaffold(
                body: Center(
                  child: Text('Could not load your profile. Please log in again.'),
                ),
              );
            }

            return switch (profile.role) {
              UserRole.teacher => TeacherHomeScreen(user: profile),
              UserRole.student => StudentHomeScreen(user: profile),
            };
          },
        );
      },
    );
  }
}
