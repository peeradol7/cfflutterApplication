import 'package:fam_care/service/shared_prefercense_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarController extends GetxController {
  final SharedPrefercenseService _prefsService = SharedPrefercenseService();
  var currentMenstrualDate = Rx<String?>(null);
  var nextMenstrualDate = Rx<String?>(null);
  Rx<DateTime> selectedDay = DateTime.now().obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;
  RxList<String> menstrualDates = <String>[].obs;
  RxBool isEditMode = false.obs;

  Future<void> loadMenstrualDate() async {
    menstrualDates.assignAll(await _prefsService.loadMenstrualDates());
  }

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

  Future<void> toggleMenstrualDate(DateTime day) async {
    if (!isEditMode.value) return;

    String dateStr = day.toIso8601String().split('T').first;

    menstrualDates.contains(dateStr)
        ? menstrualDates.remove(dateStr)
        : menstrualDates.add(dateStr);

    menstrualDates.sort();
    await _prefsService.saveMenstrualDates(menstrualDates);
  }

  Future<void> clearMenstrualDates() async {
    menstrualDates.clear();
    await _prefsService.removeKey(SharedPrefercenseService.dateKey);
  }

  List<DateTime> calculateNextPeriods(List<String> menstrualDates) {
    if (menstrualDates.isEmpty) return [];

    List<DateTime> sortedDates = menstrualDates
        .map((dateStr) => DateTime.parse(dateStr))
        .toList()
      ..sort();

    List<DateTime> allPredictedPeriods = [];

    for (DateTime originalDate in sortedDates) {
      for (int i = 1; i <= 12; i++) {
        DateTime nextDate = originalDate.add(Duration(days: 28 * i));
        allPredictedPeriods.add(nextDate);
      }
    }

    allPredictedPeriods.sort();

    return allPredictedPeriods;
  }

  void updateMenstrualDates(List<String> dates) {
    menstrualDates.value = dates;

    if (dates.isNotEmpty) {
      DateTime lastDate = DateTime.parse(dates[dates.length - 1]);
      currentMenstrualDate.value = lastDate.toIso8601String();
      nextMenstrualDate.value =
          lastDate.add(Duration(days: 28)).toIso8601String();
    }

    _saveMenstrualDatesToPrefs(dates);
  }

  Future<void> _saveMenstrualDatesToPrefs(List<String> dates) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(SharedPrefercenseService.dateKey, dates);
    } catch (e) {
      print('Error saving menstrual dates: $e');
    }
  }
}
