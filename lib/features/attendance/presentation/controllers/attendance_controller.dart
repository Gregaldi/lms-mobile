import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/usecases/attendance_usecases.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class AttendanceController extends GetxController {
  final MarkAttendanceUseCase markAttendanceUseCase;
  final GetAttendanceHistoryUseCase getAttendanceHistoryUseCase;
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final CheckGeofenceUseCase checkGeofenceUseCase;

  AttendanceController({
    required this.markAttendanceUseCase,
    required this.getAttendanceHistoryUseCase,
    required this.getCurrentLocationUseCase,
    required this.checkGeofenceUseCase,
  });

  final RxList<Attendance> _attendanceHistory = <Attendance>[].obs;
  final RxBool _isLoading = false.obs;
  final Rx<File?> _capturedImage = Rx<File?>(null);
  final Rx<LocationData?> _currentLocation = Rx<LocationData?>(null);
  final RxBool _isWithinGeofence = false.obs;

  // Mark Attendance UI State
  final Rx<AttendanceStatus?> selectedStatus = Rx<AttendanceStatus?>(null);
  final TextEditingController notesController = TextEditingController();
  final Rx<File?> selectedDocument = Rx<File?>(null);

  List<Attendance> get attendanceHistory => _attendanceHistory;
  bool get isLoading => _isLoading.value;
  File? get capturedImage => _capturedImage.value;
  LocationData? get currentLocation => _currentLocation.value;
  bool get isWithinGeofence => _isWithinGeofence.value;

  final ImagePicker _picker = ImagePicker();

  // School location coordinates - fetched from school settings
  // Default values, should be updated from API in production
  double get schoolLat => -6.2088; // TODO: Fetch from API based on schoolId
  double get schoolLng => 106.8456; // TODO: Fetch from API based on schoolId

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  Future<void> pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf'],
      );

      if (result != null && result.files.single.path != null) {
        selectedDocument.value = File(result.files.single.path!);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick document: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> capturePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 85,
      );

      if (photo != null) {
        _capturedImage.value = File(photo.path);
      }
    } catch (e) {
      Get.snackbar(
        'Camera Error',
        'Failed to capture photo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> checkLocation() async {
    _isLoading.value = true;

    try {
      _currentLocation.value = await getCurrentLocationUseCase();

      if (_currentLocation.value != null) {
        _isWithinGeofence.value = await checkGeofenceUseCase(
          userLat: _currentLocation.value!.latitude,
          userLng: _currentLocation.value!.longitude,
          schoolLat: schoolLat,
          schoolLng: schoolLng,
          radiusInMeters: AppConstants.attendanceRadius,
        );
      }

      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar(
        'Location Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> markAttendance() async {
    if (_capturedImage.value == null) {
      Get.snackbar(
        'Error',
        'Please capture a selfie first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_currentLocation.value == null) {
      Get.snackbar(
        'Error',
        'Location not available',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!_isWithinGeofence.value) {
      Get.snackbar(
        'Error',
        'You are not within the school premises',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _isLoading.value = true;

    try {
      await markAttendanceUseCase(
        latitude: _currentLocation.value!.latitude,
        longitude: _currentLocation.value!.longitude,
        photoPath: _capturedImage.value!.path,
      );

      _isLoading.value = false;
      _capturedImage.value = null;

      Get.snackbar(
        'Success',
        'Attendance marked successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      loadAttendanceHistory();
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to mark attendance: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> loadAttendanceHistory() async {
    _isLoading.value = true;

    try {
      // Get userId from auth controller
      final authController = Get.find<AuthController>();
      final userId = authController.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      _attendanceHistory.value = await getAttendanceHistoryUseCase(
        userId: userId,
      );

      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load attendance history: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
