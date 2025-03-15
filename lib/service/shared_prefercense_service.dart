import 'dart:convert';

import 'package:fam_care/model/users_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefercenseService {
  static const String? userKey = "user_data";

  Future<void> instance() async {
    SharedPreferences.getInstance();
  }

  static Future<void> saveUser(UsersModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(userKey!, userJson);
    await prefs.setString("userId", user.userId!);

    print('User Saved **** $userKey');
  }

  static Future<UsersModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(userKey!);

    if (userJson == null) return null;

    print("userJson: $userJson");

    return UsersModel.fromJson(jsonDecode(userJson));
  }

  static Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey!);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(userKey!);

    if (userJson == null) return null;

    final user = UsersModel.fromJson(jsonDecode(userJson));
    return user.userId;
  }
}
