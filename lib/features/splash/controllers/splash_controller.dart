import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/constants/local_storage_key_strings.dart';
import '../../../utils/navigation/app_routes.dart';

class SplashController extends GetxController {
  void navigateToOnboarding(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        // ignore: use_build_context_synchronously
        final isLoggedIn = GetStorage().read(LocalStorageKeyStrings.isLogin) ?? false;
        // ignore: use_build_context_synchronously
        context.go(isLoggedIn ? AppRoutes.dashboard : AppRoutes.login);
      });
    });
  }
}
