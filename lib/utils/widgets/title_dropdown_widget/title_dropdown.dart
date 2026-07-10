// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../constants/app_colors.dart';
import '../../themes/app_text_style.dart';

class TitleDropdown extends StatefulWidget {
  final String? title;
  final TextStyle? textStyle;
  final bool? isTitleRequired;
  final List<Map<String, dynamic>> items;
  final String? hintText;
  final String? selectedValue;
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
  final FocusNode? searchNode;

  const TitleDropdown({
    super.key,
    this.title,
    required this.items,
    this.selectedValue,
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
    this.searchNode,
  });

  @override
  State<TitleDropdown> createState() => _TitleDropdownState();
}

class _TitleDropdownState extends State<TitleDropdown> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  late ValueNotifier<String?> _selectedValueNotifier;

  @override
  void initState() {
    super.initState();
    _selectedValueNotifier = ValueNotifier<String?>(widget.selectedValue);
  }

  @override
  void didUpdateWidget(covariant TitleDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      _selectedValueNotifier.value = widget.selectedValue;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    searchFocusNode.dispose();
    _selectedValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isDropdownOnly ?? false)
            Row(
              children: [
                
                Text(
                  widget.title ?? "",
                  style: widget.textStyle ??
                      AppTextStyle.largeNormalText.copyWith(
                        fontSize: 14,
                      ),
                ),
                if (widget.isTitleRequired ?? false)
                  Text(
                    "* ",
                    style: AppTextStyle.largeNormalText.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w500,
                      fontSize: widget.textStyle?.fontSize ?? 14,
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
            constraints: const BoxConstraints(minHeight: 48),
            child: DropdownButtonFormField2<String>(
              isExpanded: true,
              isDense: true,
              alignment: Alignment.centerLeft,
              hint: widget.hintText != null
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.hintText!,
                        style: AppTextStyle.largeNormalText.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
                        ),
                      ),
                    )
                  : null,
              items: widget.items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return DropdownItem<String>(
                  enabled:  item["enable"] ?? true,
                  value: item["id"]?.toString() ?? "INDEX_$index",
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        item["name"] ?? "",
                        style: AppTextStyle.largeNormalText.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ),
                  ),
                );
              }).toList(),
              valueListenable: _selectedValueNotifier,
              onChanged: (value) {
                _selectedValueNotifier.value = value;
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
                searchFocusNode.unfocus();
              },
              validator: widget.validator,
              autovalidateMode: widget.autovalidateMode,
              selectedItemBuilder: (BuildContext context) {
                return widget.items.map<Widget>((entry) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      entry["name"] ?? "",
                      style: AppTextStyle.largeNormalText.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis, 
                      maxLines: 1,
                    ),
                  );
                }).toList();
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 0, right: 0),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey),
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
              buttonStyleData: FormFieldButtonStyleData(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.transparent,
                ),
                elevation: 0,
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.greyTextColor,
                ),
                iconSize: 24,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).cardColor,
                boxShadow:const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                offset: const Offset(0, -5),
                scrollbarTheme: ScrollbarThemeData(
                  thumbVisibility: MaterialStateProperty.all(true),
                  trackVisibility: MaterialStateProperty.all(true),
                  thickness: MaterialStateProperty.all(5),
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
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          scrollPadding: EdgeInsets.zero,
                          focusNode: searchFocusNode,
                          expands: false,
                          maxLines: null,
                          controller: _searchController,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                          decoration:  InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 18,
                            ),
                            hintText: 'Search',
                            hintStyle: AppTextStyle.hintStyle.copyWith(
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimary),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        final name = widget.items
                            .firstWhere((e) => e["id"] == item.value)["name"]
                            ?.toLowerCase();
                        return name?.contains(searchValue.toLowerCase()) ?? false;
                      },
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}


