import 'package:flutter/material.dart';

class CustomButton {
  ButtonStyle btnStyle({bool isEnabled = true}) {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isEnabled ? Colors.black : Colors.grey,
          width: 2,
        ),
      ),
    );
  }

  Widget btnSignUp({
    required void Function()? onPressed,
    required String label,
    String? iconPath,
    double iconWidth = 30,
    double iconHeight = 30,
    bool isEnabled = true,
  }) {
    return ElevatedButton.icon(
      onPressed: isEnabled ? onPressed : null,
      icon: iconPath != null
          ? Image.asset(
              iconPath,
              width: iconWidth,
              height: iconHeight,
              fit: BoxFit.contain,
            )
          : const SizedBox.shrink(),
      label: Text(
        label,
        style: TextStyle(
          color: isEnabled ? Colors.black : Colors.grey,
          fontSize: 15,
        ),
      ),
      style: btnStyle(isEnabled: isEnabled),
    );
  }
}
