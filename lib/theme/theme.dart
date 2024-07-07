import 'package:example/theme/app_colors.dart';
import 'package:example/theme/appbar_theme.dart';
import 'package:example/theme/bottom_sheet_theme.dart';
import 'package:example/theme/checkbox_theme.dart';
import 'package:example/theme/elevated_btn_theme.dart';
import 'package:example/theme/outlined_btn_theme.dart';
import 'package:example/theme/text_field_theme.dart';
import 'package:example/theme/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Urbanist',
    disabledColor: AppColors.grey,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    textTheme: CustomTextTheme.lightTextTheme,
    appBarTheme: CustomAppBarTheme.lightAppBarTheme,
    checkboxTheme: CustomCheckboxTheme.lightCheckboxTheme,
    scaffoldBackgroundColor: AppColors.primaryBackground,
    bottomSheetTheme: CustomBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: CustomElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: CustomOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: CustomTextFormFieldTheme.lightInputDecorationTheme,
  );

  // static ThemeData darkTheme = ThemeData(
  //   useMaterial3: true,
  //   fontFamily: 'Urbanist',
  //   disabledColor: AppColors.grey,
  //   brightness: Brightness.dark,
  //   primaryColor: AppColors.primary,
  //   textTheme: CustomTextTheme.darkTextTheme,
  //   appBarTheme: CustomAppBarTheme.darkAppBarTheme,
  //   checkboxTheme: CustomCheckboxTheme.darkCheckboxTheme,
  //   scaffoldBackgroundColor: AppColors.primary.withOpacity(0.1),
  //   bottomSheetTheme: CustomBottomSheetTheme.darkBottomSheetTheme,
  //   elevatedButtonTheme: CustomElevatedButtonTheme.darkElevatedButtonTheme,
  //   outlinedButtonTheme: CustomOutlinedButtonTheme.darkOutlinedButtonTheme,
  //   inputDecorationTheme: CustomTextFormFieldTheme.darkInputDecorationTheme,
  // );
}
