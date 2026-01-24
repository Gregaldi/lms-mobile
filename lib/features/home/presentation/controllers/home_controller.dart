import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:lms_mobile/core/routes/app_routes.dart';

class HomeController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    requestLocation(fromInit: true);
  }

  // checkInitialLocationPermission removed as requestLocation handles it now

  void changeTabIndex(int index) {
    selectedIndex.value = index;
    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        // Navigate to Attendance History or stay if it's a tab
        // For now, let's assume it's just a tab change in the bottom nav
        break;
      case 2:
        // Navigate to Homework/Assignments
        break;
      case 3:
        // Navigate to Profile
        break;
    }
  }

  // Dummy data for homework
  final List<Map<String, dynamic>> homeworkList = [
    {
      'subject': 'Matematika',
      'title': 'Algebra Problems Ch.5',
      'due': 'Tomorrow',
      'dueColor': 0xFFFF5252, // Red
      'color': 0xFFF8FBFF, // Very Light Blue
      'icon': 0xF6E8,
    },
    {
      'subject': 'IPS',
      'title': 'Lab Report - Motion',
      'due': 'Friday',
      'dueColor': 0xFF4CAF50, // Green
      'color': 0xFFF9FAFB, // Very Light Gray
      'icon': 0xF05E,
    },
  ];

  var currentAddress =
      'Jl. Raya Bekasi No.13910, RT.7/RW.1, Cakung Bar., Kec. Cakung'.obs;
  var isLoadingLocation = false.obs;

  // Use Rx<LatLng?> to allow null initial value
  final Rx<LatLng?> currentPosition = Rx<LatLng?>(null);

  Future<void> requestLocation({bool fromInit = false}) async {
    isLoadingLocation.value = true;
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        Get.bottomSheet(
          const LocationErrorSheet(),
          isDismissible: false,
          enableDrag: false,
        );
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Just request permission directly
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          if (!fromInit) {
            Get.snackbar(
                'Permission Denied', 'Please allow location permission');
          } else {
            // Force user to make a decision if it's initial load?
            // Maybe just show the sheet to guide them
            Get.bottomSheet(
              const LocationErrorSheet(),
              isDismissible: false,
              enableDrag: false,
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        Get.bottomSheet(
          const LocationErrorSheet(),
          isDismissible: false,
          enableDrag: false,
        );
        return;
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      Position position = await Geolocator.getCurrentPosition();

      currentPosition.value = LatLng(position.latitude, position.longitude);

      // Get address from coordinates
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          // Construct address string
          List<String> addressParts = [];
          if (place.street != null && place.street!.isNotEmpty) {
            addressParts.add(place.street!);
          }
          if (place.subLocality != null && place.subLocality!.isNotEmpty) {
            addressParts.add(place.subLocality!);
          }
          if (place.locality != null && place.locality!.isNotEmpty) {
            addressParts.add(place.locality!);
          }
          if (place.postalCode != null && place.postalCode!.isNotEmpty) {
            addressParts.add(place.postalCode!);
          }
          if (place.country != null && place.country!.isNotEmpty) {
            addressParts.add(place.country!);
          }

          currentAddress.value = addressParts.join(', ');
        } else {
          currentAddress.value =
              'Lat: ${position.latitude.toStringAsFixed(4)}, Long: ${position.longitude.toStringAsFixed(4)}';
        }
      } catch (e) {
        // Fallback if geocoding fails
        currentAddress.value =
            'Lat: ${position.latitude.toStringAsFixed(4)}, Long: ${position.longitude.toStringAsFixed(4)}';
        debugPrint('Error getting address: $e');
      }

      if (!fromInit) {
        Get.snackbar('Success', 'Location updated!');
      }
    } catch (e) {
      if (!fromInit) {
        Get.snackbar('Error', 'Failed to get location: $e');
      }
    } finally {
      isLoadingLocation.value = false;
    }
  }

  // Navigation to Attendance Page
}

// Simple Bottom Sheet Widget for Location Error

class LocationErrorSheet extends StatelessWidget {
  const LocationErrorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Please turn on your location',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2F5680),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          // Placeholder for the illustration
          Container(
            height: 180.h,
            width: 240.w,
            decoration: const BoxDecoration(
              image: DecorationImage(
                // Use a placeholder if asset is missing, or the asset if available
                image: AssetImage('assets/icons/location_illustration.png'),
                fit: BoxFit.contain,
              ),
            ),
            child: const SizedBox.shrink(),
          ),
          SizedBox(height: 30.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton.icon(
              onPressed: () {
                Get.back();
                Geolocator.openLocationSettings();
              },
              icon: const Icon(Icons.tune),
              label: const Text('Open Setting'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                    0xFF2196F3), // Brighter Blue matching the screenshot
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
