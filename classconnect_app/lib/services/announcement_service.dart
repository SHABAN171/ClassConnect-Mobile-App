import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/announcement_model.dart';

class AnnouncementService {
  AnnouncementService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _announcements(String classId) {
    return _firestore
        .collection('classes')
        .doc(classId)
        .collection('announcements');
  }

  Stream<List<AnnouncementModel>> classAnnouncements(String classId) {
    return _announcements(classId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AnnouncementModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> postAnnouncement({
    required String classId,
    required String title,
    required String body,
    required String authorId,
    required String authorName,
  }) {
    return _announcements(classId).add({
      'title': title,
      'body': body,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
