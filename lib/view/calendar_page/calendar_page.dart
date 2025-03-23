import 'package:fam_care/constatnt/app_colors.dart';
import 'package:fam_care/controller/calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    Key? key,
  }) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Future<void> _loadDataFuture;
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late List<String> _menstrualDates;
  final CalendarController controller = Get.put(CalendarController());
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('th', null).then((_) {
      _loadDataFuture = controller.loadMenstrualDate();
      _selectedDay = controller.selectedDay.value;
      _focusedDay = controller.focusedDay.value;
      _menstrualDates = controller.menstrualDates.toList();

      controller.selectedDay.listen((value) {
        if (mounted) setState(() => _selectedDay = value);
      });

      controller.focusedDay.listen((value) {
        if (mounted) setState(() => _focusedDay = value);
      });

      controller.menstrualDates.listen((value) {
        if (mounted) setState(() => _menstrualDates = value);
      });
    });
  }

  DateTime _calculateNextPeriod() {
    if (_menstrualDates.isEmpty) {
      return DateTime.now().add(Duration(days: 28));
    }

    List<DateTime> sortedDates = _menstrualDates
        .map((dateStr) => DateTime.parse(dateStr))
        .toList()
      ..sort((a, b) => a.compareTo(b));

    DateTime lastPeriod = sortedDates.last;

    return lastPeriod;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ปฏิทิน'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary.withOpacity(0.3), Colors.white],
          ),
        ),
        child: FutureBuilder<void>(
          future: _loadDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              );
            }

            DateTime nextPeriod = controller.nextMenstrualDate.value != null
                ? DateTime.parse(controller.nextMenstrualDate.value!)
                : _calculateNextPeriod();

            return Column(
              children: [
                // Next period info card
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, color: AppColors.primary),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'รอบเดือนต่อไปคาดว่าจะมาวันที่ ${DateFormat('d MMM yyyy', 'th').format(nextPeriod)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.color5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Calendar
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TableCalendar(
                          firstDay: DateTime.utc(2020, 10, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) =>
                              isSameDay(_selectedDay, day),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              controller.selectedDay.value = selectedDay;
                              controller.focusedDay.value = focusedDay;
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });

                            bool isPeriodDay = _menstrualDates.any((dateStr) =>
                                isSameDay(
                                    DateTime.parse(dateStr), selectedDay));

                            if (isPeriodDay) {
                              ScaffoldMessenger.of(context).showMaterialBanner(
                                MaterialBanner(
                                  content:
                                      Text('คุณบันทึกว่าวันนี้มีประจำเดือน'),
                                  backgroundColor:
                                      AppColors.primary.withOpacity(0.9),
                                  leading: Icon(Icons.water_drop,
                                      color: Colors.white),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentMaterialBanner(),
                                      child: Text('ปิด',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );

                              // Auto-dismiss after 3 seconds
                              Future.delayed(Duration(seconds: 3), () {
                                if (mounted) {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentMaterialBanner();
                                }
                              });
                            }
                          },
                          calendarFormat: CalendarFormat.month,
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: TextStyle(
                              color: AppColors.color5,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            leftChevronIcon: Icon(Icons.chevron_left,
                                color: AppColors.primary),
                            rightChevronIcon: Icon(Icons.chevron_right,
                                color: AppColors.primary),
                          ),
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(
                                color: AppColors.color5,
                                fontWeight: FontWeight.bold),
                            weekendStyle: TextStyle(
                                color: AppColors.color3,
                                fontWeight: FontWeight.bold),
                          ),
                          calendarStyle: CalendarStyle(
                            outsideDaysVisible: false,
                            todayDecoration: BoxDecoration(
                              color: AppColors.color8,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.primary, width: 2),
                            ),
                            selectedDecoration: BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                            weekendTextStyle:
                                TextStyle(color: AppColors.color3),
                            holidayTextStyle: TextStyle(color: Colors.white),
                            holidayDecoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          holidayPredicate: (day) {
                            for (String dateStr in _menstrualDates) {
                              DateTime menstrualDate = DateTime.parse(dateStr);
                              if (isSameDay(menstrualDate, day)) {
                                return true;
                              }
                            }
                            return false;
                          },
                          calendarBuilders: CalendarBuilders(
                            todayBuilder: (context, date, _) {
                              return Center(
                                child: Container(
                                  margin: const EdgeInsets.all(4.0),
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: AppColors.primary, width: 2),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${date.day}',
                                      style: TextStyle(color: AppColors.color5),
                                    ),
                                  ),
                                ),
                              );
                            },
                            holidayBuilder: (context, date, _) {
                              return Container(
                                margin: const EdgeInsets.all(4.0),
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${date.day}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        Icons.water_drop,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Legend
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    color: AppColors.colorButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildLegendItem(
                              AppColors.primary, 'วันมีประจำเดือน'),
                          _buildLegendItem(AppColors.color8, 'วันนี้',
                              borderColor: AppColors.primary),
                          _buildLegendItem(AppColors.secondary, 'วันที่เลือก'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, {Color? borderColor}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: borderColor != null
                ? Border.all(color: borderColor, width: 2)
                : null,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.color5),
        ),
      ],
    );
  }
}
