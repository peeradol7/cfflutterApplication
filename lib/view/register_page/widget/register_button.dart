import 'package:fam_care/constatnt/app_colors.dart';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const RegisterButton({
    Key? key,
    required this.isLoading,
    required this.onPressed, required Color color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
      ? Center(child: CircularProgressIndicator(color: Colors.pink.shade400))
      : ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
          ),
          child: Text(
            'สมัครสมาชิก',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
  }
}