import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/class_model.dart';

class ClassService {
  ClassService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _classes =>
      _firestore.collection('classes');

  Stream<List<ClassModel>> teacherClasses(String teacherId) {
    return _classes
        .where('teacherId', isEqualTo: teacherId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ClassModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Stream<List<ClassModel>> studentClasses(String studentId) {
    return _classes
        .where('studentIds', arrayContains: studentId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ClassModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<ClassModel> createClass({
    required String name,
    required String teacherId,
    required String teacherName,
  }) async {
    final joinCode = await _generateUniqueJoinCode();
    final doc = _classes.doc();
    final classModel = ClassModel(
      id: doc.id,
      name: name,
      teacherId: teacherId,
      teacherName: teacherName,
      joinCode: joinCode,
      studentIds: const [],
    );
    await doc.set({
      ...classModel.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return classModel;
  }

  Future<ClassModel> joinClass({
    required String joinCode,
    required String studentId,
  }) async {
    final normalizedCode = joinCode.trim().toUpperCase();
    final matches = await _classes
        .where('joinCode', isEqualTo: normalizedCode)
        .limit(1)
        .get();

    if (matches.docs.isEmpty) {
      throw StateError('No class found with that code.');
    }

    final doc = matches.docs.first;
    await doc.reference.update({
      'studentIds': FieldValue.arrayUnion([studentId]),
    });

    final updatedStudentIds = List<String>.from(
      doc.data()['studentIds'] as List? ?? const [],
    )..add(studentId);
    return ClassModel.fromMap(doc.id, {
      ...doc.data(),
      'studentIds': updatedStudentIds,
    });
  }

  Future<String> _generateUniqueJoinCode() async {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random.secure();

    while (true) {
      final code = List.generate(
        6,
        (_) => chars[random.nextInt(chars.length)],
      ).join();
      final existing = await _classes
          .where('joinCode', isEqualTo: code)
          .limit(1)
          .get();
      if (existing.docs.isEmpty) return code;
    }
  }
}
