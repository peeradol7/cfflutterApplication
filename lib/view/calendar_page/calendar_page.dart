import 'package:fam_care/constatnt/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../controller/calendar_controller.dart';

class CalendarPage extends StatelessWidget {
  final CalendarController controller = Get.find<CalendarController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ปฏิทิน'),
      ),
      body: Center(
        child: FutureBuilder<void>(
          future: controller.loadMenstrualDate(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return Obx(() {
              return TableCalendar(
                firstDay: DateTime.utc(2020, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: controller.focusedDay.value,
                selectedDayPredicate: (day) =>
                    isSameDay(controller.selectedDay.value, day),
                onDaySelected: (selectedDay, focusedDay) {
                  controller.selectedDay.value = selectedDay;
                  controller.focusedDay.value = focusedDay;
                },
                calendarFormat: CalendarFormat.month,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                // Add this property to hide days from previous/next months
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                ),
                holidayPredicate: (day) {
                  for (String dateStr in controller.menstrualDates) {
                    DateTime menstrualDate = DateTime.parse(dateStr);
                    if (isSameDay(menstrualDate, day)) {
                      return true;
                    }
                  }
                  return false;
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    for (String dateStr in controller.menstrualDates) {
                      DateTime menstrualDate = DateTime.parse(dateStr);
                      if (isSameDay(menstrualDate, date)) {
                        return Positioned(
                          right: 1,
                          bottom: 1,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }
                    }
                    return SizedBox.shrink();
                  },
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
