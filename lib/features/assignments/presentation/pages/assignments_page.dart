import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/routes/app_routes.dart';
import '../controllers/assignments_controller.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  final controller = Get.find<AssignmentsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  _buildSectionDivider('This Week'),
                  SizedBox(height: 10.h),
                  _buildAssignmentList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: 60.h, // Safe area top
        left: 20.w,
        right: 20.w,
        bottom: 20.h,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF2F5680),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48.h,
              child: TextField(
                onChanged: controller.search,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Search homework...',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14.sp,
                  ),
                  prefixIcon:
                      Icon(Icons.search, color: Colors.grey[500], size: 24.sp),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            height: 48.h,
            width: 48.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: IconButton(
              icon: Icon(Icons.filter_alt_outlined,
                  color: const Color(0xFF2F5680), size: 24.sp),
              onPressed: () {
                // Filter action
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionDivider(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey[300])),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey[300])),
        ],
      ),
    );
  }

  Widget _buildAssignmentList() {
    return Obx(() {
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.filteredAssignments.length,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          return _buildAssignmentCard(controller.filteredAssignments[index]);
        },
      );
    });
  }

  Widget _buildAssignmentCard(AssignmentUIModel assignment) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.assignmentDetail, arguments: assignment);
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
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
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assignment.title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        assignment.subject,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(assignment.status),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 16.sp, color: const Color(0xFF1F2937)),
                SizedBox(width: 8.w),
                Text(
                  _formatDueDate(assignment.dueDate),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF4B5563),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(Icons.chevron_right,
                    color: const Color(0xFF1F2937), size: 24.sp),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(AssignmentStatus status) {
    Color bgColor;
    Color textColor;
    String text;

    switch (status) {
      case AssignmentStatus.pending:
        bgColor = const Color(0xFFFFF7E6); // Light yellow
        textColor = const Color(0xFFB45309); // Dark orange/brown
        text = 'Pending';
        break;
      case AssignmentStatus.completed:
        bgColor = const Color(0xFFECFDF5); // Light green
        textColor = const Color(0xFF047857); // Dark green
        text = 'Completed';
        break;
      case AssignmentStatus.overdue:
        bgColor = const Color(0xFFFEF2F2); // Light red
        textColor = const Color(0xFFB91C1C); // Dark red
        text = 'Overdue';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'Due Today';
    } else if (difference == 1) {
      return 'Due Tomorrow';
    } else if (difference > 1 && difference < 7) {
      return 'Due in $difference days';
    } else if (difference < 0) {
      return DateFormat('MM/dd/yyyy').format(date);
    } else {
      return DateFormat('MM/dd/yyyy').format(date);
    }
  }
}
