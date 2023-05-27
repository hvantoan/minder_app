import 'package:flutter/material.dart';
import 'package:minder/util/constant/enum/screen_mode_enum.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_grid.dart';

class BaseTextStyle {
  static String baseBoldFont = "InterBold";
  static String baseRegularFont = "InterRegular";
  static String baseSemiBoldFont = "InterSemiBold";

  static TextStyle heading1({Color? color, double? fontSize}) {
    if (instanceBaseGrid.screenMode == ScreenMode.mobile) {
      return TextStyle(
          fontFamily: BaseTextStyle.baseBoldFont,
          fontSize: fontSize ?? 32,
          color: color ?? BaseColor.grey900);
    }
    return TextStyle(
        fontFamily: BaseTextStyle.baseBoldFont,
        fontSize: fontSize ?? 40,
        color: color ?? BaseColor.grey900);
  }

  static TextStyle heading2({Color? color, double? fontSize}) {
    if (instanceBaseGrid.screenMode == ScreenMode.mobile) {
      return TextStyle(
          fontFamily: BaseTextStyle.baseBoldFont,
          fontSize: fontSize ?? 24,
          color: color ?? BaseColor.grey900);
    }
    return TextStyle(
        fontFamily: BaseTextStyle.baseBoldFont,
        fontSize: fontSize ?? 32,
        color: color ?? BaseColor.grey900);
  }

  static TextStyle subtitle1({Color? color}) {
    if (instanceBaseGrid.screenMode == ScreenMode.mobile) {
      return TextStyle(
          fontFamily: BaseTextStyle.baseSemiBoldFont,
          fontSize: 20,
          color: color ?? BaseColor.grey900);
    }
    return TextStyle(
        fontFamily: BaseTextStyle.baseSemiBoldFont,
        fontSize: 24,
        color: color ?? BaseColor.grey900);
  }

  static TextStyle subtitle2({Color? color}) {
    if (instanceBaseGrid.screenMode == ScreenMode.mobile) {
      return TextStyle(
          fontFamily: BaseTextStyle.baseSemiBoldFont,
          fontSize: 18,
          color: color ?? BaseColor.grey900);
    }
    return TextStyle(
        fontFamily: BaseTextStyle.baseSemiBoldFont,
        fontSize: 20,
        color: color ?? BaseColor.grey900);
  }

  static TextStyle label({Color? color}) {
    if (instanceBaseGrid.screenMode == ScreenMode.mobile) {
      return TextStyle(
          fontFamily: BaseTextStyle.baseSemiBoldFont,
          fontSize: 16,
          color: color ?? BaseColor.grey900);
    }
    return TextStyle(
        fontFamily: BaseTextStyle.baseSemiBoldFont,
        fontSize: 18,
        color: color ?? BaseColor.grey900);
  }

  static TextStyle body1({Color? color}) {
    if (instanceBaseGrid.screenMode == ScreenMode.mobile) {
      return TextStyle(
          fontFamily: BaseTextStyle.baseRegularFont,
          fontSize: 16,
          color: color ?? BaseColor.grey900);
    }
    return TextStyle(
        fontFamily: BaseTextStyle.baseRegularFont,
        fontSize: 18,
        color: color ?? BaseColor.grey900);
  }

  static TextStyle body2({Color? color}) {
    if (instanceBaseGrid.screenMode == ScreenMode.mobile) {
      return TextStyle(
          fontFamily: BaseTextStyle.baseRegularFont,
          fontSize: 14,
          color: color ?? BaseColor.grey900);
    }
    return TextStyle(
        fontFamily: BaseTextStyle.baseRegularFont,
        fontSize: 16,
        color: color ?? BaseColor.grey900);
  }

  static TextStyle caption({Color? color, double? fontSize}) {
    if (instanceBaseGrid.screenMode == ScreenMode.mobile) {
      return TextStyle(
          fontFamily: BaseTextStyle.baseRegularFont,
          fontSize: 12,
          color: color ?? BaseColor.grey900);
    }
    return TextStyle(
        fontFamily: BaseTextStyle.baseRegularFont,
        fontSize: 14,
        color: color ?? BaseColor.grey900);
  }
}
