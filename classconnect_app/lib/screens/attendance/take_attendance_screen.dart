import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/app_user.dart';
import '../../models/attendance_model.dart';
import '../../models/class_model.dart';
import '../../services/attendance_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/primary_button.dart';

class TakeAttendanceScreen extends StatefulWidget {
  const TakeAttendanceScreen({
    super.key,
    required this.classModel,
    required this.teacher,
  });

  final ClassModel classModel;
  final AppUser teacher;

  @override
  State<TakeAttendanceScreen> createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends State<TakeAttendanceScreen> {
  final _authService = AuthService();
  final _attendanceService = AttendanceService();
  final Map<String, AttendanceStatus> _statuses = {};
  DateTime _date = DateTime.now();
  List<AppUser>? _students;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadRoster();
  }

  Future<void> _loadRoster() async {
    final students = await _authService.getUserProfiles(
      widget.classModel.studentIds,
    );
    if (!mounted) return;
    setState(() {
      _students = students;
      for (final student in students) {
        _statuses.putIfAbsent(student.uid, () => AttendanceStatus.present);
      }
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _submit() async {
    setState(() => _isSaving = true);
    try {
      await _attendanceService.takeAttendance(
        classId: widget.classModel.id,
        date: _date,
        records: _statuses,
        takenBy: widget.teacher.uid,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not save attendance: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final students = _students;
    return Scaffold(
      appBar: AppBar(title: const Text('Take Attendance')),
      body: students == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ListTile(
                  title: Text('Date: ${DateFormat.yMMMd().format(_date)}'),
                  trailing: const Icon(Icons.calendar_month),
                  onTap: _pickDate,
                ),
                const Divider(height: 1),
                Expanded(
                  child: students.isEmpty
                      ? const Center(
                          child: Text('No students enrolled yet.'),
                        )
                      : ListView.builder(
                          itemCount: students.length,
                          itemBuilder: (context, index) {
                            final student = students[index];
                            final status =
                                _statuses[student.uid] ??
                                AttendanceStatus.present;
                            return ListTile(
                              title: Text(student.name),
                              subtitle: SegmentedButton<AttendanceStatus>(
                                segments: AttendanceStatus.values
                                    .map(
                                      (s) => ButtonSegment(
                                        value: s,
                                        label: Text(s.label),
                                      ),
                                    )
                                    .toList(),
                                selected: {status},
                                onSelectionChanged: (selection) {
                                  setState(
                                    () => _statuses[student.uid] =
                                        selection.first,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: PrimaryButton(
                    label: 'Save Attendance',
                    isLoading: _isSaving,
                    onPressed: students.isEmpty ? null : _submit,
                  ),
                ),
              ],
            ),
    );
  }
}
