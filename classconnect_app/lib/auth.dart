import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  final bool isSignUp;
  final bool isTeacher;

  const AuthPage({
    super.key,
    required this.isSignUp,
    required this.isTeacher,
  });

  @override
  Widget build(BuildContext context) {
    // Select color based on the role from image_954b57.png
    final Color themeColor = isTeacher ? const Color(0xFFE27D60) : const Color(0xFF006D77);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFA),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSignUp ? 'Create Account' : 'Welcome Back',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
                ),
                Text(
                  isTeacher ? 'Teacher Portal' : 'Student Portal',
                  style: TextStyle(color: themeColor, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 32),
                
                // Form Fields
                if (isSignUp) _buildTextField('Full Name', Icons.person_outline, themeColor),
                _buildTextField('Email Address', Icons.email_outlined, themeColor),
                _buildTextField('Password', Icons.lock_outline, themeColor, isPassword: true),
                
                const SizedBox(height: 32),
                
                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(isSignUp ? 'Sign Up' : 'Login'),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Toggle between Sign In / Sign Up
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to the opposite state
                    },
                    child: Text(
                      isSignUp ? 'Already have an account? Login' : 'New here? Create an account',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, Color color, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: color),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: color, width: 2),
          ),
        ),
      ),
    );
  }
}