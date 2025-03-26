import 'package:fam_care/constatnt/app_colors.dart';
import 'package:fam_care/controller/calendar_controller.dart';
import 'package:fam_care/service/shared_prefercense_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    Key? key,
  }) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarController _controller = Get.put(CalendarController());
  final prefs = SharedPrefercenseService();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadMenstrualDate();
    });

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              _controller.isEditMode.value ? 'แก้ไขวันประจำเดือน' : 'ปฏิทิน',
            )),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                    _controller.isEditMode.value ? Icons.check : Icons.edit),
                onPressed: () {
                  _controller.toggleEditMode();
                },
              )),
          Obx(() {
            if (_controller.isEditMode.value) {
              return IconButton(
                icon: Icon(Icons.clear_all),
                onPressed: () => _controller.clearMenstrualDates(),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, Colors.white],
          ),
        ),
        child: Obx(() {
          List<DateTime> nextPeriods =
              _controller.calculateNextPeriods(_controller.menstrualDates);

          return Column(
            children: [
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
                        focusedDay: _controller.focusedDay.value,
                        selectedDayPredicate: (day) =>
                            isSameDay(_controller.selectedDay.value, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          _controller.selectedDay.value = selectedDay;
                          _controller.focusedDay.value = focusedDay;

                          if (_controller.isEditMode.value) {
                            _controller.toggleMenstrualDate(selectedDay);
                          }
                        },
                        calendarFormat: CalendarFormat.month,
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          leftChevronIcon: Icon(Icons.chevron_left,
                              color: AppColors.primary),
                          rightChevronIcon: Icon(Icons.chevron_right,
                              color: AppColors.primary),
                        ),
                        calendarStyle: CalendarStyle(
                          outsideDaysVisible: false,
                          todayDecoration: BoxDecoration(
                            color: _controller.isEditMode.value
                                ? AppColors.secondary
                                : AppColors.color5,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.background,
                              width: _controller.isEditMode.value ? 1 : 2,
                            ),
                          ),
                          selectedDecoration: BoxDecoration(
                            color: _controller.isEditMode.value
                                ? AppColors.primary
                                : AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                          holidayTextStyle: TextStyle(
                            color: Colors.black, // Default text color
                          ),
                        ),
                        holidayPredicate: (day) {
                          bool isMenstrualDay = _controller.menstrualDates.any(
                              (dateStr) =>
                                  isSameDay(DateTime.parse(dateStr), day));
                          bool isNextPeriodDay = nextPeriods
                              .any((period) => isSameDay(period, day));

                          if (isMenstrualDay) {
                            return true;
                          }
                          if (isNextPeriodDay) {
                            return true;
                          }
                          return false;
                        },
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, day, events) {
                            bool isMenstrualDay = _controller.menstrualDates
                                .any((dateStr) =>
                                    isSameDay(DateTime.parse(dateStr), day));
                            bool isNextPeriodDay = nextPeriods
                                .any((period) => isSameDay(period, day));

                            if (isMenstrualDay) {
                              return Container(
                                width:
                                    MediaQuery.of(context).size.height * 0.055,
                                decoration: BoxDecoration(
                                  color: Colors.pinkAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    day.day.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }

                            if (isNextPeriodDay) {
                              return Container(
                                width:
                                    MediaQuery.of(context).size.height * 0.055,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.pinkAccent,
                                    width: 2.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    day.day.toString(),
                                    style: TextStyle(color: Colors.pinkAccent),
                                  ),
                                ),
                              );
                            }

                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
                        _buildLegendItem(Colors.pinkAccent, 'วันมีประจำเดือน'),
                        _buildLegendItem(
                          Colors.white,
                          'วันที่คาดการณ์วันเป็นประจำเดือน',
                          borderColor: Colors.pinkAccent,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
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
                ? Border.all(
                    color: borderColor,
                    width: 2,
                  )
                : null,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.black),
        ),
      ],
    );
  }
}
