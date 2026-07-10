import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/constants/mock_data.dart';
import '../../../utils/dependency_locator.dart';
import '../../../utils/navigation/app_routes.dart';
import '../../../utils/networks/toast_services/toast_services.dart';
import '../repo/auth_repo.dart';

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Pre-filled with the mock doctor credentials so the reviewer can log in
  // without needing to look them up in the README.
  final emailController = TextEditingController(text: MockData.doctorEmail);
  final passwordController = TextEditingController(text: MockData.doctorPassword);

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  final IAuthRepo _authRepo = getIt();

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    try {
      await _authRepo.login(emailController.text, passwordController.text);
      if (context.mounted) context.go(AppRoutes.dashboard);
    } catch (e) {
      ToastServices.error('Login Failed', e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
