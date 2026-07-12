import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum AttendanceStatus { present, absent, late }

extension AttendanceStatusX on AttendanceStatus {
  String get label => switch (this) {
    AttendanceStatus.present => 'Present',
    AttendanceStatus.absent => 'Absent',
    AttendanceStatus.late => 'Late',
  };

  Color get color => switch (this) {
    AttendanceStatus.present => Colors.green,
    AttendanceStatus.absent => Colors.red,
    AttendanceStatus.late => Colors.orange,
  };

  String get value => name;

  static AttendanceStatus fromValue(String value) {
    return AttendanceStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => AttendanceStatus.absent,
    );
  }
}

class AttendanceModel {
  const AttendanceModel({
    required this.id,
    required this.date,
    required this.records,
    required this.takenBy,
  });

  /// yyyy-MM-dd, doubles as the session's Firestore document id.
  final String id;
  final DateTime date;
  final Map<String, AttendanceStatus> records;
  final String takenBy;

  factory AttendanceModel.fromMap(String id, Map<String, dynamic> map) {
    final timestamp = map['date'];
    final rawRecords = Map<String, dynamic>.from(
      map['records'] as Map? ?? const {},
    );
    return AttendanceModel(
      id: id,
      date: timestamp is Timestamp ? timestamp.toDate() : DateTime.now(),
      records: rawRecords.map(
        (uid, status) =>
            MapEntry(uid, AttendanceStatusX.fromValue(status as String)),
      ),
      takenBy: map['takenBy'] as String? ?? '',
    );
  }
}
