class Attendance {
  final String id;
  final String userId;
  final String schoolId;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String? photoUrl;
  final AttendanceStatus status;
  final String? remarks;

  Attendance({
    required this.id,
    required this.userId,
    required this.schoolId,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.photoUrl,
    required this.status,
    this.remarks,
  });
}

enum AttendanceStatus {
  present,
  late,
  absent,
  excused,
  sick;

  String get value => name;
}

class LocationData {
  final double latitude;
  final double longitude;

  LocationData({
    required this.latitude,
    required this.longitude,
  });
}
