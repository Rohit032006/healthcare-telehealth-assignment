import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'app_text_style.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyle.fontFamily,
      brightness: Brightness.light,
      primaryColor: AppColors.parentBgColor,
      scaffoldBackgroundColor: AppColors.lightScaffoldBackgroundColor,
      cardColor: AppColors.lightCardColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.parentBgColor,
        primary: AppColors.parentBgColor,
        brightness: Brightness.light,
        surface: AppColors.lightScaffoldBackgroundColor,
        onSurface: AppColors.lightTextColor,
        onPrimary: Colors.white,
        secondary: AppColors.parentBgColor,
        error: AppColors.redColorDark,
        onError: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyle.veryLargeHeader.copyWith(color: AppColors.lightTextColor),
        displayMedium: AppTextStyle.largeHeader.copyWith(color: AppColors.lightTextColor),
        displaySmall: AppTextStyle.mediumHeader.copyWith(color: AppColors.lightTextColor),
        headlineMedium: AppTextStyle.smallHeader.copyWith(color: AppColors.lightTextColor),
        bodyLarge: AppTextStyle.largeNormalText.copyWith(color: AppColors.lightTextColor),
        bodyMedium: AppTextStyle.mediumNormalText.copyWith(color: AppColors.lightTextColor),
        bodySmall: AppTextStyle.smallNormalText.copyWith(color: AppColors.lightSubtitleColor),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.lightTextColor,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.lightCardColor,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.lightCardColor,
      ),
      dividerColor: AppColors.lightGreyColor,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 8.0,
        backgroundColor: AppColors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.parentBgColor,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.lightTextColor,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyle.fontFamily,
      brightness: Brightness.dark,
      primaryColor: AppColors.parentBgColor,
      scaffoldBackgroundColor: AppColors.darkScaffoldBackgroundColor,
      cardColor: AppColors.darkCardColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.parentBgColor,
        primary: AppColors.parentBgColor,
        brightness: Brightness.dark,
        surface: AppColors.darkScaffoldBackgroundColor,
        onSurface: AppColors.darkTextColor,
        onPrimary: Colors.white,
        secondary: AppColors.parentBgColor,
        error: AppColors.redColorDark,
        onError: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyle.veryLargeHeader.copyWith(color: AppColors.darkTextColor),
        displayMedium: AppTextStyle.largeHeader.copyWith(color: AppColors.darkTextColor),
        displaySmall: AppTextStyle.mediumHeader.copyWith(color: AppColors.darkTextColor),
        headlineMedium: AppTextStyle.smallHeader.copyWith(color: AppColors.darkTextColor),
        bodyLarge: AppTextStyle.largeNormalText.copyWith(color: AppColors.darkTextColor),
        bodyMedium: AppTextStyle.mediumNormalText.copyWith(color: AppColors.darkTextColor),
        bodySmall: AppTextStyle.smallNormalText.copyWith(color: AppColors.darkSubtitleColor),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.darkTextColor,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.bottomBarBackColor,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.backgroundColor,
      ),
      dividerColor: AppColors.divideColor,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 8.0,
        backgroundColor: AppColors.bottomBarBackColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.parentBgColor,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.darkTextColor,
      ),
    );
  }
}
