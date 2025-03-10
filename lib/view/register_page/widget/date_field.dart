import 'package:fam_care/constatnt/app_colors.dart';
import 'package:flutter/material.dart';

class DateFields extends StatelessWidget {
  final TextEditingController birthDateController;
  final TextEditingController periodDateController;
  final Function(DateTime) onBirthDateChanged;
  final Function(DateTime) onPeriodDateChanged;

  const DateFields({
    Key? key,
    required this.birthDateController,
    required this.periodDateController,
    required this.onBirthDateChanged,
    required this.onPeriodDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDateField(
          context: context,
          controller: birthDateController,
          label: 'วันเกิด',
          hint: 'เลือกวันเกิด',
          icon: Icons.cake,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          onDateSelected: onBirthDateChanged,
        ),
        // SizedBox(height: 15),
        // _buildDateField(
        //   context: context,
        //   controller: periodDateController,
        //   label: 'วันเป็นประจำเดือน',
        //   hint: 'เลือกวันเป็นประจำเดือนครั้งล่าสุด',
        //   icon: Icons.calendar_today,
        //   firstDate: DateTime(DateTime.now().year - 1),
        //   lastDate: DateTime.now(),
        //   onDateSelected: onPeriodDateChanged,
        // ),
      ],
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required DateTime firstDate,
    required DateTime lastDate,
    required Function(DateTime) onDateSelected,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: InputBorder.none,
            icon: Icon(icon, color: Colors.pink.shade300),
          ),
          readOnly: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณาเลือก$label';
            }
            return null;
          },
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: firstDate,
              lastDate: lastDate,
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.secondary,
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              controller.text =
                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
              onDateSelected(pickedDate);
            }
          },
        ),
      ),
    );
  }
}
