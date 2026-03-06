import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> saveUserProfile(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).set(data);
  }

  Stream<QuerySnapshot> getAllUsers() {
    return _db.collection("users").snapshots();
  }

  Future<void> savePayment(Map<String, dynamic> data) async {
    await _db.collection("payments").add(data);
  }

  Future<DocumentSnapshot> getRoutine(String level) async {
    return await _db.collection("routines").doc(level).get();
  }
}