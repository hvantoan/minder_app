import 'package:flutter/material.dart';
import 'package:minder/util/style/base_style.dart';

class DialogWidget {
  static show({required BuildContext context, required Widget alert}) {
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  static base({String? title, String? subtitle, List<Widget>? actions}) {
    return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        backgroundColor: Colors.white,
        titlePadding: const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
        title: title != null
            ? Text(
                title,
                style: BaseTextStyle.subtitle2(),
                textAlign: TextAlign.center,
              )
            : null,
        contentPadding: const EdgeInsets.only(
            top: 4.0, left: 16.0, right: 16.0, bottom: 24.0),
        content: subtitle != null
            ? Text(
                subtitle,
                style: BaseTextStyle.body1(color: BaseColor.grey400),
                textAlign: TextAlign.center,
              )
            : null,
        actionsPadding:
            const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        actions: actions != null
            ? List.generate(actions.length, (index) {
                return Padding(
                  padding: index > 0
                      ? const EdgeInsets.only(top: 4.0)
                      : EdgeInsets.zero,
                  child: actions[index],
                );
              })
            : null);
  }
}
