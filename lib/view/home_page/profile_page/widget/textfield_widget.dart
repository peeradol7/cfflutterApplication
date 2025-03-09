import 'package:flutter/material.dart';

import '../../../../constatnt/app_colors.dart';

class TextfieldWidget {
  Widget buildTextField(
      TextEditingController controller, String label, String validationText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        filled: true,
        fillColor: AppColors.colorButton,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? validationText : null,
    );
  }

  Widget buildDateField(
      BuildContext context,
      String label,
      TextEditingController controller,
      DateTime? initialDate,
      Function(DateTime) onDateSelected) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        filled: true,
        fillColor: AppColors.colorButton,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: const Icon(Icons.calendar_today, color: AppColors.primary),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
    );
  }
}
