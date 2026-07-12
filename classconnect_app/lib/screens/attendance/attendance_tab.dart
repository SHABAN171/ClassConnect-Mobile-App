import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/app_user.dart';
import '../../models/attendance_model.dart';
import '../../services/attendance_service.dart';

class AttendanceTab extends StatelessWidget {
  AttendanceTab({super.key, required this.classId, required this.currentUser});

  final String classId;
  final AppUser currentUser;
  final _attendanceService = AttendanceService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AttendanceModel>>(
      stream: _attendanceService.classAttendance(classId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final sessions = snapshot.data ?? const [];
        if (sessions.isEmpty) {
          return const Center(child: Text('No attendance taken yet.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(DateFormat.yMMMd().format(session.date)),
                subtitle: _buildSubtitle(session),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSubtitle(AttendanceModel session) {
    final myStatus = session.records[currentUser.uid];
    if (myStatus != null && currentUser.role == UserRole.student) {
      return Text(
        'You: ${myStatus.label}',
        style: TextStyle(
          color: myStatus.color,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    final counts = <AttendanceStatus, int>{};
    for (final status in session.records.values) {
      counts[status] = (counts[status] ?? 0) + 1;
    }
    return Text(
      AttendanceStatus.values
          .where((status) => (counts[status] ?? 0) > 0)
          .map((status) => '${status.label}: ${counts[status]}')
          .join(' • '),
    );
  }
}
