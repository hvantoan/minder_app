import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/util/constant/enum/screen_mode_enum.dart';
import 'package:minder/util/style/base_style.dart';

final double maxItemWidth =
    (instanceBaseGrid.screenMode == ScreenMode.mobile) ? 320 : 500;

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: min(MediaQuery.of(context).size.width, maxItemWidth),
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: Image.asset("assets/images/common/no_mail.png",
                    fit: BoxFit.fitWidth)),
            Text(S.current.txt_no_notification,
                style: BaseTextStyle.body1(color: BaseColor.grey500)),
            const SizedBox(height: 64)
          ],
        ),
      ),
    );
  }
}
