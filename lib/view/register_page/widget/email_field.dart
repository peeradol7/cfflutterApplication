import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'อีเมล',
            hintText: 'กรุณากรอกอีเมลที่ใช้งานได้จริง',
            border: InputBorder.none,
            icon: Icon(Icons.email, color: Colors.pink.shade300),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณากรอกอีเมล';
            }
            // ตรวจสอบรูปแบบอีเมล
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) {
              return 'กรุณากรอกอีเมลที่ถูกต้อง';
            }
            return null;
          },
        ),
      ),
    );
  }
}