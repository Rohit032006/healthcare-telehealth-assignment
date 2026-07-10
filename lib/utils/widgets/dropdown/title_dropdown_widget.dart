import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthcare/utils/extension/sized_box_extension.dart';
import '../../constants/app_images.dart';
import '../../themes/app_text_style.dart';

class TitleDropdownWidget extends StatefulWidget {
  final String? title;
  final TextStyle? textStyle;
  final bool? isTitleRequired;
  final List<String> items;
  final String? hintText;
  final String? selectedValue;
  final void Function(String?)? onChanged;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final bool? isDropdownOnly;
  final bool? isOptional;
  final double? width;
  final double? paddingLeft;
  final bool? isDence;
  final Color? hintTextColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? paddingRight;
  final Icon? iconsData;
  final Color? dropdownBackgroundColor;
  final Color? itemTextColor;

  const TitleDropdownWidget({
    super.key,
    this.title,
    required this.items,
    required this.selectedValue,
    this.hintText,
    this.onChanged,
    this.textStyle,
    this.isTitleRequired = false,
    this.validator,
    this.autovalidateMode,
    this.isDropdownOnly = true,
    this.isOptional = false,
    this.width,
    this.paddingLeft,
    this.isDence,
    this.hintTextColor,
    this.backgroundColor,
    this.borderColor,
    this.paddingRight,
    this.iconsData,
    this.dropdownBackgroundColor,
    this.itemTextColor,
    required bool isSearchable,
  });

  @override
  State<TitleDropdownWidget> createState() => _TitleDropdownWidgetState();
}

class _TitleDropdownWidgetState extends State<TitleDropdownWidget> {
  late ValueNotifier<String?> _selectedValueNotifier;

  @override
  void initState() {
    super.initState();
    _selectedValueNotifier = ValueNotifier<String?>(widget.selectedValue);
  }

  @override
  void didUpdateWidget(covariant TitleDropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      _selectedValueNotifier.value = widget.selectedValue;
    }
  }

  @override
  void dispose() {
    _selectedValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isDropdownOnly ?? false)
          Row(
            children: [
              if (widget.isTitleRequired ?? false)
                Text(
                  "* ",
                  style: TextStyle(
                      color: Colors.red, fontSize: widget.textStyle?.fontSize),
                ),
              Text(
                widget.title ?? "",
                style: widget.textStyle ?? Theme.of(context).textTheme.bodyMedium,
              ),
              2.width,
              if (widget.isOptional ?? false)
                Text(
                  "(Optional)",
                  style: widget.textStyle ?? AppTextStyle.hintStyle,
                ),
            ],
          ),
        if (widget.isDropdownOnly ?? false) const SizedBox(height: 5),

        /// ✅ **Wrap DropdownButton2 inside FormField for Validation**
        FormField<String>(
          autovalidateMode:
              widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
          validator: widget.validator,
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    isDense: widget.isDence ?? false,
                    hint: widget.hintText != null
                        ? Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              textAlign: TextAlign.left,
                              widget.hintText!,
                              style: AppTextStyle.largeNormalText.copyWith(
                                  color:
                                      widget.hintTextColor ?? Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey),
                            ),
                          )
                        : null,
                    items: widget.items
                        .map(
                          (String item) => DropdownItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: AppTextStyle.largeNormalText.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color:
                                      widget.itemTextColor ?? Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey),
                            ),
                          ),
                        )
                        .toList(),
                    valueListenable: _selectedValueNotifier,
                    onChanged: (newValue) {
                      widget.onChanged?.call(newValue);
                      _selectedValueNotifier.value = newValue;
                      state.didChange(newValue);
                    },
                    buttonStyleData: ButtonStyleData(
                      width: widget.width,
                      padding: EdgeInsets.only(
                          left: widget.paddingLeft ?? 0, right: widget.paddingRight ?? 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: widget.borderColor ?? Theme.of(context).dividerColor,
                        ),
                        color: widget.backgroundColor ?? Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
                      ),
                      elevation: 0,
                    ),
                    iconStyleData: IconStyleData(
                      icon: widget.iconsData ??
                          SvgPicture.asset(
                            AppImages.downOutlineIcon,
                          ),
                    ),
                    alignment: AlignmentDirectional.center,
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: widget.dropdownBackgroundColor ?? Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
                      ),
                      offset: const Offset(0, 0),
                    ),
                  ),
                ),

                /// ✅ **Show Validation Error Message**
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      state.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}


