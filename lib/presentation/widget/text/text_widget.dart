import 'package:flutter/material.dart';
import 'package:minder/util/style/base_text_style.dart';

class TextWidget {
  static title({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: BaseTextStyle.label(),
      ),
    );
  }
}
