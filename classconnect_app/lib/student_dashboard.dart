import 'package:flutter/material.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header / Profile Bar
            _buildHeader(),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Title Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(width: 40, height: 4, color: const Color(0xFF006D77)),
                              const SizedBox(width: 12),
                              const Text(
                                'My Classes',
                                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, fontFamily: 'Georgia'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Join classes to access assignments, notes, and updates from your teachers',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                      // Join Class Button
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text('Join Class', style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006D77),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),

                  // 3. Class Grid
                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: const [
                      ClassCard(
                        title: 'Advanced React Development',
                        teacher: 'Dr. Sarah Johnson',
                        department: 'Computer Science',
                        code: 'REACT2024',
                        topColor: Color(0xFF006D77),
                      ),
                      ClassCard(
                        title: 'Web Design Fundamentals',
                        teacher: 'Prof. Michael Chen',
                        department: 'Design',
                        code: 'WEBDES24',
                        topColor: Color(0xFFE27D60),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFF006D77), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.school, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('ClassConnect', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text('Student Dashboard', style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text('Jane Doe', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('STU2024001', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(width: 16),
          IconButton(onPressed: () {}, icon: const Icon(Icons.logout_rounded, color: Colors.grey)),
        ],
      ),
    );
  }
}

class ClassCard extends StatelessWidget {
  final String title;
  final String teacher;
  final String department;
  final String code;
  final Color topColor;

  const ClassCard({
    super.key,
    required this.title,
    required this.teacher,
    required this.department,
    required this.code,
    required this.topColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Colored Section with Icon
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: topColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Icon(Icons.book_outlined, color: Colors.white, size: 60),
          ),
          // Content Section
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(teacher, style: const TextStyle(color: Colors.grey, fontSize: 15)),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: Color(0xFFF0F0F0)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(department, style: const TextStyle(color: Colors.grey)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFE6F2F3), borderRadius: BorderRadius.circular(20)),
                      child: Text(code, style: const TextStyle(color: Color(0xFF006D77), fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}