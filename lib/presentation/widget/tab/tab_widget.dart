import 'package:flutter/material.dart';
import 'package:minder/util/style/base_icon.dart';

class TabWidget {
  static base({String? text, String? iconPath}) {
    return Tab(
      text: text,
      icon: iconPath != null ? BaseIcon.base(iconPath) : null,
      height: 40.0,
    );
  }
}
