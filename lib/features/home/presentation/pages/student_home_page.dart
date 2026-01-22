import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../attendance/presentation/pages/attendance_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../controllers/home_controller.dart';

class StudentHomePage extends GetView<HomeController> {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access AuthController to get user info
    final authController = Get.find<AuthController>();
    final user = authController.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF2F5680), // Dark Blue Background
      body: Obx(() {
        switch (controller.selectedIndex.value) {
          case 0:
            return _buildHomeContent(user);
          case 1:
            return const AttendancePage();
          case 2:
            return const Center(
                child: Text('Homework Page',
                    style: TextStyle(color: Colors.white)));
          case 3:
            return const ProfilePage();
          default:
            return _buildHomeContent(user);
        }
      }),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHomeContent(User? user) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Header Section
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 20.h),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24.r,
                  backgroundImage: user?.profileImage != null
                      ? NetworkImage(user!.profileImage!)
                      : null,
                  backgroundColor: Colors.orange, // Orange bg for avatar
                  child: user?.profileImage == null
                      ? Image.asset('assets/images/onboarding1.png',
                          width: 40.w) // Use asset if available or just icon
                      // ? Icon(Icons.person, size: 30.sp, color: Colors.white)
                      : null,
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'Ahmad Rizki', // Placeholder name
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'X MIPA B', // Placeholder class
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Stack(
                  children: [
                    Icon(Icons.notifications, color: Colors.white, size: 28.sp),
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: Stack(
              children: [
                // Scrollable Content
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Attendance Card (Floating)
                          _buildAttendanceCard(),
                          SizedBox(height: 30.h),

                          // History Today
                          _buildHistoryToday(),
                          SizedBox(height: 30.h),

                          // Homework Section
                          _buildHomeworkSection(),
                          SizedBox(height: 80.h), // Bottom padding
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard() {
    return Column(
      children: [
        // Map Widget
        Container(
          height: 180.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F8),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Obx(() {
              final position = controller.currentPosition.value ??
                  const LatLng(-6.2088, 106.8456);
              return FlutterMap(
                key: ValueKey(position),
                options: MapOptions(
                  initialCenter: position,
                  initialZoom: 15.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.lms_mobile',
                  ),
                  if (controller.currentPosition.value != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: position,
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40.sp,
                          ),
                        ),
                      ],
                    ),
                ],
              );
            }),
          ),
        ),
        SizedBox(height: 16.h),

        // Address
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 24.sp, color: Colors.black),
            SizedBox(width: 12.w),
            Expanded(
              child: Obx(() => Text(
                    controller.currentAddress.value,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF2F5680), // Dark blue text
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
            ),
            SizedBox(width: 8.w),
            InkWell(
              onTap: controller.requestLocation,
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: Obx(() => controller.isLoadingLocation.value
                    ? SizedBox(
                        width: 20.sp,
                        height: 20.sp,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black87,
                        ),
                      )
                    : Icon(Icons.refresh, size: 20.sp, color: Colors.black87)),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),

        // Submit Button
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton.icon(
            onPressed: controller.goToAttendance,
            icon: Icon(Icons.calendar_month, size: 11.sp),
            label: Text(
              'Submit Attendance',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E88E5), // Brighter Blue
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryToday() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FF), // Very Light Blue Bg
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'History Today',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 20.h),
          _buildHistoryRow(
            icon: Icons.check,
            iconBg: const Color(0xFF22C55E), // Green
            label: 'Check-In',
            time: '--:--:--',
          ),
          SizedBox(height: 16.h),
          Divider(color: Colors.blueGrey.withValues(alpha: 0.1), height: 1),
          SizedBox(height: 16.h),
          _buildHistoryRow(
            icon: Icons.remove,
            iconBg: const Color(0xFFEF4444), // Red
            label: 'Check-Out',
            time: '--:--:--',
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryRow({
    required IconData icon,
    required Color iconBg,
    required String label,
    required String time,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 16.sp),
        ),
        SizedBox(width: 16.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF374151),
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          time,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildHomeworkSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "This Week's Homework",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See All',
                style: TextStyle(
                  color: const Color(0xFF3B82F6),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 130.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.homeworkList.length,
            separatorBuilder: (context, index) => SizedBox(width: 16.w),
            itemBuilder: (context, index) {
              final homework = controller.homeworkList[index];
              return Container(
                width: 180.w,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Color(homework['color']),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Icon(Icons.menu_book, size: 20.sp, color: Colors.black87), // Placeholder icon
                        Text(
                          homework['subject'],
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1F2937),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      homework['title'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF6B7280),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      'Due: ${homework['due']}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(homework['dueColor'] ?? 0xFFEF4444),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTabIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2F5680),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle:
              TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 12.sp),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_time),
              activeIcon: Icon(Icons.access_time_filled),
              label: 'Attendance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              activeIcon: Icon(Icons.description),
              label: 'Homework',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
