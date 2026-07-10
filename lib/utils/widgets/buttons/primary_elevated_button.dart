import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // For SVG icons
import '../../extension/sized_box_extension.dart';
import '../../themes/app_text_style.dart';

class PrimaryElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? buttonColor;
  final Color? textColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final double? fontSize;
  final bool showIcon;
  final String? iconPath;
  final Color? borderColor;

  const PrimaryElevatedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.buttonColor,
    this.textColor,
    this.borderRadius,
    this.padding,
    this.height,
    this.width,
    this.fontSize,
    this.showIcon = false,
    this.iconPath,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled
            ? Theme.of(context).disabledColor.withValues(alpha: 0.12)
            : (buttonColor ?? colorScheme.onSurface),
        foregroundColor: isDisabled
            ? Theme.of(context).disabledColor
            : (textColor ?? colorScheme.onPrimary),
        shape: RoundedRectangleBorder(
          side: borderColor != null
              ? BorderSide(color: borderColor!)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(borderRadius ?? 4.0),
        ),
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        minimumSize: Size(width ?? 0, height ?? 0),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyle.mediumHeader.copyWith(
              color: isDisabled
                  ? Theme.of(context).disabledColor
                  : (textColor ?? colorScheme.onPrimary),
              fontSize: fontSize ?? 18,
            ),
          ),
          if (showIcon && iconPath != null) ...[
            8.width,
            SvgPicture.asset(
              iconPath!,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(
                textColor ?? Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
