import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/assignment_model.dart';

class AssignmentService {
  AssignmentService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

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
  }) {
    return _assignments(classId).add({
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
