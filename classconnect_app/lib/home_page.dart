import 'package:flutter/material.dart';

void main() {
  runApp(const ClassConnectApp());
}

class ClassConnectApp extends StatelessWidget {
  const ClassConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Georgia', // Matches the serif style in image_954b57.png
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFA), // Slight off-white background
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
       child: Center( // Wraps the column to ensure it is centered in the padding area
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Starts from the top
            crossAxisAlignment: CrossAxisAlignment.center, // Centers text and cards horizontally
            children: [
            const Text(
              'ClassConnect',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Seamless communication platform connecting teachers and students for enhanced learning',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 60),
            // Layout adapts to screen width (Responsive)
            Wrap(
              spacing: 30,
              runSpacing: 30,
              alignment: WrapAlignment.center,
              children: const [
                RoleCard(
                  icon: Icons.book_outlined,
                  roleTitle: "I'm a Student",
                  description:
                      "Join classes, view assignments, access notes, and stay connected with your teachers.",
                  primaryColor: Color(0xFF006D77), // Teal
                  iconBgColor: Color(0xFFE6F2F3),
                ),
                RoleCard(
                  icon: Icons.people_outline,
                  roleTitle: "I'm a Teacher",
                  description:
                      "Create classrooms, share resources, manage assignments, and communicate with students.",
                  primaryColor: Color(0xFFE27D60), // Coral/Orange
                  iconBgColor: Color(0xFFFBECE8),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final IconData icon;
  final String roleTitle;
  final String description;
  final Color primaryColor;
  final Color iconBgColor;

  const RoleCard({
    super.key,
    required this.icon,
    required this.roleTitle,
    required this.description,
    required this.primaryColor,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryColor, size: 32),
          ),
          const SizedBox(height: 24),
          Text(
            roleTitle,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 40),
          // Create Account Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Create Account', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Login Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryColor),
                foregroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Login', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}