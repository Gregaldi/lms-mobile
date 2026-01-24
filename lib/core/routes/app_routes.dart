import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/attendance/presentation/pages/mark_attendance_page.dart';
import '../../features/attendance/presentation/pages/attendance_detail_page.dart';
import '../../features/assignments/presentation/pages/assignment_detail_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/home/presentation/pages/student_home_page.dart';
import '../constants/app_constants.dart';
import 'bindings.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String studentHome = '/student/home';
  static const String teacherHome = '/teacher/home';
  static const String parentHome = '/parent/home';
  static const String adminHome = '/admin/home';
  static const String markAttendance = '/attendance/mark';
  static const String attendanceDetail = '/attendance/detail';
  static const String assignmentDetail = '/assignment/detail';

  static List<GetPage> get pages => [
        GetPage(
          name: onboarding,
          page: () => const OnboardingPage(),
          binding: OnboardingBinding(),
        ),
        GetPage(
          name: login,
          page: () => const LoginPage(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: markAttendance,
          page: () => const MarkAttendancePage(),
          binding: AttendanceBinding(),
        ),
        GetPage(
          name: attendanceDetail,
          page: () => const AttendanceDetailPage(),
          binding: AttendanceBinding(),
        ),
        GetPage(
          name: assignmentDetail,
          page: () => const AssignmentDetailPage(),
        ),
        GetPage(
          name: studentHome,
          page: () => const StudentHomePage(),
          binding: HomeBinding(),
          middlewares: [
            AuthMiddleware(),
            RoleMiddleware(allowedRoles: [UserRole.student]),
          ],
        ),
        GetPage(
          name: teacherHome,
          page: () => const TeacherHomePage(),
          binding: HomeBinding(),
          middlewares: [
            AuthMiddleware(),
            RoleMiddleware(allowedRoles: [UserRole.teacher]),
          ],
        ),
        GetPage(
          name: parentHome,
          page: () => const ParentHomePage(),
          binding: HomeBinding(),
          middlewares: [
            AuthMiddleware(),
            RoleMiddleware(allowedRoles: [UserRole.parent]),
          ],
        ),
        GetPage(
          name: adminHome,
          page: () => const AdminHomePage(),
          binding: HomeBinding(),
          middlewares: [
            AuthMiddleware(),
            RoleMiddleware(allowedRoles: [UserRole.admin]),
          ],
        ),
      ];
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Try to get auth controller, return null if not found (will be checked at next navigation)
    try {
      final authController = Get.find<AuthController>();
      if (!authController.isAuthenticated) {
        return const RouteSettings(name: AppRoutes.login);
      }
    } catch (e) {
      // AuthController not initialized yet, redirect to login
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}

class RoleMiddleware extends GetMiddleware {
  final List<UserRole> allowedRoles;

  RoleMiddleware({required this.allowedRoles});

  @override
  RouteSettings? redirect(String? route) {
    try {
      final authController = Get.find<AuthController>();
      final user = authController.currentUser;

      if (user == null || !allowedRoles.contains(user.role)) {
        return const RouteSettings(name: AppRoutes.login);
      }
    } catch (e) {
      // AuthController not initialized yet, redirect to login
      return const RouteSettings(name: AppRoutes.login);
    }

    return null;
  }
}

// Placeholder home pages

class TeacherHomePage extends GetView<AuthController> {
  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${controller.currentUser?.name ?? "Teacher"}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('My Courses'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Assignments'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.grade),
              title: const Text('Grading'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class ParentHomePage extends GetView<AuthController> {
  const ParentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${controller.currentUser?.name ?? "Parent"}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.child_care),
              title: const Text('My Children'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Attendance'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.grade),
              title: const Text('Grades'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Payments'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class AdminHomePage extends GetView<AuthController> {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${controller.currentUser?.name ?? "Admin"}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Manage Users'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Manage Courses'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.assessment),
              title: const Text('Reports'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
