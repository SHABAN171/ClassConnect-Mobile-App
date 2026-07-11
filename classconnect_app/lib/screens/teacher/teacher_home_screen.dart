import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../../models/class_model.dart';
import '../../services/auth_service.dart';
import '../../services/class_service.dart';
import '../class_detail_screen.dart';
import 'create_class_screen.dart';

class TeacherHomeScreen extends StatelessWidget {
  TeacherHomeScreen({super.key, required this.user});

  final AppUser user;
  final _classService = ClassService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthService().logout(),
          ),
        ],
      ),
      body: StreamBuilder<List<ClassModel>>(
        stream: _classService.teacherClasses(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final classes = snapshot.data ?? const [];
          if (classes.isEmpty) {
            return const Center(
              child: Text('You haven\'t created any classes yet.'),
            );
          }
          return ListView.builder(
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final classModel = classes[index];
              return ListTile(
                title: Text(classModel.name),
                subtitle: Text('Join code: ${classModel.joinCode}'),
                trailing: Text('${classModel.studentIds.length} students'),
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
              builder: (_) => CreateClassScreen(teacher: user),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Class'),
      ),
    );
  }
}
