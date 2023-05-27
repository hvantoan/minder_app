import 'package:flutter/material.dart';
import 'package:minder/util/helper/color_helper.dart';

import 'base_style.dart';

ThemeData baseTheme() {
  final ThemeData base = ThemeData(
      fontFamily: BaseTextStyle.baseSemiBoldFont,
      primaryColor: BaseColor.green600,
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: ColorHelper.createMaterialColor(BaseColor.green600));
  return base;
}
