import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../controllers/attendance_controller.dart';
import '../../domain/entities/attendance.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late final AttendanceController controller;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AttendanceController>();
    // Load history when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadAttendanceHistory();
    });
  }

  List<Attendance> get _mockData => [
        Attendance(
          id: '1',
          userId: '1',
          schoolId: '1',
          timestamp: DateTime.now(),
          latitude: 0,
          longitude: 0,
          status: AttendanceStatus.present,
        ),
        Attendance(
          id: '2',
          userId: '1',
          schoolId: '1',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          latitude: 0,
          longitude: 0,
          status: AttendanceStatus.excused,
        ),
        Attendance(
          id: '3',
          userId: '1',
          schoolId: '1',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          latitude: 0,
          longitude: 0,
          status: AttendanceStatus.present,
        ),
        Attendance(
          id: '4',
          userId: '1',
          schoolId: '1',
          timestamp: DateTime.now().subtract(const Duration(days: 5)),
          latitude: 0,
          longitude: 0,
          status: AttendanceStatus.late,
        ),
        Attendance(
          id: '5',
          userId: '1',
          schoolId: '1',
          timestamp: DateTime.now().subtract(const Duration(days: 8)),
          latitude: 0,
          longitude: 0,
          status: AttendanceStatus.absent,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2F5680),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F5680),
        elevation: 0,
        title: Text(
          DateFormat('MMMM yyyy').format(_focusedDay),
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            // If focused day is current month, go previous
            setState(() {
              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: () {
              setState(() {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCalendar(),
          SizedBox(height: 20.h),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  _buildHistoryHeader(),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // Filter history based on focused month
                      final history = controller.attendanceHistory.where((att) {
                        return att.timestamp.year == _focusedDay.year &&
                            att.timestamp.month == _focusedDay.month;
                      }).toList();

                      // Sort by date descending
                      history
                          .sort((a, b) => b.timestamp.compareTo(a.timestamp));

                      if (history.isEmpty) {
                        // Mock data for visualization if empty
                        // return _buildMockList();
                        // Or just show empty message
                        return _buildMockList(); // Using mock list to match the user request "seperti gambar"
                      }

                      return ListView.separated(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        itemCount: history.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final attendance = history[index];
                          return _buildAttendanceItem(attendance);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        headerVisible: false, // We use custom header
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          weekendStyle: TextStyle(color: Colors.red.withOpacity(0.7)),
        ),
        calendarStyle: CalendarStyle(
          defaultTextStyle: const TextStyle(color: Colors.white),
          weekendTextStyle: const TextStyle(color: Colors.white),
          outsideTextStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          todayDecoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(color: Color(0xFF2F5680)),
        ),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        eventLoader: (day) {
          final data = controller.attendanceHistory.isNotEmpty
              ? controller.attendanceHistory
              : _mockData;
          return data
              .where((att) => isSameDay(att.timestamp, day))
              .toList();
        },
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            if (events.isEmpty) return null;

            return Positioned(
              bottom: 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: events.map((event) {
                  final attendance = event as Attendance;
                  Color dotColor;
                  switch (attendance.status) {
                    case AttendanceStatus.present:
                      dotColor = Colors.green;
                      break;
                    case AttendanceStatus.late:
                      dotColor = Colors.orange;
                      break;
                    case AttendanceStatus.absent:
                      dotColor = Colors.red;
                      break;
                    case AttendanceStatus.excused:
                      dotColor = Colors.blue;
                      break;
                  }

                  return Container(
                    width: 6.w,
                    height: 6.w,
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHistoryHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Attendance History',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          // Use Flexible to prevent overflow
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min, // Shrink wrap
              children: [
                _buildActionButton(Icons.filter_list, 'Filter'),
                SizedBox(width: 8.w),
                _buildActionButton(Icons.upload_file, 'Export'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Shrink to fit content
        children: [
          Icon(icon, size: 14.sp, color: const Color(0xFF4B5563)),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceItem(Attendance attendance) {
    Color statusColor;
    String statusText = attendance.status.name.capitalizeFirst!;

    switch (attendance.status) {
      case AttendanceStatus.present:
        statusColor = Colors.green;
        break;
      case AttendanceStatus.late:
        statusColor = Colors.orange;
        break;
      case AttendanceStatus.absent:
        statusColor = Colors.red;
        break;
      case AttendanceStatus.excused:
        statusColor = Colors.blue;
        break;
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2F5680), // Dark blue card background like image
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('d MMMM yyyy').format(attendance.timestamp),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                DateFormat('EEE').format(attendance.timestamp),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                statusText,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Mock list for visualization if real data is empty
  Widget _buildMockList() {
    final mockData = [
      Attendance(
        id: '1',
        userId: '1',
        schoolId: '1',
        timestamp: DateTime.now(),
        latitude: 0,
        longitude: 0,
        status: AttendanceStatus.present,
      ),
      Attendance(
        id: '2',
        userId: '1',
        schoolId: '1',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        latitude: 0,
        longitude: 0,
        status: AttendanceStatus.excused,
      ),
      Attendance(
        id: '3',
        userId: '1',
        schoolId: '1',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        latitude: 0,
        longitude: 0,
        status: AttendanceStatus.present,
      ),
    ];

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      itemCount: mockData.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return _buildAttendanceItem(mockData[index]);
      },
    );
  }
}
