import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementModel {
  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.body,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final String authorId;
  final String authorName;
  final DateTime? createdAt;

  factory AnnouncementModel.fromMap(String id, Map<String, dynamic> map) {
    final timestamp = map['createdAt'];
    return AnnouncementModel(
      id: id,
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      authorId: map['authorId'] as String? ?? '',
      authorName: map['authorName'] as String? ?? '',
      createdAt: timestamp is Timestamp ? timestamp.toDate() : null,
    );
  }
}
