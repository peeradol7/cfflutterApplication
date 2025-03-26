import 'dart:convert';

import 'package:fam_care/model/users_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefercenseService {
  static const String userKey = "user_data";
  static const String dateKey = 'menstrualdates';

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

  Future<UsersModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(userKey);

    if (userJson == null) {
      print("User data not found in SharedPreferences.");
      return null;
    }

    try {
      final userMap = jsonDecode(userJson);
      final user = UsersModel.fromJson(userMap);
      if (user.userId == null || user.userId!.isEmpty) {
        print("User ID is null or empty.");
        return null;
      }

      print("userJson: $userJson");
      return user;
    } catch (e) {
      print("Error decoding userJson: $e");
      return null;
    }
  }

  Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
  }

  Future<void> removeKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<List<String>> loadMenstrualDates() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(dateKey) ?? [];
  }

  Future<void> saveMenstrualDates(List<String> date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(dateKey, date);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(userKey!);

    if (userJson == null) return null;

    final user = UsersModel.fromJson(jsonDecode(userJson));
    return user.userId;
  }
}
