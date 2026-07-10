import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTextStyle {
    const AppTextStyle._();
  ///Font family
  static const String fontFamily = "Figtree";
  static TextStyle regularTextStyle = const TextStyle(fontFamily: fontFamily);

  static TextStyle veryLargeHeader = const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, fontFamily: fontFamily);

  static TextStyle largeHeader = const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700, fontFamily: fontFamily);

  static TextStyle mediumHeader = const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, fontFamily: fontFamily);

  static TextStyle smallHeader = const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700, fontFamily: fontFamily);

  static TextStyle largeNormalText = const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, fontFamily: fontFamily);

  static TextStyle mediumNormalText = const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, fontFamily: fontFamily);

  static TextStyle smallNormalText = const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, fontFamily: fontFamily);

  static TextStyle hintStyle = const TextStyle(color: AppColors.hintTextColor, fontSize: 14.0, fontWeight: FontWeight.w500, fontFamily: fontFamily);
}
