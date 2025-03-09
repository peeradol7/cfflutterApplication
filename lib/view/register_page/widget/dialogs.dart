import 'package:flutter/material.dart';

void showSuccessDialog(BuildContext context, VoidCallback onConfirm) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text("สมัครสมาชิกสำเร็จ", style: TextStyle(color: Colors.green)),
        content: Text("กรุณาตรวจสอบอีเมลของคุณเพื่อยืนยันการสมัครสมาชิก"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: Text("ตกลง"),
          ),
        ],
      );
    },
  );
}

// ฟังก์ชันแสดง `showDialog` สำหรับแจ้งเตือน
void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("ผิดพลาด", style: TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("ตกลง"),
          ),
        ],
      );
    },
  );
}
