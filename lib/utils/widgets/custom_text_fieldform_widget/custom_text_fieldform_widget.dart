import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/themes/app_text_style.dart';
import '../../extension/sized_box_extension.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final String? suffixIconPath;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final Color cursorColor;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;
  final Function()? ontap;
  final bool obscureText;
  final VoidCallback? toggleObscureText;
  final FocusNode? focusNode;
  final int? maxLines;
  final bool expands;
  final bool? readOnly;
  final double? suffixIconHeight;
  final String? errorText;
  final bool? enabled; // NEW LINE
  final bool border;
  final String? labelText;
  final bool isMandatory;
  final VoidCallback? onFieldTap;
  final Color? textColor;
  final Color? iconColor;
  final TextCapitalization textCapitalization;
  final Widget? prefixIcon;



  const CustomTextField({
    super.key,
      required this.hintText,
      this.controller,
      this.isPassword = false,
      this.suffixIconPath,
      this.suffixIcon,
      this.prefixIcon,
      this.keyboardType = TextInputType.text,
      this.cursorColor = Colors.green,
      this.onChanged,
      this.validator,
      this.inputFormatters,
      this.autovalidateMode,
      this.ontap,
      this.obscureText = false,
      this.toggleObscureText,
      this.focusNode,
      this.maxLines = 1,
      this.expands = false,
      this.readOnly,
      this.suffixIconHeight,
      this.errorText,
      this.enabled,
      this.isMandatory = true,
      this.textColor,
      this.iconColor,
      this.border = false, this.labelText,this.onFieldTap,
           this.textCapitalization = TextCapitalization.none,
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
     
        if (labelText != null && labelText!.isNotEmpty) ...[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: labelText,
                  style: AppTextStyle.mediumNormalText.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                if (isMandatory)
                  TextSpan(
                    text: " *",
                    style: AppTextStyle.mediumNormalText.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
              ],
            ),
          ),
          5.height,
        ],

        TextFormField(
          readOnly: readOnly ?? false,
          textAlign: TextAlign.start,
          inputFormatters: inputFormatters ??
              [FilteringTextInputFormatter.deny(RegExp(r'^\s+'))],
          autovalidateMode: autovalidateMode,
          validator: validator,
          controller: controller,
          obscureText: isPassword ? obscureText : false,
          cursorColor: cursorColor,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          enabled: enabled ?? true,
          style: AppTextStyle.mediumNormalText.copyWith(
            color: textColor ??
                ((readOnly ?? false) ? Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey : Theme.of(context).textTheme.bodyLarge?.color),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          focusNode: focusNode,
          onTap: onFieldTap,
          onChanged: onChanged,
          maxLines: isPassword ? 1 : maxLines,
          expands: expands,
          decoration: InputDecoration(
             filled: true,                                        
             fillColor: Theme.of(context).cardColor,     
            prefixIcon: prefixIcon,
            enabledBorder: border
                ? OutlineInputBorder(
                    borderSide:
                         BorderSide(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.15), width: 1.2),
                    borderRadius: BorderRadius.circular(8),
                  )
                : const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.greyTextColor),
                  ),
            focusedBorder: border
                ? OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  )
                : const UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.greyTextColor, width: 1.5),
                  ),
            errorBorder: border
                ? OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: AppColors.redColor, width: 1.2),
                    borderRadius: BorderRadius.circular(8),
                  )
                : const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.redColor),
                  ),
            focusedErrorBorder: border
                ? OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: AppColors.redColor, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  )
                : const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.redColor, width: 1.5),
                  ),
            hintText: hintText,
            hintStyle: AppTextStyle.mediumNormalText.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
              fontSize: 15,
            ),
            errorText: errorText?.isNotEmpty == true ? errorText : null,
            errorStyle: AppTextStyle.mediumNormalText.copyWith(
              color: Theme.of(context).colorScheme.error,
              fontSize: 14,
            ),
            suffixIcon: _buildSuffixIcon(context),
          ),
          contextMenuBuilder: (context, editableTextState) {
            // ignore: prefer_const_constructors
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon(BuildContext context) {
    if (suffixIcon != null) {
      return suffixIcon;
    }

    // Password visibility toggle
    if (isPassword) {
      return IconButton(
        icon: Icon(
          obscureText ? Icons.visibility_off : Icons.visibility,
          color: iconColor ?? Theme.of(context).iconTheme.color,
        ),
        onPressed: toggleObscureText,
      );
    }

    // SVG icon path
    if (suffixIconPath != null) {
      return InkWell(
        onTap: ontap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(
            height: suffixIconHeight,
            suffixIconPath!,
            colorFilter: ColorFilter.mode(iconColor ?? Theme.of(context).iconTheme.color ?? Colors.grey, BlendMode.srcIn),
          ),
        ),
      );
    }

    return null;
  }
}


