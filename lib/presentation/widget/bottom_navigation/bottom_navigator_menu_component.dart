import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minder/util/style/base_style.dart';

import 'customer_bottom_navigation.dart';

class BottomNavigatorMenuComponent extends StatelessWidget {
  const BottomNavigatorMenuComponent(
      {Key? key, required this.content, required this.iconPath})
      : super(key: key);

  final String content;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    final double areaWidth = MediaQuery.of(context).size.width - 60;
    return Container(
      width: areaWidth,
      alignment: Alignment.center,
      child: Container(
        width: min(areaWidth * 0.8, 400),
        height: menuItemExtent,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        margin: const EdgeInsets.only(left: 36),
        child: Row(
          children: [
            BaseIcon.base(iconPath, color: BaseColor.green500),
            const SizedBox(width: 12),
            Text(content,
                style: BaseTextStyle.label(), overflow: TextOverflow.ellipsis)
          ],
        ),
      ),
    );
  }
}
