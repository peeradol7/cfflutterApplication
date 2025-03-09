import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../service/facebook_auth_service.dart';

class FacebookLoginScreen extends StatelessWidget {
  final FacebookAuthService _facebookAuthService = FacebookAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Facebook Login")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            UserCredential? userCredential =
                await _facebookAuthService.signInWithFacebook();
            if (userCredential != null) {
              print("Logged in as: ${userCredential.user?.displayName}");
            } else {
              print("Login failed");
            }
          },
          child: Text("Login with Facebook"),
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: FacebookLoginScreen()));
}
