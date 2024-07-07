import 'package:example/constant/custom_size.dart';
import 'package:example/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormFieldTheme {
  CustomTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: AppColors.darkGrey,
    suffixIconColor: AppColors.darkGrey,
    labelStyle: const TextStyle().copyWith(
        fontSize: CustomSize.fontSizeMd,
        color: AppColors.textPrimary,
        fontFamily: 'Urbanist'),
    hintStyle: const TextStyle().copyWith(
        fontSize: CustomSize.fontSizeSm,
        color: AppColors.textSecondary,
        fontFamily: 'Urbanist'),
    errorStyle: const TextStyle()
        .copyWith(fontStyle: FontStyle.normal, fontFamily: 'Urbanist'),
    floatingLabelStyle: const TextStyle()
        .copyWith(color: AppColors.textSecondary, fontFamily: 'Urbanist'),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(CustomSize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: AppColors.borderPrimary),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(CustomSize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: AppColors.borderPrimary),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(CustomSize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: AppColors.borderSecondary),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(CustomSize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: AppColors.error),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(CustomSize.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: AppColors.error),
    ),
  );

  // static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
  //   errorMaxLines: 2,
  //   prefixIconColor: AppColors.darkGrey,
  //   suffixIconColor: AppColors.darkGrey,
  //   // constraints: const BoxConstraints.expand(height: CustomSize.inputFieldHeight),
  //   labelStyle: const TextStyle().copyWith(
  //       fontSize: CustomSize.fontSizeMd,
  //       color: AppColors.white,
  //       fontFamily: 'Urbanist'),
  //   hintStyle: const TextStyle().copyWith(
  //       fontSize: CustomSize.fontSizeSm,
  //       color: AppColors.white,
  //       fontFamily: 'Urbanist'),
  //   floatingLabelStyle: const TextStyle().copyWith(
  //       color: AppColors.white.withOpacity(0.8), fontFamily: 'Urbanist'),
  //   border: const OutlineInputBorder().copyWith(
  //     borderRadius: BorderRadius.circular(CustomSize.inputFieldRadius),
  //     borderSide: const BorderSide(width: 1, color: AppColors.darkGrey),
  //   ),
  //   enabledBorder: const OutlineInputBorder().copyWith(
  //     borderRadius: BorderRadius.circular(CustomSize.inputFieldRadius),
  //     borderSide: const BorderSide(width: 1, color: AppColors.darkGrey),
  //   ),
  //   focusedBorder: const OutlineInputBorder().copyWith(
  //     borderRadius: BorderRadius.circular(CustomSize.inputFieldRadius),
  //     borderSide: const BorderSide(width: 1, color: AppColors.white),
  //   ),
  //   errorBorder: const OutlineInputBorder().copyWith(
  //     borderRadius: BorderRadius.circular(CustomSize.inputFieldRadius),
  //     borderSide: const BorderSide(width: 1, color: AppColors.error),
  //   ),
  //   focusedErrorBorder: const OutlineInputBorder().copyWith(
  //     borderRadius: BorderRadius.circular(CustomSize.inputFieldRadius),
  //     borderSide: const BorderSide(width: 2, color: AppColors.error),
  //   ),
  // );
}
