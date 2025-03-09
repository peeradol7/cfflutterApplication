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
      throw "เกิดข้อผิดพลาดที่ไม่คาดคิด กรุณาลองใหม่อีกครั้ง";
    }
    return null;
  }


  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? firebaseUser = userCredential.user;

      if (firebaseUser != null && !firebaseUser.emailVerified) {
        // สร้าง FirebaseAuthException เพื่อให้สามารถจัดการในส่วน _handleAuthError
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'กรุณายืนยันอีเมลก่อนเข้าสู่ระบบ'
        );
      }

      print("เข้าสู่ระบบสำเร็จ!");
      return firebaseUser;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      print("เกิดข้อผิดพลาด: $e");
      throw "เกิดข้อผิดพลาดที่ไม่คาดคิด กรุณาลองใหม่อีกครั้ง";
    }
    return null;
  }

  Future<bool> saveUserData(UsersModel user) async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return false;

    String uid = firebaseUser.uid;
    DateTime nextPeriodDate = user.period!.add(Duration(days: 28));

    await _firestore.collection(userCollection).doc(uid).set(
      {
        "userId": uid,
        "email": user.email,
        "firstName": user.firstName,
        "lastName": user.lastName,
        "age": _calculateAge(user.birthDay!),
        "birthDay": user.birthDay!.toIso8601String(),
        "period": user.period!.toIso8601String(),
        "nextPeriodDate": nextPeriodDate.toIso8601String(),
        "authMethod": 'email',
      },
    );

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
        errorMessage = "เกิดข้อผิดพลาด: ${e.message}";
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
}
