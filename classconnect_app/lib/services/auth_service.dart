import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';

class AuthService {
  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = credential.user!.uid;
    final profile = AppUser(uid: uid, email: email, name: name, role: role);
    await _firestore.collection('users').doc(uid).set(profile.toMap());
  }

  Future<void> login({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() {
    return _auth.signOut();
  }

  Future<AppUser?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(uid, doc.data()!);
  }

  /// Firestore's `whereIn` accepts at most 10 values, so batch requests for
  /// larger rosters into chunks of 10.
  Future<List<AppUser>> getUserProfiles(List<String> uids) async {
    if (uids.isEmpty) return [];
    final users = <AppUser>[];
    for (var i = 0; i < uids.length; i += 10) {
      final chunk = uids.sublist(i, i + 10 > uids.length ? uids.length : i + 10);
      final snapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      users.addAll(
        snapshot.docs.map((doc) => AppUser.fromMap(doc.id, doc.data())),
      );
    }
    return users;
  }
}
