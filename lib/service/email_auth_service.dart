import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_care/model/users_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final String userCollection = 'users';

  Future<User?> signUpWithEmail(UsersModel user) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

      User? firebaseUser = userCredential.user;

      await firebaseUser?.sendEmailVerification();

      if (firebaseUser != null) {
        bool success = await saveUserData(user);
        if (success) {
          print("ข้อมูลผู้ใช้ถูกบันทึกลง Firestore เรียบร้อยแล้ว");
        }
      }

      return firebaseUser;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      print("เกิดข้อผิดพลาด: $e");
    }
    return null;
  }

  Future<User?> signIn(String email, String password) async {
    print('AuthService: Attempting to sign in with email: $email');
    try {
      // Attempt sign in
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        if (user.emailVerified) {
          print(
              'AuthService: Sign in successful for verified user: ${user.uid}');
          return user;
        } else {
          print('AuthService: User email is not verified');
          throw FirebaseAuthException(
            code: 'email-not-verified',
            message: 'กรุณายืนยันอีเมลก่อนเข้าสู่ระบบ',
          );
        }
      } else {
        print('AuthService: No user returned after authentication');
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print(
          'AuthService: Firebase Auth Error - Code: ${e.code}, Message: ${e.message}');
      rethrow;
    } catch (e) {
      print('AuthService: Unknown Error during sign in: $e');
      rethrow;
    }
  }

  Future<bool> saveUserData(UsersModel user) async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return false;

    String uid = firebaseUser.uid;

    await _firestore.collection(userCollection).doc(uid).set(
      {
        "userId": uid,
        "email": user.email,
        "firstName": user.firstName,
        "lastName": user.lastName,
        "age": _calculateAge(user.birthDay!),
        "birthDay": user.birthDay!.toIso8601String(),
        "authMethod": 'email',
        "isServeyCompleted": false,
      },
    );
    print(uid);
    print("บันทึกข้อมูลผู้ใช้ลง Firestore เรียบร้อยแล้ว");
    print("อีเมล: ${user.email}");
    print("ชื่อ: ${user.firstName}");
    print("นามสกุล: ${user.lastName}");
    print("วันเกิด: ${user.birthDay}");
    print("อายุ: ${_calculateAge(user.birthDay!)} ปี");
    print("วิธีการลงทะเบียน: email");
    print("บันทึกข้อมูลสำเร็จ!");
    return true;
  }

  void _handleAuthError(FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case 'email-not-verified':
        errorMessage = "กรุณายืนยันอีเมลก่อนเข้าสู่ระบบ";
        break;
      case 'email-already-in-use':
        errorMessage = "อีเมลนี้มีผู้ใช้งานแล้ว";
        break;
      case 'weak-password':
        errorMessage = "รหัสผ่านไม่ปลอดภัย";
        break;
      case 'invalid-email':
        errorMessage = "รูปแบบอีเมลไม่ถูกต้อง";
        break;
      case 'user-not-found':
        errorMessage = "ไม่พบผู้ใช้งานนี้";
        break;
      case 'wrong-password':
        errorMessage = "รหัสผ่านไม่ถูกต้อง";
        break;
      default:
        errorMessage = "";
    }
    print(errorMessage);
    throw errorMessage;
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendEmailVerification() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }
}
