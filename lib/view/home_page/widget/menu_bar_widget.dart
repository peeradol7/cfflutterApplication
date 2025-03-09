import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/menu_bar_controller.dart';
import 'build_navigator_bar.dart';

class MenuBarWidget extends StatelessWidget {
  const MenuBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final MenuBarController controller = Get.find<MenuBarController>();
    final BuildNavigationBar navigationBar = BuildNavigationBar();

    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: (index) => controller.changePage(context, index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          navigationBar.buildNavItem(
            Icons.home,
            'Home',
            0,
            controller,
          ),
          navigationBar.buildNavItem(Icons.person, 'Profile', 1, controller),
        ],
      ),
    );
  }
}
