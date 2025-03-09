import 'package:flutter/material.dart';

import '../../../controller/menu_bar_controller.dart';

class BuildNavigationBar {
  BottomNavigationBarItem buildNavItem(
    IconData icon,
    String label,
    int index,
    MenuBarController controller,
  ) {
    return BottomNavigationBarItem(
      icon: GestureDetector(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          child: Icon(
            icon,
            size: controller.selectedIndex.value == index ? 30 : 24,
          ),
        ),
      ),
      label: label,
    );
  }
}
