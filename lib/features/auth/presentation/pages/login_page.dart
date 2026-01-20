import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/widgets/custom_text_field.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final RxBool rememberMe = false.obs;

    return Scaffold(
      backgroundColor: const Color(0xFF2F5680), // Updated color from user
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(24.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    'Logo Here',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    'Sign in to your\nAccount',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      letterSpacing: -0.64.sp, // -2% of 32px
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO: Navigate to Sign Up
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Center(
                        child: Text(
                          "Let's Get You Signed In",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                            letterSpacing: -0.2.sp, // -1% of 20px
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      CustomTextField(
                        controller: emailController,
                        label: 'Email',
                        hint: 'student_ipaB@gmail.com',
                        prefixIcon: null,
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        controller: passwordController,
                        label: 'Password',
                        hint: '*******',
                        isPassword: true,
                        prefixIcon: null,
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => Row(
                                children: [
                                  SizedBox(
                                    height: 24.w,
                                    width: 24.w,
                                    child: Checkbox(
                                      value: rememberMe.value,
                                      onChanged: (val) =>
                                          rememberMe.value = val ?? false,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Remember me',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              )),
                          TextButton(
                            onPressed: () {
                              // TODO: Forgot Password logic
                            },
                            child: Text(
                              'Forgot Password ?',
                              style: TextStyle(
                                color: const Color(0xFF2F5680),
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          height: 55.h,
                          child: ElevatedButton(
                            onPressed: controller.isLoading
                                ? null
                                : () {
                                    controller.login(
                                      schoolId:
                                          'default_school', // Hidden in UI as per design
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2F5680),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                            child: controller.isLoading
                                ? SizedBox(
                                    height: 20.w,
                                    width: 20.w,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Log In',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              'Or login with',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Google Login
                          },
                          icon: Icon(Icons.g_mobiledata,
                              size: 28.sp), // Placeholder for Google Logo
                          label: Text(
                            'Continue with Google',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Dummy Login Buttons
                      Column(
                        children: [
                          Text(
                            "Dummy Login (Dev Only)",
                            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  controller.login(
                                    schoolId: 'default',
                                    email: 'student@test.com',
                                    password: 'dummy',
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Student'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  controller.login(
                                    schoolId: 'default',
                                    email: 'teacher@test.com',
                                    password: 'dummy',
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Teacher'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
