import 'package:flutter/material.dart';

class CustomButton {
  ButtonStyle btnStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.black, width: 2),
      ),
    );
  }

  Widget btnSignUp({
    required void Function()? onPressed, // Nullable function
    required String label,
    String? iconPath,
    double iconWidth = 30,
    double iconHeight = 30,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed, // Now works with nullable function
      icon: Image.asset(
        iconPath!,
        width: iconWidth,
        height: iconHeight,
        fit: BoxFit.contain,
      ),
      label: Text(
        label,
        style: const TextStyle(color: Colors.black, fontSize: 15),
      ),
      style: btnStyle(),
    );
  }
}
