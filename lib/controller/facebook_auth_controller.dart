import 'package:fam_care/service/facebook_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../service/shared_prefercense_service.dart';

class FacebookAuthController extends GetxController {
  final FacebookAuthService service = FacebookAuthService();
  RxBool isLoading = false.obs;
  RxBool isUserExist = false.obs;
  var user = Rx<User?>(null);

  Future<UserCredential?> signInWithFacebook() async {
    try {
      final userCredential = await service.signInWithFacebook();

      if (userCredential != null) {
        user.value = userCredential.user;
        return userCredential;
      } else {
        return null;
      }
    } catch (e) {
      print("Error during Facebook login: $e");
      return null;
    }
  }

  bool get isLoggedIn => user.value != null;

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    user.value = null;
    SharedPrefercenseService.removeUser();
  }
}
