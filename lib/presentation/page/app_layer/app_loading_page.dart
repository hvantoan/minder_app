import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minder/util/constant/constant/app_constant.dart';
import 'package:minder/util/constant/enum/screen_mode_enum.dart';
import 'package:minder/util/constant/path/image_path.dart';
import 'package:minder/util/style/base_style.dart';

final double appIconWidth =
    (instanceBaseGrid.screenMode == ScreenMode.mobile) ? 150 : 300;

class AppLoadingPage extends StatelessWidget {
  const AppLoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double backgroundElementSize = min(MediaQuery.of(context).size.height,
            MediaQuery.of(context).size.width) *
        0.7;
    return Scaffold(
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                ImagePath.topLoading,
                width: backgroundElementSize,
                fit: BoxFit.fitWidth,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                ImagePath.bottomLoading,
                width: backgroundElementSize,
                fit: BoxFit.fitWidth,
              ),
            ],
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  ImagePath.appIcon,
                  width: appIconWidth,
                  fit: BoxFit.fitWidth,
                ),
                const SizedBox(height: 8),
                Text(AppConstant.appName,
                    style: BaseTextStyle.heading2(color: BaseColor.green500)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
