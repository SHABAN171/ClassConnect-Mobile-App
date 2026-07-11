import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  const MessageModel({
    required this.id,
    required this.text,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
  });

  final String id;
  final String text;
  final String authorId;
  final String authorName;
  final DateTime? createdAt;

  factory MessageModel.fromMap(String id, Map<String, dynamic> map) {
    final timestamp = map['createdAt'];
    return MessageModel(
      id: id,
      text: map['text'] as String? ?? '',
      authorId: map['authorId'] as String? ?? '',
      authorName: map['authorName'] as String? ?? '',
      createdAt: timestamp is Timestamp ? timestamp.toDate() : null,
    );
  }
}
