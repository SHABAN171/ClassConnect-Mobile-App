import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../../models/class_model.dart';
import '../../services/auth_service.dart';
import '../../services/class_service.dart';
import '../class_detail_screen.dart';
import 'join_class_screen.dart';

class StudentHomeScreen extends StatelessWidget {
  StudentHomeScreen({super.key, required this.user});

  final AppUser user;
  final _classService = ClassService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthService().logout(),
          ),
        ],
      ),
      body: StreamBuilder<List<ClassModel>>(
        stream: _classService.studentClasses(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final classes = snapshot.data ?? const [];
          if (classes.isEmpty) {
            return const Center(
              child: Text('You haven\'t joined any classes yet.'),
            );
          }
          return ListView.builder(
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final classModel = classes[index];
              return ListTile(
                title: Text(classModel.name),
                subtitle: Text('Teacher: ${classModel.teacherName}'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ClassDetailScreen(
                        classModel: classModel,
                        currentUser: user,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => JoinClassScreen(student: user),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Join Class'),
      ),
    );
  }
}
