import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message_model.dart';

class MessageService {
  MessageService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _messages(String classId) {
    return _firestore
        .collection('classes')
        .doc(classId)
        .collection('messages');
  }

  Stream<List<MessageModel>> classMessages(String classId) {
    return _messages(classId)
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> sendMessage({
    required String classId,
    required String text,
    required String authorId,
    required String authorName,
  }) {
    return _messages(classId).add({
      'text': text,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
