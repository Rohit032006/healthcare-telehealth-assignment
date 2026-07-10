import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare/utils/extension/sized_box_extension.dart' show Sized;
import '../../constants/app_colors.dart';
import '../../themes/app_text_style.dart';

class TitleTextFormField extends StatelessWidget {
  final String? title;
  final bool? isStarTitleRequired;
  final bool? isOptional;
  final bool? isRegularizationEnabled; 
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? contentPadding;
  final Color? borderColor;
  final String? hintText;
  final void Function()? onTap;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final InputBorder? border;
  final bool? obscureText;
  final TextStyle? usertextStyle;
  final TextStyle? errorTextstyle;
  final bool? readOnly;
  final int? maxLines;
  final bool showCalenderIcon;
  final Color? hintTextColor;
  final TextStyle? titleStyle;

  const TitleTextFormField({
    super.key,
    this.inputFormatters,
    this.validator,
    this.contentPadding,
    this.borderColor,
    this.hintText,
    this.onTap,
    this.onChanged,
    this.controller,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.border,
    this.obscureText,
    this.title,
    this.isStarTitleRequired = false,
    this.isOptional = false,
    this.isRegularizationEnabled = false, // ✅ Default false
    this.usertextStyle,
    this.errorTextstyle,
    this.readOnly,
    this.maxLines,
    this.showCalenderIcon = false,
    this.hintTextColor,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: borderColor ?? Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey),
    );

    final OutlineInputBorder redBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.redColor),
    );

    final InputDecoration inputDecoration = InputDecoration(
       filled: true,                                  
       fillColor: Theme.of(context).cardColor,  
      contentPadding: const EdgeInsets.all(10.0),
      border: outlineInputBorder,
      enabledBorder: outlineInputBorder,
      disabledBorder: outlineInputBorder,
      errorBorder: redBorder,
      focusedBorder: outlineInputBorder,
      errorMaxLines: 1,
      focusedErrorBorder: redBorder,
      suffixIcon: showCalenderIcon
          ? IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.grey),
              onPressed: onTap,
            )
          : suffixIcon,
      hintText: hintText ?? "Write here...",
      hintStyle: AppTextStyle.largeNormalText.copyWith(
        fontWeight: FontWeight.w400,
        color: hintTextColor ?? Theme.of(context).textTheme.bodySmall?.color,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title ?? "",
              style: titleStyle ?? AppTextStyle.mediumNormalText
                  .copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            if (isOptional ?? false)
              Text(
                " (Optional)",
                style: AppTextStyle.mediumNormalText
                    .copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
              ),
            if ((isStarTitleRequired ?? false) && (isRegularizationEnabled ?? false))
              Text(
                " *",
                style: AppTextStyle.largeNormalText
                    .copyWith(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
        8.height,
        TextFormField(
          readOnly: readOnly ?? false,
          onTap: onTap,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: maxLines ?? 1,
          inputFormatters:
              inputFormatters ?? [FilteringTextInputFormatter.deny(RegExp(r'^\s+'))],
          controller: controller,
          validator: validator,
          obscureText: obscureText ?? false,
          cursorColor: Theme.of(context).colorScheme.onSurface,
          cursorErrorColor: Theme.of(context).colorScheme.onSurface,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: usertextStyle ??
              AppTextStyle.mediumHeader.copyWith(
                  color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
          decoration: inputDecoration,
        ),
      ],
    );
  }
}



