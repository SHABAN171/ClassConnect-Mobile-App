import 'package:flutter/material.dart';

import '../../models/app_user.dart';
import '../../models/class_model.dart';
import '../../services/admin_service.dart';
import '../../services/auth_service.dart';
import '../../services/theme_controller.dart';
import '../../widgets/theme_toggle_button.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({
    super.key,
    required this.user,
    required this.themeController,
  });

  final AppUser user;
  final ThemeController themeController;

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  final _adminService = AdminService();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _changeRole(AppUser user, UserRole role) async {
    try {
      await _adminService.updateUserRole(user.uid, role);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not update role: $e')));
    }
  }

  Future<void> _deleteClass(ClassModel classModel) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete class?'),
        content: Text(
          'This permanently deletes "${classModel.name}". This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _adminService.deleteClass(classModel.id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not delete class: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Users'), Tab(text: 'Classes')],
        ),
        actions: [
          ThemeToggleButton(themeController: widget.themeController),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthService().logout(),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildUsersTab(), _buildClassesTab()],
      ),
    );
  }

  Widget _buildUsersTab() {
    return StreamBuilder<List<AppUser>>(
      stream: _adminService.allUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final users = snapshot.data ?? const [];
        if (users.isEmpty) {
          return const Center(child: Text('No users yet.'));
        }
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text(user.name),
              subtitle: Text(user.email),
              trailing: DropdownButton<UserRole>(
                value: user.role,
                items: UserRole.values
                    .map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Text(role.label),
                      ),
                    )
                    .toList(),
                onChanged: (role) {
                  if (role != null && role != user.role) {
                    _changeRole(user, role);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildClassesTab() {
    return StreamBuilder<List<ClassModel>>(
      stream: _adminService.allClasses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final classes = snapshot.data ?? const [];
        if (classes.isEmpty) {
          return const Center(child: Text('No classes yet.'));
        }
        return ListView.builder(
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final classModel = classes[index];
            return ListTile(
              title: Text(classModel.name),
              subtitle: Text(
                'Teacher: ${classModel.teacherName} • '
                '${classModel.studentIds.length} students • '
                'Code: ${classModel.joinCode}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _deleteClass(classModel),
              ),
            );
          },
        );
      },
    );
  }
}
