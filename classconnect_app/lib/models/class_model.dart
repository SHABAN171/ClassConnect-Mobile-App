class ClassModel {
  const ClassModel({
    required this.id,
    required this.name,
    required this.teacherId,
    required this.teacherName,
    required this.joinCode,
    required this.studentIds,
  });

  final String id;
  final String name;
  final String teacherId;
  final String teacherName;
  final String joinCode;
  final List<String> studentIds;

  factory ClassModel.fromMap(String id, Map<String, dynamic> map) {
    return ClassModel(
      id: id,
      name: map['name'] as String? ?? '',
      teacherId: map['teacherId'] as String? ?? '',
      teacherName: map['teacherName'] as String? ?? '',
      joinCode: map['joinCode'] as String? ?? '',
      studentIds: List<String>.from(map['studentIds'] as List? ?? const []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'joinCode': joinCode,
      'studentIds': studentIds,
    };
  }
}
