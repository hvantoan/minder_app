import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minder/presentation/widget/button/button_widget.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_text_style.dart';

const double textButtonPadding = 12.0;

class SheetWidget {
  static base(
      {required BuildContext context, required Widget body, bool? isExpand}) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: isExpand ?? false,
        builder: (_) {
          return Container(
              width: double.infinity,
              height: isExpand ?? false
                  ? MediaQuery.of(context).size.height - 72
                  : null,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        16.0,
                      ),
                      topRight: Radius.circular(16.0))),
              child: body);
        });
  }

  static title(
      {required BuildContext context,
      required String title,
      VoidCallback? onRollback,
      String? rollbackContent,
      VoidCallback? onSubmit,
      double horizontalPadding = 16.0,
      String? submitContent}) {
    return Container(
      height: 56,
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: BaseColor.grey200)),
      ),
      padding: EdgeInsets.all(
          horizontalPadding - min(horizontalPadding, textButtonPadding)),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                rollbackContent != null
                    ? ButtonWidget.text(
                        onTap: onRollback ?? () => Navigator.pop(context),
                        content: rollbackContent,
                        context: context)
                    : const Center(),
                if (submitContent != null)
                  ButtonWidget.text(
                      onTap: onSubmit ?? () {},
                      content: submitContent,
                      context: context)
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: BaseTextStyle.label(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
