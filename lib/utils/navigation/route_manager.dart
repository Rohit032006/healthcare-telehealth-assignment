import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/features/splash/controllers/splash_controller.dart';
import 'package:healthcare/utils/constants/local_storage_key_strings.dart';
import 'package:healthcare/utils/navigation/app_routes.dart';

import '../../features/appointment/controller/appointment_controller.dart';
import '../../features/appointment/view/appointment_screen.dart';
import '../../features/appointment/view/dashboard_screen.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../../features/auth/view/login_screen.dart';
import '../../features/session_notes/controller/session_notes_controller.dart';
import '../../features/session_notes/view/session_notes_screen.dart';
import '../../features/splash/view/splash_screen.dart';
import '../../features/video_call/controller/video_call_controller.dart';
import '../../features/video_call/view/video_call_screen.dart';


class AppRouter {
  // Define routes
  static final GoRouter router = GoRouter(
    navigatorKey: LocalStorageKeyStrings.appNavKey,
    initialLocation: AppRoutes.defaultLocation,
    routes: [
      GoRoute(
        path: AppRoutes.defaultLocation,
        builder: (context, state) {
          Get.lazyPut<SplashController>(() => SplashController());
          ///If logged in and not onboarded
            return const SplashScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) {
          Get.lazyPut<AuthController>(() => AuthController());
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) {
          Get.put<AppointmentController>(AppointmentController(), permanent: true);
          return const DashboardScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.appointment,
        builder: (context, state) => const AppointmentScreen(),
      ),
      GoRoute(
        path: AppRoutes.videoCall,
        builder: (context, state) {
          Get.lazyPut<VideoCallController>(() => VideoCallController());
          final appointmentId = Get.find<AppointmentController>().appointment.value!.id;
          return VideoCallScreen(appointmentId: appointmentId);
        },
      ),
      GoRoute(
        path: AppRoutes.sessionNotes,
        builder: (context, state) {
          Get.lazyPut<SessionNotesController>(() => SessionNotesController());
          return const SessionNotesScreen();
        },
      ),
      // GoRoute(
      //   path: AppRoutes.bottomBar,
      //   pageBuilder: (context, state) {
      //     Get.put<BottomNavBarController>(BottomNavBarController(),
      //         permanent: true);
      //     Get.lazyPut<LeaveController>(() => LeaveController());
      //     return hcCustomTransitionPage(const BottomNavBar());
      //   },
      // ),
    ],
  );
}

Page<dynamic> hcCustomTransitionPage(Widget widget) {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return CupertinoPage(child: widget);
  }
  return CustomTransitionPage(
    child: widget,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
