import 'package:flutter/material.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';


class AppTextStyles {
  AppTextStyles._();

  static const String _fontFamily = 'Poppins';

  static TextStyle textView({double size = 12, Color color = AppColors.black}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: size,
        color: color,
      );

  static TextStyle textView13Ssp({Color color = AppColors.orange}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: color,
      );

  static TextStyle editText13Ssp({Color color = AppColors.gray}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: color,
      );

  static TextStyle otpTitle({Color color = AppColors.white}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontSize: 15,
        color: color,
      );

  static TextStyle textViewWhite13Ssp({Color color = AppColors.white}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: color,
      );

  static TextStyle loginEditText13Ssp({Color color = AppColors.purple700}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 13,
        color: color,
      );

  static TextStyle textViewOrange13Ssp({Color color = AppColors.orange}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: color,
      );

  static TextStyle icTextViewBlackFont10Ssp({Color color = AppColors.black}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 10,
        color: color,
      );

  static TextStyle forgotPasswordBlue({Color color = AppColors.purple700}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        color: color,
      );

  static TextStyle popinsMedium({Color color = AppColors.purple700}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 13,
        color: color,
      );

  static TextStyle headingBold18({Color color = AppColors.black}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: color,
      );

  static TextStyle semibold14({Color color = AppColors.orange}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: color,
      );

  static TextStyle semibold9({Color color = AppColors.purple700}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 9,
        color: color,
      );
}