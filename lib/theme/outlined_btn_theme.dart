import 'package:example/constant/custom_size.dart';
import 'package:example/theme/app_colors.dart';
import 'package:flutter/material.dart';

/* -- Light & Dark Outlined Button Themes -- */
class CustomOutlinedButtonTheme {
  CustomOutlinedButtonTheme._(); //To avoid creating instances

  /* -- Light Theme -- */
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.dark,
      side: const BorderSide(color: AppColors.borderPrimary),
      padding: const EdgeInsets.symmetric(
          vertical: CustomSize.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CustomSize.buttonRadius)),
      textStyle: const TextStyle(
          fontSize: 16,
          color: AppColors.black,
          fontWeight: FontWeight.w600,
          fontFamily: 'Urbanist'),
    ),
  );

  /* -- Dark Theme -- */
  // static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
  //   style: OutlinedButton.styleFrom(
  //     foregroundColor: AppColors.light,
  //     side: const BorderSide(color: AppColors.borderPrimary),
  //     padding: const EdgeInsets.symmetric(
  //         vertical: CustomSize.buttonHeight, horizontal: 20),
  //     shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(CustomSize.buttonRadius)),
  //     textStyle: const TextStyle(
  //         fontSize: 16,
  //         color: AppColors.textWhite,
  //         fontWeight: FontWeight.w600,
  //         fontFamily: 'Urbanist'),
  //   ),
  // );
}
