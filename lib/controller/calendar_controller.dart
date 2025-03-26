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

    print('Debug: Sorted Dates = $sortedDates');

    if (sortedDates.isEmpty) return [];

    List<int> periodDays = sortedDates.map((date) => date.day).toList();
    print('Debug: Period Days = $periodDays');

    DateTime lastPeriod = sortedDates.last;
    print('Debug: Last Period = $lastPeriod');

    List<DateTime> nextPeriodDates = periodDays.map((originalDay) {
      // Find the original date with this day
      DateTime originalDate =
          sortedDates.firstWhere((date) => date.day == originalDay);

      // Calculate the next period date by adding 28 days to the original date
      DateTime calculatedDate = originalDate.add(Duration(days: 28));

      print(
          'Debug: Original Day = $originalDay, Original Date = $originalDate, Calculated Date = $calculatedDate');

      return calculatedDate;
    }).toList();

    print('menstrualDates *** $menstrualDates');
    print('nextPeriodDates ** $nextPeriodDates');

    return nextPeriodDates;
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
