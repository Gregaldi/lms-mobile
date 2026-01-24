import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/attendance.dart';

class AttendanceDetailPage extends StatelessWidget {
  const AttendanceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // We can use the passed argument if available, otherwise use mock data to match the design
    final Attendance? attendance = Get.arguments as Attendance?;

    // Mock data matching the design image
    final date = attendance != null
        ? DateFormat('dd MMMM yyyy').format(attendance.timestamp)
        : '24 July 2025';
    final day = attendance != null
        ? DateFormat('EEEE').format(attendance.timestamp)
        : 'Thursday';
    final status =
        attendance != null ? attendance.status.name.capitalizeFirst : 'Present';

    Color statusColor = const Color(0xFF00C853);
    if (attendance != null) {
      switch (attendance.status) {
        case AttendanceStatus.present:
          statusColor = const Color(0xFF00C853);
          break;
        case AttendanceStatus.late:
          statusColor = Colors.orange;
          break;
        case AttendanceStatus.absent:
        case AttendanceStatus.sick:
          statusColor = Colors.red;
          break;
        case AttendanceStatus.excused:
          statusColor = Colors.blue;
          break;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios_new,
                size: 16.sp, color: Colors.black),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Present Attendance Detail',
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
            // Status Header
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  status ?? 'Present',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              'Check-In Attendance Record',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20.h),
            Divider(color: Colors.grey[200], thickness: 1),
            SizedBox(height: 20.h),

            // Date Information
            Text(
              'Date Information',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.h),
            _buildDetailRow('Date:', date),
            SizedBox(height: 12.h),
            _buildDetailRow('Day:', day),
            SizedBox(height: 20.h),
            Divider(color: Colors.grey[200], thickness: 1),
            SizedBox(height: 20.h),

            // Time Details
            Text(
              'Time Details',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.h),
            _buildIconDetailRow(
                Icons.access_time, 'Check-In Time:', '07:32 AM'),
            SizedBox(height: 16.h),
            _buildIconDetailRow(
                Icons.access_time, 'Check-Out Time:', '03:01 PM'),
            SizedBox(height: 16.h),
            _buildIconDetailRow(Icons.access_time, 'Total Duration:', '7h 29m'),
            SizedBox(height: 16.h),
            _buildStatusRow(Icons.auto_awesome, 'Status:', 'On Time',
                const Color(0xFF00C853)),
            SizedBox(height: 20.h),
            Divider(color: Colors.grey[200], thickness: 1),
            SizedBox(height: 20.h),

            // Location Information
            Text(
              'Location Information',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.h),
            _buildLocationRow('Check-In Location:', 'SMA AL-Alzhar'),
            SizedBox(height: 24.h),
            _buildLocationRow('Check-Out Location:', 'SMA AL-Alzhar'),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildIconDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: Colors.grey[400]),
        SizedBox(width: 12.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(
      IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: color),
        SizedBox(width: 12.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_on, size: 24.sp, color: Colors.grey[400]),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
