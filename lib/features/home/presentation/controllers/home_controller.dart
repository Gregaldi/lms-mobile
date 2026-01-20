import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class HomeController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        // Navigate to Attendance History or stay if it's a tab
        // For now, let's assume it's just a tab change in the bottom nav
        break;
      case 2:
        // Navigate to Homework/Assignments
        break;
      case 3:
        // Navigate to Profile
        break;
    }
  }

  // Dummy data for homework
  final List<Map<String, dynamic>> homeworkList = [
    {
      'subject': 'Matematika',
      'title': 'Algebra Problems Ch.5',
      'due': 'Tomorrow',
      'color': 0xFFE3F2FD, // Light Blue
      'icon': 0xF6E8, // math icon placeholder (using standard icon later)
    },
    {
      'subject': 'IPS',
      'title': 'Lab Report - Motion',
      'due': 'Friday',
      'color': 0xFFF3E5F5, // Light Purple
      'icon': 0xF05E, // science icon placeholder
    },
  ];
  
  // Navigation to Attendance Page
  void goToAttendance() {
    Get.toNamed(AppRoutes.markAttendance);
  }
}
