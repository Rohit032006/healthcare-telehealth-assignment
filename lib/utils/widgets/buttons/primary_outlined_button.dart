import 'package:flutter/material.dart';

class PrimaryOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? buttonColor;
  final Color? borderColor;
  final Color? textColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final double? fontSize;

  const PrimaryOutlinedButton(
      {super.key,
      required this.label,
      this.onPressed,
      this.buttonColor,
      this.borderColor,
      this.textColor,
      this.borderRadius,
      this.padding,
      this.height,
      this.width,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.grey,
          side: BorderSide(
          color: (onPressed != null)
                ? borderColor ?? Theme.of(context).primaryColor
                : borderColor?.withValues(alpha: 0.5) ?? Theme.of(context).primaryColor.withValues(alpha: 0.5),
            width: 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 4.0),
          ),
          padding: padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
              color: (onPressed != null) ? textColor?.withValues(alpha: 0.5) ?? Theme.of(context).primaryColor : textColor, fontSize: fontSize ?? 16),
        ),
      ),
    );
  }
}
