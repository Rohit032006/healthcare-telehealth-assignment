import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/local_storage_key_strings.dart';
import '../../extension/sized_box_extension.dart';
import '../../themes/app_text_style.dart';
import '../buttons/primary_elevated_button.dart';
import 'package:go_router/go_router.dart';

class DataNotFoundButtonWidget extends StatelessWidget {
  final bool buttonActive;
  final String? title;
  final String? des;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  
  const DataNotFoundButtonWidget({
    super.key,
    this.buttonActive = true,
    this.title,
    this.des,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/images/marketing_no_data_found.svg",
            colorFilter:  const ColorFilter.mode(
             Color(0xFF9E9E9E),
              BlendMode.srcIn,
            ),
          ),
          10.height,
          Text(
           title ?? "No Data Available",
            style: AppTextStyle.mediumNormalText.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          10.height,
          Text(
           des ?? "",
            style: AppTextStyle.mediumNormalText.copyWith(
                color: Theme.of(context).dividerColor,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          20.height,
          if (buttonActive) PrimaryElevatedButton(
            label: buttonText ?? "Go to dashboard",
            buttonColor: Theme.of(context).colorScheme.onSurface,
            textColor: Theme.of(context).colorScheme.surface,
            onPressed: onButtonPressed ?? () {
              LocalStorageKeyStrings.appNavKey.currentContext?.pop();
            },
          ),
        ],
      ),
    );
  }
}


