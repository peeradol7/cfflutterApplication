import 'dart:convert';

import 'package:fam_care/service/shared_prefercense_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/users_model.dart';

class CalendarController extends GetxController {
  var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;
  var currentMenstrualDate = Rx<String?>(null);
  var nextMenstrualDate = Rx<String?>(null);
  final RxList<String> menstrualDates = <String>[].obs;
  @override
  void onInit() {
    super.onInit();
    loadMenstrualDate();
  }

  Future<void> loadMenstrualDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(SharedPrefercenseService.userKey!);

      if (userJson != null) {
        UsersModel user = UsersModel.fromJson(jsonDecode(userJson));

        if (user.period != null) {
          DateTime firstPeriodDate = user.period!;
          DateTime currentDate = DateTime.now();

          List<String> allMenstrualDates = [];

          DateTime tempDate = firstPeriodDate;
          while (!tempDate.isAfter(currentDate)) {
            allMenstrualDates.add(tempDate.toIso8601String());
            tempDate = tempDate.add(Duration(days: 28));
          }

          allMenstrualDates.add(tempDate.toIso8601String());

          if (allMenstrualDates.isNotEmpty) {
            DateTime mostRecentDate =
                DateTime.parse(allMenstrualDates[allMenstrualDates.length - 2]);
            currentMenstrualDate.value = mostRecentDate.toIso8601String();

            nextMenstrualDate.value = tempDate.toIso8601String();

            menstrualDates.value = allMenstrualDates;
          }
        }
      }
    } catch (e) {
      print('Error loading menstrual dates: $e');
    }

    return;
  }
}
