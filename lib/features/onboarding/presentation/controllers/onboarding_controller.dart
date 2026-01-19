import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/routes/app_routes.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Discover Learning",
      "text":
          "Access thousands of courses and learn at your own pace, anytime, anywhere",
      "image": "assets/images/onboarding1.png" // Placeholder
    },
    {
      "title": "Track Progress",
      "text":
          "Keep track of your assignments, grades, and attendance easily in one place",
      "image": "assets/images/onboarding2.png" // Placeholder
    },
    {
      "title": "Stay Connected",
      "text":
          "Connect with teachers and classmates for a better collaborative learning experience",
      "image": "assets/images/onboarding3.png" // Placeholder
    },
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void skip() {
    _completeOnboarding();
  }

  void next() {
    if (currentPage.value < onboardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = Get.find<SharedPreferences>();
    await prefs.setBool('onboarding_complete', true);
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
