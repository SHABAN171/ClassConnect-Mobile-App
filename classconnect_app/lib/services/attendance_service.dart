import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../models/attendance_model.dart';

class AttendanceService {
  AttendanceService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static final DateFormat _sessionIdFormat = DateFormat('yyyy-MM-dd');

  CollectionReference<Map<String, dynamic>> _attendance(String classId) {
    return _firestore
        .collection('classes')
        .doc(classId)
        .collection('attendance');
  }

  Stream<List<AttendanceModel>> classAttendance(String classId) {
    return _attendance(classId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AttendanceModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> takeAttendance({
    required String classId,
    required DateTime date,
    required Map<String, AttendanceStatus> records,
    required String takenBy,
  }) {
    final sessionId = _sessionIdFormat.format(date);
    return _attendance(classId).doc(sessionId).set({
      'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
      'records': records.map((uid, status) => MapEntry(uid, status.value)),
      'takenBy': takenBy,
    });
  }
}
