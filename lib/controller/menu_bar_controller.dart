import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuBarController extends GetxController {
  var selectedIndex = 0.obs;

  final pageController = PageController();

  void changePage(BuildContext context, int index) {
    selectedIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
