import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../domain/entities/attendance.dart';
import '../controllers/attendance_controller.dart';

class MarkAttendancePage extends GetView<AttendanceController> {
  const MarkAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Attendance',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Attendance Status',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Choose your attendance status for today.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24.h),
            Obx(() => Row(
                  children: [
                    Expanded(
                      child: _buildStatusCard(
                        status: AttendanceStatus.present,
                        title: 'Check - In',
                        subtitle: '(Hadir)',
                        icon: Icons.check_circle,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildStatusCard(
                        status: AttendanceStatus.excused,
                        title: 'Permission',
                        subtitle: '(Izin)',
                        icon: Icons.description_outlined,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 16.h),
            Obx(() => _buildStatusCard(
                  status: AttendanceStatus.sick,
                  title: 'Sick',
                  subtitle: '(Sakit)',
                  icon: Icons.error,
                  color: Colors.red,
                  isFullWidth: true,
                )),

            // Dynamic Content Section
            Obx(() {
              final status = controller.selectedStatus.value;
              if (status == AttendanceStatus.excused ||
                  status == AttendanceStatus.sick) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 32.h),
                    Text(
                      'Upload Supporting Document',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    GestureDetector(
                      onTap: controller.pickDocument,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 30.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.description_outlined,
                                size: 32.sp, color: Colors.grey[400]),
                            SizedBox(height: 12.h),
                            if (controller.selectedDocument.value != null)
                              Text(
                                controller.selectedDocument.value!.path
                                    .split('/')
                                    .last,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              )
                            else
                              Column(
                                children: [
                                  Text(
                                    'Tap to upload',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF4B5563),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'PDF, JPG, PNG (Max 5MB)',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),

            SizedBox(height: 32.h),
            Text(
              'Notes (Optional)',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF333333),
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: controller.notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.w),
                  hintText: '',
                ),
              ),
            ),
            SizedBox(height: 40.h),

            // Dynamic Button
            Obx(() {
              final status = controller.selectedStatus.value;
              String buttonText = 'Submit Attendance';
              VoidCallback? onPressed;

              if (status == AttendanceStatus.present) {
                buttonText = 'Open Camera';
                onPressed = () {
                  // Logic to open camera
                  controller.capturePhoto();
                  // In real app, might navigate to camera page or show preview
                  Get.snackbar('Camera', 'Opening camera...');
                };
              } else if (status == AttendanceStatus.excused) {
                buttonText = 'Submit Permission';
                onPressed = () {
                  if (controller.selectedDocument.value == null) {
                    Get.snackbar('Error', 'Please upload a document');
                    return;
                  }
                  Get.back();
                  Get.snackbar('Success', 'Permission submitted');
                };
              } else if (status == AttendanceStatus.sick) {
                buttonText = 'Submit Sick';
                onPressed = () {
                  if (controller.selectedDocument.value == null) {
                    Get.snackbar('Error', 'Please upload a document');
                    return;
                  }
                  Get.back();
                  Get.snackbar('Success', 'Sick leave submitted');
                };
              } else {
                // Default state (no selection)
                onPressed = () {
                  Get.snackbar('Error', 'Please select a status');
                };
              }

              return SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF2196F3), // Stronger blue as in design
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (status == AttendanceStatus.present) ...[
                        Icon(Icons.camera_alt_outlined, size: 20.sp),
                        SizedBox(width: 8.w),
                      ],
                      Text(
                        buttonText,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (status != AttendanceStatus.present) ...[
                        SizedBox(width: 8.w),
                        Icon(Icons.arrow_forward, size: 20.sp),
                      ],
                    ],
                  ),
                ),
              );
            }),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required AttendanceStatus status,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    bool isFullWidth = false,
  }) {
    final isSelected = controller.selectedStatus.value == status;

    return GestureDetector(
      onTap: () {
        controller.selectedStatus.value = status;
        // Clear document when switching status to avoid confusion?
        // Or keep it. Let's keep it for now but maybe we should clear it if switching to Present.
        if (status == AttendanceStatus.present) {
          controller.selectedDocument.value = null;
        }
      },
      child: Container(
        height: 120.h,
        width: isFullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: color,
            width: 1, // Always 1px border colored
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 32.sp,
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
