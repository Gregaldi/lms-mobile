import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

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
      'dueColor': 0xFFFF5252, // Red
      'color': 0xFFF8FBFF, // Very Light Blue
      'icon': 0xF6E8,
    },
    {
      'subject': 'IPS',
      'title': 'Lab Report - Motion',
      'due': 'Friday',
      'dueColor': 0xFF4CAF50, // Green
      'color': 0xFFF9FAFB, // Very Light Gray
      'icon': 0xF05E,
    },
  ];

  // Navigation to Attendance Page
  void goToAttendance() {
    // Show location dialog first (simulating the design requirement)
    Get.dialog(
      const LocationErrorDialog(),
      barrierDismissible: true,
    );
    // Get.toNamed(AppRoutes.markAttendance);
  }
}

// Simple Dialog Widget for Location Error

class LocationErrorDialog extends StatelessWidget {
  const LocationErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Text(
              'Please turn on your location',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2F5680),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            // Placeholder for the illustration
            Container(
              height: 150.h,
              width: 200.w,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_outlined,
                size: 80.sp,
                color: const Color(0xFF2F5680).withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: 30.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  Geolocator.openLocationSettings();
                },
                icon: const Icon(Icons.tune),
                label: const Text('Open Setting'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F5680),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
