import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
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
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundImage: user?.profileImage != null
                        ? NetworkImage(user!.profileImage!)
                        : null,
                    backgroundColor: Colors.white,
                    child: user?.profileImage == null
                        ? Icon(Icons.person,
                            size: 30.sp, color: const Color(0xFF2F5680))
                        : null,
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Student',
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
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.notifications,
                        color: Colors.white, size: 24.sp),
                  ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA), // Light Gray/White Background
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                ),
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Attendance Card
                      _buildAttendanceCard(),
                      SizedBox(height: 20.h),

                      // History Today
                      _buildHistoryToday(),
                      SizedBox(height: 20.h),

                      // Homework Section
                      _buildHomeworkSection(),
                      SizedBox(
                          height: 80.h), // Bottom padding for navigation bar
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAttendanceCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Map Placeholder
          Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.r),
              // image: const DecorationImage(
              //   image: AssetImage('assets/images/map_placeholder.png'), // Placeholder
              //   fit: BoxFit.cover,
              // ),
            ),
            child: Center(
              child: Icon(Icons.map, size: 40.sp, color: Colors.grey),
            ),
          ),
          SizedBox(height: 12.h),

          // Address
          Row(
            children: [
              Icon(Icons.location_on, size: 16.sp, color: Colors.black87),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Jl. Raya Bekasi No.13910, RT.7/RW.1, Cakung Bar., Kec. Cakung',
                  style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.refresh, size: 16.sp, color: Colors.black54),
            ],
          ),
          SizedBox(height: 16.h),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: ElevatedButton.icon(
              onPressed: controller.goToAttendance,
              icon: Icon(Icons.calendar_today, size: 18.sp),
              label: Text(
                'Submit Attendance',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F5680),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.r),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryToday() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), // Light Blue Bg
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'History Today',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),
          _buildHistoryRow(
            icon: Icons.check_circle,
            color: Colors.green,
            label: 'Check-In',
            time: '--:--:--',
          ),
          SizedBox(height: 12.h),
          _buildHistoryRow(
            icon: Icons.remove_circle,
            color: Colors.red,
            label: 'Check-Out',
            time: '--:--:--',
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryRow({
    required IconData icon,
    required Color color,
    required String label,
    required String time,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24.sp),
        SizedBox(width: 12.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          time,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
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
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See All',
                style: TextStyle(
                  color: const Color(0xFF2F5680),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 120.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.homeworkList.length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final homework = controller.homeworkList[index];
              return Container(
                width: 160.w,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Color(homework['color']),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.menu_book,
                            size: 20.sp,
                            color: Colors.black87), // Placeholder icon
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            homework['subject'],
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      homework['title'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      'Due: ${homework['due']}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.red,
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
              color: Colors.black.withOpacity(0.05),
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
