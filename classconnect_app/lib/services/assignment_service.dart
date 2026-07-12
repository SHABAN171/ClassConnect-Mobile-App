import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/assignment_model.dart';

class AssignmentService {
  AssignmentService({FirebaseFirestore? firestore, FirebaseStorage? storage})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  CollectionReference<Map<String, dynamic>> _assignments(String classId) {
    return _firestore
        .collection('classes')
        .doc(classId)
        .collection('assignments');
  }

  Stream<List<AssignmentModel>> classAssignments(String classId) {
    return _assignments(classId)
        .orderBy('dueDate')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AssignmentModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> postAssignment({
    required String classId,
    required String title,
    required String description,
    required DateTime dueDate,
    required String authorId,
    required String authorName,
    Uint8List? fileBytes,
    String? fileName,
  }) async {
    final doc = _assignments(classId).doc();
    String? attachmentUrl;

    if (fileBytes != null && fileName != null) {
      final ref = _storage.ref('assignments/$classId/${doc.id}/$fileName');
      await ref.putData(fileBytes);
      attachmentUrl = await ref.getDownloadURL();
    }

    await doc.set({
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': FieldValue.serverTimestamp(),
      'attachmentUrl': ?attachmentUrl,
      'attachmentName': ?fileName,
    });
  }
}
