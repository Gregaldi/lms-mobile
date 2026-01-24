import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lms_mobile/core/constants/app_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/auth_usecases.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final CheckAuthUseCase checkAuthUseCase;

  AuthController({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.checkAuthUseCase,
  });

  final Rx<User?> _currentUser = Rx<User?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  User? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get isAuthenticated => _currentUser.value != null;

  @override
  void onInit() {
    super.onInit();
    checkAuth();
  }

  Future<void> checkAuth() async {
    try {
      final isAuth = await checkAuthUseCase();
      if (isAuth) {
        _currentUser.value = await getCurrentUserUseCase();
      }
    } catch (e) {
      _currentUser.value = null;
    }
  }

  Future<void> login({
    required String schoolId,
    required String email,
    required String password,
  }) async {
    _isLoading.value = true;
    _errorMessage.value = '';

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // DUMMY LOGIN IMPLEMENTATION (Replaces API for now)
    UserRole role = UserRole.student;
    String name = 'John Student';

    final emailLower = email.toLowerCase();
    if (emailLower.contains('teacher')) {
      role = UserRole.teacher;
      name = 'Sarah Teacher';
    } else if (emailLower.contains('parent')) {
      role = UserRole.parent;
      name = 'Michael Parent';
    } else if (emailLower.contains('admin')) {
      role = UserRole.admin;
      name = 'Admin User';
    }

    final dummyUser = User(
      id: '${role.name}_123',
      schoolId: schoolId,
      name: name,
      email: email,
      role: role,
      profileImage: null,
    );

    _currentUser.value = dummyUser;
    _isLoading.value = false;
    _navigateBasedOnRole(dummyUser);

    /* 
    // API Implementation (Temporarily Disabled)
    try {
      final user = await loginUseCase(
        schoolId: schoolId,
        email: email,
        password: password,
      );

      _currentUser.value = user;
      _isLoading.value = false;

      // Navigate based on role
      _navigateBasedOnRole(user);
    } catch (e) {
      _isLoading.value = false;
      _errorMessage.value = e.toString();
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    */
  }

  void _navigateBasedOnRole(User user) {
    switch (user.role) {
      case UserRole.student:
        Get.offAllNamed(AppRoutes.studentHome);
        break;
      case UserRole.teacher:
        Get.offAllNamed(AppRoutes.teacherHome);
        break;
      case UserRole.parent:
        Get.offAllNamed(AppRoutes.parentHome);
        break;
      case UserRole.admin:
        Get.offAllNamed(AppRoutes.adminHome);
        break;
    }
  }

  Future<void> logout() async {
    try {
      await logoutUseCase();
      _currentUser.value = null;
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar(
        'Logout Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
