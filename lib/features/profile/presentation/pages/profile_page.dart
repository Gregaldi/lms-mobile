import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final user = authController.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF), // Light background for body
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 60.h, bottom: 30.h),
              decoration: BoxDecoration(
                color: const Color(0xFF2F5680),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30.r),
                ),
              ),
              child: Column(
                children: [
                  // Profile Image with Camera Icon
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 50.r,
                          backgroundImage: user?.profileImage != null
                              ? NetworkImage(user!.profileImage!)
                              : null,
                          backgroundColor: Colors.grey[300],
                          child: user?.profileImage == null
                              ? Image.asset('assets/images/onboarding1.png',
                                  width: 80.w)
                              : null,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: const BoxDecoration(
                            color: Color(0xFF3B82F6), // Blue camera button
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // Name
                  Text(
                    user?.name ?? 'Ahmad Rizki',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Class
                  Text(
                    'X MIPA II', // Placeholder class
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Email
                  Text(
                    user?.email ?? 'ahmad.r@gmail.com',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  // Account Section
                  _buildSectionHeader('Account'),
                  SizedBox(height: 12.h),
                  Container(
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
                    child: Column(
                      children: [
                        _buildSettingsItem(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          subtitle: 'Update your personal information',
                          onTap: () {},
                        ),
                        Divider(height: 1, color: Colors.grey[100]),
                        _buildSettingsItem(
                          icon: Icons.lock_outline,
                          title: 'Change Password',
                          subtitle: 'Update your security credentials',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Preferences Section
                  _buildSectionHeader('Preferences'),
                  SizedBox(height: 12.h),
                  Container(
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
                    child: Column(
                      children: [
                        _buildSettingsItem(
                          icon: Icons.notifications_none_outlined,
                          title: 'Notifications',
                          subtitle: 'Enabled',
                          isSwitch: true,
                          switchValue: true,
                          onChanged: (val) {},
                        ),
                        Divider(height: 1, color: Colors.grey[100]),
                        _buildSettingsItem(
                          icon: Icons.language,
                          title: 'Language',
                          subtitle: 'English (US)',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Support Section
                  _buildSectionHeader('Support'),
                  SizedBox(height: 12.h),
                  Container(
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
                    child: Column(
                      children: [
                        _buildSettingsItem(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          subtitle: 'Get assistance and FAQs',
                          onTap: () {},
                        ),
                        Divider(height: 1, color: Colors.grey[100]),
                        _buildSettingsItem(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          subtitle: 'Review our privacy terms',
                          onTap: () {},
                        ),
                        Divider(height: 1, color: Colors.grey[100]),
                        _buildSettingsItem(
                          icon: Icons.description_outlined,
                          title: 'Terms & Conditions',
                          subtitle: 'Read our terms of service',
                          onTap: () {},
                        ),
                        Divider(height: 1, color: Colors.grey[100]),
                        _buildSettingsItem(
                          icon: Icons.info_outline,
                          title: 'About App',
                          subtitle: 'Version 2.1.0',
                          onTap: () {},
                        ),
                        Divider(height: 1, color: Colors.grey[100]),
                        _buildSettingsItem(
                          icon: Icons.logout,
                          title: 'Log Out',
                          subtitle: '',
                          onTap: () {
                            authController.logout();
                          },
                          isDestructive: true,
                          hideSubtitle: true,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1F2937),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isSwitch = false,
    bool switchValue = false,
    ValueChanged<bool>? onChanged,
    bool isDestructive = false,
    bool hideSubtitle = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isSwitch ? null : onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDestructive ? Colors.red : const Color(0xFF4B5563),
                size: 24.sp,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDestructive
                            ? Colors.red
                            : const Color(0xFF1F2937),
                      ),
                    ),
                    if (!hideSubtitle) ...[
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSwitch)
                Switch(
                  value: switchValue,
                  onChanged: onChanged,
                  activeColor: const Color(0xFF3B82F6),
                )
              else if (!isDestructive)
                Icon(Icons.chevron_right, color: Colors.grey[400])
              else
                Icon(Icons.arrow_forward,
                    color: Colors.red), // Or specific icon for logout if needed
            ],
          ),
        ),
      ),
    );
  }
}
