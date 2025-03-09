import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../model/users_model.dart';
import 'shared_prefercense_service.dart';

class FacebookAuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final String userCollection = 'users';

  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        final userCredential = await _auth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          try {
            final docSnapshot =
                await _firestore.collection(userCollection).doc(user.uid).get();

            if (docSnapshot.exists) {
              final userData = docSnapshot.data() as Map<String, dynamic>;
              final existingUserModel = UsersModel.fromJson(userData);

              // บันทึกข้อมูลผู้ใช้ลง SharedPreferences
              SharedPrefercenseService.saveUser(existingUserModel);

              print('Existing user, data loaded from Firestore');
              return userCredential; // ส่งคืนข้อมูลผู้ใช้
            } else {
              String firstName = '';
              String lastName = '';

              if (user.displayName != null && user.displayName!.contains(' ')) {
                List<String> nameParts = user.displayName!.split(' ');
                firstName = nameParts[0];
                lastName = nameParts.length > 1 ? nameParts[1] : '';
              } else {
                firstName = user.displayName ?? '';
              }

              UsersModel userModel = UsersModel(
                userId: user.uid,
                email: user.email ?? '',
                firstName: firstName,
                lastName: lastName,
                password: '',
                birthDay: null,
                period: null,
                authMethod: 'facebook',
              );

              await _firestore
                  .collection(userCollection)
                  .doc(user.uid)
                  .set(userModel.toJson());

              SharedPrefercenseService.saveUser(userModel);

              print('New user, data created and saved');
              return userCredential; // ส่งคืนข้อมูลผู้ใช้
            }
          } catch (firestoreError) {
            print('Firestore error: $firestoreError');
            return userCredential;
          }
        } else {
          return null; // ถ้าไม่มีผู้ใช้
        }
      } else {
        return null; // ถ้าล็อกอินไม่สำเร็จ
      }
    } catch (e) {
      print("Error: $e");
      print("Detailed error during Facebook sign in: $e");
      return null; // หากเกิดข้อผิดพลาดระหว่างการล็อกอิน
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await FacebookAuth.instance.logOut();
  }
}
