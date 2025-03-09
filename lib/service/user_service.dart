import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/users_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final String usersCollections = 'users';

  Future<bool> checkUserExists(String uid) async {
    var userDoc = await _firestore.collection(usersCollections).doc(uid).get();
    return userDoc.exists;
  }

  Future<void> saveUserProfile({
    required String firstName,
    required String lastName,
    required DateTime birthDay,
  }) async {
    String uid = _auth.currentUser!.uid;
    await _firestore.collection("users").doc(uid).set({
      'userId': uid,
      'email': _auth.currentUser!.email,
      'firstName': firstName,
      'lastName': lastName,
      'birthDay': Timestamp.fromDate(birthDay),
      'age': DateTime.now().year - birthDay.year,
    });
  }

  Future<UsersModel?> fetchUserDataByUserId(String uid) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection(usersCollections)
          .doc(uid)
          .get();

      if (!userDoc.exists || userDoc.data() == null) {
        return null;
      }

      final data = userDoc.data()!;

      try {
        final userModel = UsersModel.fromJson(data);
        return userModel;
      } catch (e) {
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<bool> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(usersCollections).doc(userId).update(data);
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }
}
