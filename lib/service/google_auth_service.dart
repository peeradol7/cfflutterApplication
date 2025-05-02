import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_care/model/users_model.dart';
import 'package:fam_care/service/shared_prefercense_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final String userCollection = 'users';

  Future<User?> loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      await auth.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('Sign in aborted by user');
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        try {
          final docSnapshot =
              await _firestore.collection(userCollection).doc(user.uid).get();

          if (docSnapshot.exists) {
            final userData = docSnapshot.data() as Map<String, dynamic>;
            final existingUserModel = UsersModel.fromJson(userData);

            SharedPrefercenseService.saveUser(existingUserModel);

            print('Existing user, data loaded from Firestore');
            return user;
          } else {
            UsersModel userModel = UsersModel(
              userId: user.uid,
              email: user.email ?? '',
              firstName: '',
              lastName: '',
              password: '',
              birthDay: null,
              isServeyCompleted: false,
              authMethod: 'google',
            );

            await _firestore
                .collection(userCollection)
                .doc(user.uid)
                .set(userModel.toJson());

            SharedPrefercenseService.saveUser(userModel);

            return user;
          }
        } catch (firestoreError) {
          print('Firestore error: $firestoreError');
          return user;
        }
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      print('Detailed error: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await auth.signOut();
  }
}
