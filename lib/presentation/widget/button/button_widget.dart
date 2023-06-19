import 'package:flutter/material.dart';
import 'package:minder/presentation/widget/sheet/sheet_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_style.dart';

class ButtonWidget {
  static Widget base({
    required VoidCallback onTap,
    required String content,
    String? prefixIconPath,
    String? suffixIconPath,
    double? buttonHeight,
    BoxBorder? border,
    Color? contentColor,
    Color? backgroundColor,
    BorderRadiusGeometry? borderRadius,
    bool isExpand = true,
  }) {
    if (!(prefixIconPath == null || suffixIconPath == null)) {
      return Container(
        color: Colors.red,
        padding: const EdgeInsets.all(8),
        child: Text(
          "prefixIconPath == null || suffixIconPath == null",
          style: BaseTextStyle.body2(color: Colors.white),
        ),
      );
    }
    final finalHeight = buttonHeight ?? 40;
    Widget button = Container(
        height: finalHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor ?? BaseColor.green500,
          borderRadius: borderRadius ?? BorderRadius.circular(80.0),
          border: border,
        ),
        child: Row(
            mainAxisAlignment: (suffixIconPath != null)
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              if (suffixIconPath != null) const SizedBox(width: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixIconPath != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: BaseIcon.base(prefixIconPath,
                          color: contentColor ?? Colors.white),
                    ),
                  Text(
                    content,
                    style: BaseTextStyle.label(
                        color: contentColor ?? Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (suffixIconPath != null) const SizedBox(width: 24)
                ],
              ),
              if (suffixIconPath != null)
                Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: BaseIcon.base(suffixIconPath,
                        color: contentColor ?? Colors.white)),
            ]));
    return GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [if (isExpand) Expanded(child: button) else button],
        ));
  }

  static Widget primary({
    required VoidCallback onTap,
    required String content,
    double? buttonHeight,
    String? prefixIconPath,
    bool isDirection = false,
    bool isDisable = false,
    bool isExpand = true,
  }) {
    if (!(prefixIconPath == null || isDirection == false)) {
      return Container(
        color: Colors.red,
        padding: const EdgeInsets.all(8),
        child: Text(
          "prefixIconPath == null || isDirection == false",
          style: BaseTextStyle.body2(color: Colors.white),
        ),
      );
    }
    return ButtonWidget.base(
        onTap: onTap,
        content: content,
        buttonHeight: buttonHeight,
        prefixIconPath: prefixIconPath,
        suffixIconPath: isDirection ? IconPath.chevronRightLine : null,
        contentColor: isDisable ? BaseColor.grey300 : null,
        backgroundColor: isDisable ? BaseColor.grey200 : null,
        isExpand: isExpand);
  }

  static Widget primaryWhite({
    required VoidCallback onTap,
    required String content,
    String? prefixIconPath,
    bool isDirection = false,
    bool isDisable = false,
    bool isExpand = true,
    double? buttonHeight,
  }) {
    if (!(prefixIconPath == null || isDirection == false)) {
      return Container(
        color: Colors.red,
        padding: const EdgeInsets.all(8),
        child: Text(
          "prefixIconPath == null || isDirection == false",
          style: BaseTextStyle.body2(color: Colors.white),
        ),
      );
    }
    return ButtonWidget.base(
        onTap: onTap,
        content: content,
        prefixIconPath: prefixIconPath,
        buttonHeight: buttonHeight,
        suffixIconPath: isDirection ? IconPath.chevronRightLine : null,
        contentColor: isDisable ? BaseColor.grey300 : BaseColor.green500,
        backgroundColor: isDisable ? BaseColor.grey200 : Colors.white,
        borderRadius: isExpand ? BorderRadius.circular(100.0) : null,
        border: Border.all(color: BaseColor.green500),
        isExpand: isExpand);
  }

  static Widget secondary(
      {required VoidCallback onTap,
      required String content,
      String? prefixIconPath,
      bool isDirection = false,
      bool isDisable = false,
      bool isExpand = true,
      double? buttonHeight}) {
    return ButtonWidget.base(
        onTap: onTap,
        content: content,
        prefixIconPath: prefixIconPath,
        buttonHeight: buttonHeight,
        suffixIconPath: isDirection ? IconPath.chevronRightLine : null,
        contentColor: isDisable ? BaseColor.grey400 : BaseColor.grey900,
        backgroundColor: isDisable ? BaseColor.grey200 : BaseColor.grey100,
        borderRadius: isExpand ? BorderRadius.circular(100.0) : null,
        isExpand: isExpand);
  }

  static Widget tertiary({
    required VoidCallback onTap,
    required String content,
    Color? contentColor,
    String? prefixIconPath,
    double? buttonHeight,
    bool isDirection = false,
    bool isDisable = false,
    bool isExpand = true,
  }) {
    return ButtonWidget.base(
        onTap: onTap,
        content: content,
        prefixIconPath: prefixIconPath,
        suffixIconPath: isDirection ? IconPath.chevronRightLine : null,
        contentColor:
            isDisable ? BaseColor.grey400 : contentColor ?? BaseColor.grey500,
        backgroundColor: isDisable ? BaseColor.grey200 : BaseColor.grey50,
        borderRadius: isExpand ? BorderRadius.circular(100.0) : null,
        buttonHeight: buttonHeight,
        isExpand: isExpand);
  }

  static out({
    required VoidCallback onTap,
    required String content,
    String? prefixIconPath,
    String? suffixIconPath,
    bool hasBackgroundColor = true,
    double? buttonHeight,
    bool isExpand = true,
  }) {
    if (!(prefixIconPath == null || suffixIconPath == null)) {
      return Container(
        color: Colors.red,
        padding: const EdgeInsets.all(8),
        child: Text(
          "prefixIconPath == null || suffixIconPath == null",
          style: BaseTextStyle.body2(color: Colors.white),
        ),
      );
    }
    final finalHeight = buttonHeight ?? 40;
    Widget button = Container(
        height: finalHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: hasBackgroundColor ? BaseColor.red100 : null,
          borderRadius: BorderRadius.circular(80.0),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (suffixIconPath != null) const SizedBox(width: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIconPath != null)
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 4, vertical: (finalHeight - 16) / 2),
                  child: BaseIcon.base(prefixIconPath, color: BaseColor.red500),
                ),
              Text(
                content,
                style: BaseTextStyle.label(color: BaseColor.red500),
                overflow: TextOverflow.ellipsis,
              ),
              if (suffixIconPath != null)
                Padding(
                    padding: EdgeInsets.only(
                        left: 8,
                        top: (finalHeight - 16) / 2,
                        bottom: (finalHeight - 16) / 2),
                    child:
                        BaseIcon.base(suffixIconPath, color: BaseColor.red500)),
            ],
          ),
          if (prefixIconPath != null) const SizedBox(width: 24)
        ]));
    return GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [if (isExpand) Expanded(child: button) else button],
        ));
  }

  static text(
      {required VoidCallback onTap,
      required String content,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(textButtonPadding),
        child: Text(
          content,
          style: BaseTextStyle.body1(color: BaseColor.green500),
        ),
      ),
    );
  }
}
