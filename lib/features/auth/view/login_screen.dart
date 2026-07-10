import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/validations.dart';
import '../../../utils/extension/sized_box_extension.dart';
import '../../../utils/themes/app_text_style.dart';
import '../../../utils/widgets/buttons/primary_elevated_button.dart';
import '../../../utils/widgets/text_form_fields/title_text_form_field.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    final colorScheme = Theme.of(context).colorScheme;
    const validations = Validations();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                60.height,
                Icon(Icons.health_and_safety_rounded,
                    size: 48, color: colorScheme.onSurface),
                16.height,
                Text(
                  'Welcome, Doctor',
                  style: AppTextStyle.veryLargeHeader
                      .copyWith(color: colorScheme.onSurface, fontSize: 28),
                ),
                8.height,
                Text(
                  'Sign in to view your appointments',
                  style: AppTextStyle.mediumNormalText
                      .copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
                ),
                40.height,
                TitleTextFormField(
                  title: 'Email',
                  isStarTitleRequired: true,
                  isRegularizationEnabled: true,
                  hintText: 'doctor@healthcare.com',
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: validations.validationForEmail,
                ),
                20.height,
                Obx(
                  () => TitleTextFormField(
                    title: 'Password',
                    isStarTitleRequired: true,
                    isRegularizationEnabled: true,
                    hintText: 'Enter your password',
                    controller: controller.passwordController,
                    obscureText: controller.obscurePassword.value,
                    validator: validations.validationForPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                ),
                36.height,
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: PrimaryElevatedButton(
                      label: controller.isLoading.value ? 'Signing in...' : 'Login',
                      height: 52,
                      borderRadius: 8,
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.login(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
