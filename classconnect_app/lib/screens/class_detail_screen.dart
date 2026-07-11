import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/announcement_model.dart';
import '../models/app_user.dart';
import '../models/assignment_model.dart';
import '../models/class_model.dart';
import '../services/announcement_service.dart';
import '../services/assignment_service.dart';
import 'announcements/create_announcement_screen.dart';
import 'assignments/create_assignment_screen.dart';
import 'messages/class_chat_tab.dart';

class ClassDetailScreen extends StatefulWidget {
  const ClassDetailScreen({
    super.key,
    required this.classModel,
    required this.currentUser,
  });

  final ClassModel classModel;
  final AppUser currentUser;

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen>
    with SingleTickerProviderStateMixin {
  final _announcementService = AnnouncementService();
  final _assignmentService = AssignmentService();
  late final TabController _tabController;

  bool get _isTeacher =>
      widget.currentUser.uid == widget.classModel.teacherId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openCreateScreen() {
    final route = _tabController.index == 0
        ? MaterialPageRoute(
            builder: (_) => CreateAnnouncementScreen(
              classId: widget.classModel.id,
              author: widget.currentUser,
            ),
          )
        : MaterialPageRoute(
            builder: (_) => CreateAssignmentScreen(
              classId: widget.classModel.id,
              author: widget.currentUser,
            ),
          );
    Navigator.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.classModel.name),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Announcements'),
            Tab(text: 'Assignments'),
            Tab(text: 'Messages'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Teacher: ${widget.classModel.teacherName}'),
                const SizedBox(height: 4),
                Text('Join code: ${widget.classModel.joinCode}'),
                const SizedBox(height: 4),
                Text(
                  'Students enrolled: ${widget.classModel.studentIds.length}',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAnnouncements(),
                _buildAssignments(),
                ClassChatTab(
                  classId: widget.classModel.id,
                  currentUser: widget.currentUser,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _isTeacher && _tabController.index != 2
          ? FloatingActionButton.extended(
              onPressed: _openCreateScreen,
              icon: Icon(
                _tabController.index == 0 ? Icons.campaign : Icons.assignment,
              ),
              label: Text(
                _tabController.index == 0
                    ? 'New Announcement'
                    : 'New Assignment',
              ),
            )
          : null,
    );
  }

  Widget _buildAnnouncements() {
    return StreamBuilder<List<AnnouncementModel>>(
      stream: _announcementService.classAnnouncements(widget.classModel.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final announcements = snapshot.data ?? const [];
        if (announcements.isEmpty) {
          return const Center(child: Text('No announcements yet.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            final announcement = announcements[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      announcement.title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(announcement.body),
                    const SizedBox(height: 8),
                    Text(
                      '${announcement.authorName}'
                      '${announcement.createdAt != null ? ' • ${DateFormat.yMMMd().add_jm().format(announcement.createdAt!)}' : ''}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAssignments() {
    return StreamBuilder<List<AssignmentModel>>(
      stream: _assignmentService.classAssignments(widget.classModel.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final assignments = snapshot.data ?? const [];
        if (assignments.isEmpty) {
          return const Center(child: Text('No assignments yet.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: assignments.length,
          itemBuilder: (context, index) {
            final assignment = assignments[index];
            final isOverdue =
                assignment.dueDate != null &&
                assignment.dueDate!.isBefore(DateTime.now());
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment.title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(assignment.description),
                    const SizedBox(height: 8),
                    if (assignment.dueDate != null)
                      Text(
                        'Due ${DateFormat.yMMMd().format(assignment.dueDate!)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isOverdue
                              ? Theme.of(context).colorScheme.error
                              : null,
                          fontWeight: isOverdue ? FontWeight.bold : null,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
