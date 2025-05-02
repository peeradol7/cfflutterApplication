import 'package:fam_care/model/users_model.dart';
import 'package:fam_care/service/shared_prefercense_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service/user_service.dart';

class UserController extends GetxController {
  final UserService _userService = UserService();
  final SharedPrefercenseService prefs = SharedPrefercenseService();
  var userData = Rxn<UsersModel>();
  Rx<UsersModel?> editUserData = Rx<UsersModel?>(null);

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final birthDateController = TextEditingController();
  final periodDateController = TextEditingController();
  final birthDate = Rx<DateTime?>(null);
  final periodDate = Rx<DateTime?>(null);
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  RxBool isSaving = false.obs;
  RxBool isApprove = false.obs;
  RxBool isSurveyCompleted = false.obs;

  Future<void> loadUserFromPrefs() async {
    isLoading.value = true;
    final user = await prefs.getUser();
    if (user != null) {
      userData.value = user;
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    ever(birthDate, (_) {
      if (birthDate.value != null) {
        birthDateController.text =
            "${birthDate.value?.toLocal()}".split(' ')[0];
      }
    });

    ever(periodDate, (_) {
      if (periodDate.value != null) {
        periodDateController.text =
            "${periodDate.value?.toLocal()}".split(' ')[0];
      }
    });
  }

  Future<void> fetchUserDataById(String userId) async {
    print('Controller: Fetching user data for ID: $userId');
    if (userId.isEmpty) {
      print('Controller: UserID is empty, aborting fetch');
      isLoading.value = false;
      return;
    }

    try {
      userData.value = await _userService.fetchUserDataByUserId(userId);

      if (userData.value != null) {
        print('Controller: User data fetched successfully');
        SharedPrefercenseService.saveUser(userData.value!);

        firstNameController.text = userData.value!.firstName ?? '';
        lastNameController.text = userData.value!.lastName ?? '';
        birthDate.value = userData.value?.birthDay;
        isSurveyCompleted.value = userData.value?.isServeyCompleted ?? false;
      } else {
        print('Controller: No user data found in Firestore');
      }
    } catch (e) {
      print('Controller: Error fetching user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveUserData(String userId, String authMethod) async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    isSaving.value = true;
    try {
      final Map<String, dynamic> updateData = {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'birthDay': birthDate.value?.toIso8601String(),
        'period': periodDate.value?.toIso8601String(),
      };

      final success = await _userService.updateUser(userId, updateData);

      if (success) {
        final updatedUser = UsersModel(
            userId: userId,
            email: userData.value?.email,
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            birthDay: birthDate.value,
            authMethod: authMethod,
            isServeyCompleted: false);

        userData.value = updatedUser;
        SharedPrefercenseService.saveUser(updatedUser);
      }

      return success;
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    } finally {
      isSaving.value = false;
      update();
    }
  }

  void updateBirthDate(DateTime date) {
    birthDate.value = date;
    birthDateController.text = "${date.toLocal()}".split(' ')[0];
    update(); // เพิ่มบรรทัดนี้
  }

  void updatePeriodDate(DateTime date) {
    periodDate.value = date;
    periodDateController.text = "${date.toLocal()}".split(' ')[0];
    update();
  }

  Future<void> signOut(BuildContext context) async {
    try {
      // SharedPrefercenseService.removeUser();
      await FirebaseAuth.instance.signOut();
      userData.value = null;
    } catch (e) {}
  }

  int calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  DateTime calculateNextPeriod(DateTime lastPeriod, {int cycleDays = 28}) {
    return lastPeriod.add(Duration(days: cycleDays));
  }

  Future<bool> updateIsSurveyCompleted(String userId) async {
    try {
      await _userService.updateIsSurveyCompleted(userId);
      return true;
    } catch (e) {
      print('Error updating isSurveyCompleted: $e');
      return false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    birthDateController.dispose();
    periodDateController.dispose();
    super.onClose();
  }
}
