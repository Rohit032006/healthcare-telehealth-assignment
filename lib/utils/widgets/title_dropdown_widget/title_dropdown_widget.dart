// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:healthcare/utils/themes/app_text_style.dart';

class TitleDropdownWidget extends StatefulWidget {
  final String? title;
  final TextStyle? textStyle;
  final bool? isTitleRequired;
  final List<String> items;
  final String? hintText;
  final String? selectedValue; // Changed from String to String?
  final void Function(String?)? onChanged;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final bool? isDropdownOnly;
  final bool? isOptional;
  final double? width;
  final double? paddingLeft;
  final ScrollController? scrollController;
  final bool? isDence;
  final bool isSearchable;

  const TitleDropdownWidget({
    super.key,
    this.title,
    required this.items,
    this.selectedValue, // Changed to nullable
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
    this.scrollController,
    this.isSearchable = false,
    required Color hintTextColor,
  });

  @override
  State<TitleDropdownWidget> createState() => _TitleDropdownWidgetState();
}

class _TitleDropdownWidgetState extends State<TitleDropdownWidget> {
  final TextEditingController _searchController = TextEditingController();
  late ValueNotifier<String?> _selectedValueNotifier;

  @override
  void initState() {
    super.initState();
    _selectedValueNotifier = ValueNotifier<String?>(
      (widget.selectedValue != null && widget.items.contains(widget.selectedValue))
          ? widget.selectedValue
          : null,
    );
  }

  @override
  void didUpdateWidget(covariant TitleDropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      _selectedValueNotifier.value =
          (widget.selectedValue != null && widget.items.contains(widget.selectedValue))
              ? widget.selectedValue
              : null;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
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
                  style: AppTextStyle.largeNormalText.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w500,
                    fontSize: widget.textStyle?.fontSize ?? 14,
                  ),
                ),
              Text(
                widget.title ?? "",
                style: widget.textStyle ??
                    AppTextStyle.largeNormalText.copyWith(
                      fontSize: 14,
                    ),
              ),
              const SizedBox(width: 4),
              if (widget.isOptional ?? false)
                Text(
                  "(Optional)",
                  style: AppTextStyle.largeNormalText.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        if (widget.isDropdownOnly ?? false) const SizedBox(height: 5),
        Container(
          width: widget.width ?? double.infinity,
          constraints:
              const BoxConstraints(minHeight: 48), // Add minimum height
          child: DropdownButtonFormField2<String>(
            isExpanded: true,
            isDense: widget.isDence ?? false,
            hint: widget.hintText != null
                ? Text(
                    widget.hintText!,
                    style: AppTextStyle.largeNormalText.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
                    ),
                  )
                : null,
            items: widget.items.map((String item) {
              return DropdownItem<String>(
                value: item,
                child: Text(
                  item,
                  style: AppTextStyle.largeNormalText.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            valueListenable: _selectedValueNotifier,
            onChanged: (newValue) {
              _selectedValueNotifier.value = newValue;
              if (widget.onChanged != null) {
                widget.onChanged!(newValue);
              }
            },
            validator: widget.validator,
            autovalidateMode: widget.autovalidateMode,
            selectedItemBuilder: (BuildContext context) {
              return widget.items.map<Widget>((String item) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item,
                    style: AppTextStyle.largeNormalText.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                );
              }).toList();
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: widget.paddingLeft ?? 12,
                right: 8,
                top: 8,
                bottom: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color:
                      Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey.withValues(alpha: 0.3), // Fixed opacity
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color:
                      Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey.withValues(alpha: 0.3), // Fixed opacity
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Theme.of(context).cardColor,
            ),
            buttonStyleData: FormFieldButtonStyleData(
              padding: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.transparent,
              ),
              elevation: 0,
            ),
            iconStyleData: IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              iconSize: 24,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              offset: const Offset(0, -5),
              scrollbarTheme: ScrollbarThemeData(
                thumbVisibility: MaterialStateProperty.all(true),
                trackVisibility: MaterialStateProperty.all(true),
                thickness: MaterialStateProperty.all(6),
                radius: const Radius.circular(10),
                thumbColor: MaterialStateProperty.all(Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey),
                trackColor: MaterialStateProperty.all(Theme.of(context).dividerColor),
              ),
            ),
            dropdownSearchData: widget.isSearchable
                ? DropdownSearchData(
                    searchController: _searchController,
                    searchBarWidgetHeight: 50,
                    searchBarWidget: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        expands: true,
                        maxLines: null,
                        controller: _searchController,
                        style: AppTextStyle.mediumNormalText.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          hintText: 'Search',
                          hintStyle: AppTextStyle.hintStyle.copyWith(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Theme.of(context).colorScheme.onSurface),
                          ),
                          enabledBorder:  UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Theme.of(context).colorScheme.onSurface),
                          ),
                          focusedBorder:  UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Theme.of(context).colorScheme.onSurface),
                          ),
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      return item.value
                          .toString()
                          .toLowerCase()
                          .contains(searchValue.toLowerCase());
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}


