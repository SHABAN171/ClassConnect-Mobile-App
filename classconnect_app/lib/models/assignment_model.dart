import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentModel {
  const AssignmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    this.attachmentUrl,
    this.attachmentName,
  });

  final String id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final String authorId;
  final String authorName;
  final DateTime? createdAt;
  final String? attachmentUrl;
  final String? attachmentName;

  bool get hasAttachment => attachmentUrl != null && attachmentName != null;

  factory AssignmentModel.fromMap(String id, Map<String, dynamic> map) {
    final createdAt = map['createdAt'];
    final dueDate = map['dueDate'];
    return AssignmentModel(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      dueDate: dueDate is Timestamp ? dueDate.toDate() : null,
      authorId: map['authorId'] as String? ?? '',
      authorName: map['authorName'] as String? ?? '',
      createdAt: createdAt is Timestamp ? createdAt.toDate() : null,
      attachmentUrl: map['attachmentUrl'] as String?,
      attachmentName: map['attachmentName'] as String?,
    );
  }
}
