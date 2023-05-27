import 'package:flutter/material.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';

class SnackBarWidget {
  static base({
    required BuildContext context,
    String? title,
    String? subtitle,
    String? prefixPath,
    String? action,
    Color? backgroundColor,
    Color? color,
    bool isClosable = true,
  }) {
    double horizontalMargin = 16.0;
    return SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            bottom: 48.0, right: horizontalMargin, left: horizontalMargin),
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        content: Container(
          height: 69.0,
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
              color: backgroundColor ?? BaseColor.green100,
              borderRadius: BorderRadius.circular(8.0)),
          child: Row(
            children: [
              if (prefixPath != null)
                BaseIcon.base(prefixPath, color: color ?? BaseColor.green700),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (title != null)
                        Text(title,
                            style: BaseTextStyle.label(
                                color: color ?? BaseColor.green700)),
                      if (subtitle != null)
                        Text(subtitle,
                            style: BaseTextStyle.body2(
                                color: color ?? BaseColor.green700)),
                    ],
                  ),
                ),
              ),
              if (action != null)
                Text(action,
                    style: BaseTextStyle.body2(
                        color: color ?? BaseColor.green700)),
              if (isClosable)
                GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: BaseIcon.base(IconPath.xLine,
                        color: color ?? BaseColor.green700))
            ],
          ),
        ));
  }

  static success({
    required BuildContext context,
    String? subtitle,
    String? action,
    String? title,
    bool isClosable = true,
  }) {
    return base(
        context: context,
        title: title,
        subtitle: subtitle,
        prefixPath: IconPath.checkCircleLine,
        action: action,
        isClosable: isClosable);
  }

  static danger({
    required BuildContext context,
    String? subtitle,
    String? action,
    String? title,
    bool isClosable = true,
  }) {
    return base(
        context: context,
        subtitle: subtitle,
        title: title,
        prefixPath: IconPath.xLine,
        color: BaseColor.red700,
        backgroundColor: BaseColor.red100,
        action: action,
        isClosable: isClosable);
  }

  static waring({
    required BuildContext context,
    String? subtitle,
    String? action,
    String? title,
    bool isClosable = true,
  }) {
    return base(
        context: context,
        subtitle: subtitle,
        title: title,
        prefixPath: IconPath.warningLine,
        color: BaseColor.yellow700,
        backgroundColor: BaseColor.yellow100,
        action: action,
        isClosable: isClosable);
  }

  static info({
    required BuildContext context,
    String? subtitle,
    String? action,
    String? title,
    bool isClosable = true,
  }) {
    return base(
        context: context,
        subtitle: subtitle,
        title: title,
        prefixPath: IconPath.warningLine,
        color: BaseColor.blue700,
        backgroundColor: BaseColor.blue100,
        action: action,
        isClosable: isClosable);
  }
}
