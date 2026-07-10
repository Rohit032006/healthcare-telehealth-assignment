import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/extension/sized_box_extension.dart';
import '../../../utils/themes/app_text_style.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController splashController = Get.find<SplashController>();
    splashController.navigateToOnboarding(context);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final subtitleColor = textTheme.bodySmall?.color ?? Colors.grey;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.health_and_safety_rounded,
                  size: 44,
                  color: colorScheme.primary,
                ),
              ),
              20.height,
              Text(
                'Healthcare',
                style: AppTextStyle.largeHeader.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              8.height,
              Text(
                'Doctor Video Consultations',
                style: AppTextStyle.mediumNormalText.copyWith(
                  color: subtitleColor,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
