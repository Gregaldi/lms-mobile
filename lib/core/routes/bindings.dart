import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/dio_client.dart';
import '../../features/auth/data/datasources/auth_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/attendance/data/datasources/attendance_datasource.dart';
import '../../features/attendance/data/repositories/attendance_repository_impl.dart';
import '../../features/attendance/domain/repositories/attendance_repository.dart';
import '../../features/attendance/domain/usecases/attendance_usecases.dart';
import '../../features/attendance/presentation/controllers/attendance_controller.dart';
import '../../features/onboarding/presentation/controllers/onboarding_controller.dart';
import '../../features/home/presentation/controllers/home_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure core dependencies are available
    Get.lazyPut<SharedPreferences>(
      () => Get.find<SharedPreferences>(),
      fenix: true,
    );

    Get.lazyPut<DioClient>(
      () => DioClient(Get.find<SharedPreferences>()),
      fenix: true,
    );

    // Auth dependencies
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(Get.find<DioClient>()),
      fenix: true,
    );

    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(Get.find<SharedPreferences>()),
      fenix: true,
    );

    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
        localDataSource: Get.find<AuthLocalDataSource>(),
      ),
      fenix: true,
    );

    Get.lazyPut(() => LoginUseCase(Get.find<AuthRepository>()), fenix: true);
    Get.lazyPut(() => LogoutUseCase(Get.find<AuthRepository>()), fenix: true);
    Get.lazyPut(() => GetCurrentUserUseCase(Get.find<AuthRepository>()),
        fenix: true);
    Get.lazyPut(() => CheckAuthUseCase(Get.find<AuthRepository>()),
        fenix: true);

    Get.lazyPut(
      () => AuthController(
        loginUseCase: Get.find<LoginUseCase>(),
        logoutUseCase: Get.find<LogoutUseCase>(),
        getCurrentUserUseCase: Get.find<GetCurrentUserUseCase>(),
        checkAuthUseCase: Get.find<CheckAuthUseCase>(),
      ),
      fenix: true,
    );
  }
}

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceRemoteDataSource>(
      () => AttendanceRemoteDataSourceImpl(Get.find<DioClient>()),
    );

    Get.lazyPut<LocationService>(
      () => LocationServiceImpl(),
    );

    Get.lazyPut<AttendanceRepository>(
      () => AttendanceRepositoryImpl(
        remoteDataSource: Get.find<AttendanceRemoteDataSource>(),
        locationService: Get.find<LocationService>(),
      ),
    );

    Get.lazyPut(() => MarkAttendanceUseCase(Get.find<AttendanceRepository>()));
    Get.lazyPut(
        () => GetAttendanceHistoryUseCase(Get.find<AttendanceRepository>()));
    Get.lazyPut(
        () => GetCurrentLocationUseCase(Get.find<AttendanceRepository>()));
    Get.lazyPut(() => CheckGeofenceUseCase(Get.find<AttendanceRepository>()));

    Get.lazyPut(
      () => AttendanceController(
        markAttendanceUseCase: Get.find<MarkAttendanceUseCase>(),
        getAttendanceHistoryUseCase: Get.find<GetAttendanceHistoryUseCase>(),
        getCurrentLocationUseCase: Get.find<GetCurrentLocationUseCase>(),
        checkGeofenceUseCase: Get.find<CheckGeofenceUseCase>(),
      ),
    );
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    AttendanceBinding().dependencies();
  }
}

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController());
  }
}
