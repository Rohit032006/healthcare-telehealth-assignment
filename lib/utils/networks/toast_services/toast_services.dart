import 'package:flutter/material.dart';
import 'package:healthcare/utils/networks/toast_services/custom_toast_widget.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../constants/local_storage_key_strings.dart';
import '../../extension/sized_box_extension.dart';
import '../../themes/app_text_style.dart';

class ToastServices {
  ToastServices._();
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _currentProgressToast;
  static ValueNotifier<int>? _progressNotifier;
  static ValueNotifier<String>? _progressTitleNotifier;
  static void showToast({
    required String title,
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required Color bubbleColor,
    String? leadingIcon,
    String? trailingIcon,
    Duration duration = const Duration(seconds: 2),
  }) {
    if (LocalStorageKeyStrings.appNavKey.currentContext != null) {
      ScaffoldMessenger.of(LocalStorageKeyStrings.appNavKey.currentContext!)
          .showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 20.0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.transparent,
          content: CustomToastWidget(
            title: title,
            message: message,
            backgroundColor: backgroundColor,
            textColor: textColor,
            leadingIcon: leadingIcon,
            trailingIcon: trailingIcon,
            bubbleColor: bubbleColor,
          ),
          duration: duration,
        ),
      );
    }
  }

  static void success(String title, String message) {
    showToast(
        title: title,
        message: message,
        backgroundColor: AppColors.successToastBgColor1,
        textColor: AppColors.whiteColor,
        leadingIcon: AppImages.successToastIcon,
        trailingIcon: AppImages.unionCancleIcon,
        bubbleColor: AppColors.successBubbleColor);
  }

  static void error(String title, String message) {
    showToast(
        title: title,
        message: message,
        backgroundColor: AppColors.errorToastBgColor1,
        textColor: AppColors.whiteColor,
        leadingIcon: AppImages.errorToastIcon,
        trailingIcon: AppImages.unionCancleIcon,
        bubbleColor: AppColors.errorBubbleColor);
  }

  static void warning(String title, String message) {
    showToast(
      title: title,
      message: message,
      backgroundColor: AppColors.warningToastBgColor,
      textColor: Colors.white,
      bubbleColor: AppColors.warningBubbleColor,
      leadingIcon: AppImages.warningToastIcon,
    );
  }
 static void _disposeNotifiers() {
    try {
      _progressNotifier?.dispose();
    } catch (e) {
    }
    _progressNotifier = null;
    
    try {
      _progressTitleNotifier?.dispose();
    } catch (e) {
    }
    _progressTitleNotifier = null;
  }

  static void message(String title, String message) {
    showToast(
      title: title,
      message: message,
      backgroundColor: AppColors.messageToastBgColor,
      textColor: Colors.white,
      bubbleColor: AppColors.messageBubbleColor,
      leadingIcon: AppImages.messageToastIcon,
    );
  }
   static void info(String title, String message) {
    showToast(
      title: title,
      message: message,
      backgroundColor: AppColors.messageToastBgColor,
      textColor: Colors.white,
      bubbleColor: AppColors.messageBubbleColor,
      leadingIcon: AppImages.messageToastIcon,
    );
  }
    static void updateProgressWithPercentage(String title, int percentage) {
    if (_progressNotifier != null && _progressTitleNotifier != null) {
      try {
        _progressNotifier!.value = percentage.clamp(0, 100);
        _progressTitleNotifier!.value = title;
      } catch (e) {
        showProgressWithPercentage(title, percentage);
      }
    } else {
      showProgressWithPercentage(title, percentage);
    }
  }
   static void dismissProgress() {
    if (_currentProgressToast != null) {
      try {
        ScaffoldMessenger.of(
          LocalStorageKeyStrings.appNavKey.currentContext!,
        ).hideCurrentSnackBar();
        _currentProgressToast!.closed.then((_) {
          _disposeNotifiers();
        });
      } catch (e) {
        _disposeNotifiers();
      }
      _currentProgressToast = null;
    } else {
      _disposeNotifiers();
    }
  }
static void showProgressWithPercentage(String title, int percentage) {
  if (LocalStorageKeyStrings.appNavKey.currentContext != null) {
    _progressNotifier ??= ValueNotifier<int>(0);
    _progressTitleNotifier ??= ValueNotifier<String>(title);
    _progressNotifier!.value = percentage.clamp(0, 100);
    _progressTitleNotifier!.value = title;

    _currentProgressToast ??= ScaffoldMessenger.of(
        LocalStorageKeyStrings.appNavKey.currentContext!,
      ).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 20.0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.transparent,
          duration: const Duration(days: 1), 
          content: ValueListenableBuilder<int>(
            valueListenable: _progressNotifier!,
            builder: (context, progress, child) {
              return ValueListenableBuilder<String>(
                valueListenable: _progressTitleNotifier!,
                builder: (context, currentTitle, child) {
                  return CustomToastWidget(
                    backgroundColor: AppColors.successToastBgColor1,
                    textColor: AppColors.whiteColor,
                    leadingIcon: AppImages.successToastIcon,
                    trailingIcon: AppImages.unionCancleIcon,
                    bubbleColor: AppColors.successBubbleColor,
                    title: currentTitle,
                    message: progress == 100 ? 'Completing...' : 'Please wait...',
                    customContent: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                currentTitle,
                                style: AppTextStyle.mediumNormalText.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                           8.width,
                            Text(
                              '$progress%',
                              style: AppTextStyle.mediumNormalText.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                       8.height,
                        LinearProgressIndicator(
                          value: progress / 100,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 4,
                          borderRadius: BorderRadius.circular(10),
                        ),
                       4.height,
                        Text(
                          progress == 100 ? 'Completing...' : 'Please wait...',
                          style: AppTextStyle.mediumNormalText.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      );
  }
}
}
