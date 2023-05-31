import 'package:flutter/material.dart';
import 'package:minder/presentation/page/customer/home/group_page.dart';
import 'package:minder/util/constant/enum/screen_mode_enum.dart';
import 'package:minder/util/style/base_style.dart';

final double maxItemWidth =
    (instanceBaseGrid.screenMode == ScreenMode.mobile) ? 320 : 500;

class PersonalHomePage extends StatelessWidget {
  const PersonalHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GroupPage();
  }
}
