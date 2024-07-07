import 'package:example/constant/custom_size.dart';
import 'package:example/theme/app_colors.dart';
import 'package:flutter/material.dart';

/* -- Light & Dark Elevated Button Themes -- */
class CustomElevatedButtonTheme {
  CustomElevatedButtonTheme._(); //To avoid creating instances

  /* -- Light Theme -- */
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.light,
      backgroundColor: AppColors.primary,
      disabledForegroundColor: AppColors.darkGrey,
      disabledBackgroundColor: AppColors.buttonDisabled,
      side: const BorderSide(color: AppColors.primary),
      padding: const EdgeInsets.symmetric(vertical: CustomSize.buttonHeight),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CustomSize.buttonRadius)),
      textStyle: const TextStyle(
          fontSize: 16,
          color: AppColors.textWhite,
          fontWeight: FontWeight.w500,
          fontFamily: 'Urbanist'),
    ),
  );

  /* -- Dark Theme -- */
  // static final darkElevatedButtonTheme = ElevatedButtonThemeData(
  //   style: ElevatedButton.styleFrom(
  //     elevation: 0,
  //     foregroundColor: AppColors.light,
  //     backgroundColor: AppColors.primary,
  //     disabledForegroundColor: AppColors.darkGrey,
  //     disabledBackgroundColor: AppColors.darkerGrey,
  //     side: const BorderSide(color: AppColors.primary),
  //     padding: const EdgeInsets.symmetric(vertical: CustomSize.buttonHeight),
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
