import 'package:flutter/material.dart';
import '../../../utils/themes/app_text_style.dart';
import '../../extension/sized_box_extension.dart';

class UnderDevelopmentDailogBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final Color? iconColor;
  final String? buttonText;
  final VoidCallback? onPressed;
  final bool showInfoBox;
  final String? infoText;

  const UnderDevelopmentDailogBox({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.construction,
    this.iconColor = Colors.orange,
    this.buttonText = 'OK',
    this.onPressed,
    this.showInfoBox = true,
    this.infoText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
            10.width,
          ],
          Expanded(
            child: Text(
              title,
              style: AppTextStyle.smallNormalText.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: AppTextStyle.smallNormalText.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 14,
            ),
          ),
          if (showInfoBox && (infoText != null || infoText == null)) ...[
            15.height,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (iconColor ?? Colors.orange).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (iconColor ?? Colors.orange).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: iconColor ?? Colors.orange,
                    size: 20,
                  ),
                  10.width,
                  Expanded(
                    child: Text(
                      infoText ?? 'Please try again later or contact support for assistance.',
                      style: AppTextStyle.smallNormalText.copyWith(
                        color: iconColor ?? Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          child: Text(
            buttonText ?? 'OK',
            style: AppTextStyle.smallNormalText.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

