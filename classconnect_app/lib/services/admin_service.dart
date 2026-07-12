import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';
import '../models/class_model.dart';

class AdminService {
  AdminService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<List<AppUser>> allUsers() {
    return _firestore
        .collection('users')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AppUser.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Stream<List<ClassModel>> allClasses() {
    return _firestore
        .collection('classes')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ClassModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> updateUserRole(String uid, UserRole role) {
    return _firestore.collection('users').doc(uid).update({
      'role': role.value,
    });
  }

  Future<void> deleteClass(String classId) {
    return _firestore.collection('classes').doc(classId).delete();
  }
}
