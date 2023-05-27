import 'package:flutter/material.dart';
import 'package:minder/presentation/widget/checkbox/checkbox_widget.dart';
import 'package:minder/presentation/widget/text/text_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_style.dart';

class TileWidget {
  static Widget common(
      {required String title,
      String? trailing,
      String? iconPath,
      Color? trailingColor,
      VoidCallback? onTap,
      bool isDirector = true}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: BaseColor.grey50,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          if (iconPath != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: BaseIcon.base(iconPath, color: BaseColor.grey900),
            ),
          Expanded(child: Text(title, style: BaseTextStyle.body1())),
          if (trailing != null)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(trailing,
                  style: BaseTextStyle.body2(
                      color: trailingColor ?? BaseColor.grey500)),
            ),
          if (isDirector)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: BaseIcon.base(IconPath.chevronRightLine,
                  color: BaseColor.grey500),
            ),
        ]),
      ),
    );
  }

  static Widget textField(
      {required String value,
      String? iconPath,
      required String labelText,
      required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget.title(title: labelText),
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: BaseColor.grey200),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Text(value, style: BaseTextStyle.body1())),
                if (iconPath != null)
                  Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: BaseIcon.base(iconPath, color: BaseColor.grey500)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget checkbox(
      {required String title,
      required bool isSelected,
      VoidCallback? onTap,
      Widget? prefix,
      Widget? subtitle,
      required ValueChanged<bool?> onChanged}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4.0),
        decoration: BoxDecoration(
          color: isSelected ? BaseColor.grey50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          if (prefix != null)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: prefix,
            ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: BaseTextStyle.body1()),
              if (subtitle != null)
                Padding(
                    padding: const EdgeInsets.only(top: 2.0), child: subtitle)
            ],
          )),
          CheckBoxWidget.base(onChanged: onChanged, currentValue: isSelected)
        ]),
      ),
    );
  }
}
