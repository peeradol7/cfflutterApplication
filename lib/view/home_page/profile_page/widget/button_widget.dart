import 'package:flutter/material.dart';

class ButtonWidget {  
  Widget buildMenuItem(String title, VoidCallback onPressed) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onPressed,
    );
  }
}
