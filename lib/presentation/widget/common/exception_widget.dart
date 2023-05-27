import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minder/presentation/widget/button/button_widget.dart';
import 'package:minder/util/constant/enum/screen_mode_enum.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_grid.dart';
import 'package:minder/util/style/base_text_style.dart';

final double maxItemWidth =
    (instanceBaseGrid.screenMode == ScreenMode.mobile) ? 320 : 500;

class ExceptionWidget extends StatelessWidget {
  const ExceptionWidget({
    Key? key,
    this.content,
    required this.subContent,
    required this.imagePath,
    this.contentWidget,
    this.buttonContent,
    this.onButtonTap,
  }) : super(key: key);

  final String? content;
  final String? subContent;
  final Widget? contentWidget;
  final String imagePath;
  final String? buttonContent;
  final VoidCallback? onButtonTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: min(MediaQuery.of(context).size.width, maxItemWidth),
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Image.asset(imagePath, fit: BoxFit.fitWidth)),
              const SizedBox(height: 24),
              if (contentWidget != null)
                Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: contentWidget!),
              if (content != null)
                Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(content!,
                        textAlign: TextAlign.center,
                        style: BaseTextStyle.subtitle2())),
              if (subContent != null)
                Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(subContent!,
                        textAlign: TextAlign.center,
                        style: BaseTextStyle.body2(color: BaseColor.grey500))),
              if (onButtonTap != null && buttonContent != null)
                Container(
                    width: min(MediaQuery.of(context).size.width, maxItemWidth),
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ButtonWidget.primary(
                      onTap: onButtonTap!,
                      content: buttonContent!,
                    ))
            ]),
      ),
    );
  }
}
