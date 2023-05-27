import 'package:flutter/material.dart';
import 'package:minder/util/constant/enum/position_enum.dart';
import 'package:minder/util/helper/position_helper.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_text_style.dart';

class ChipWidget {
  static filter({
    required String content,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32.0,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        decoration: BoxDecoration(
            color: isSelected ? const Color(0xff2F974B) : Colors.white,
            border: Border.all(
                color:
                    !isSelected ? BaseColor.grey200 : const Color(0xff2F974B)),
            borderRadius: BorderRadius.circular(100)),
        child: Text(
          content,
          style: BaseTextStyle.body1(
              color: isSelected ? Colors.white : const Color(0xff5F6761)),
        ),
      ),
    );
  }

  static _base(
      {required String content,
      required Color color,
      required Color backgroundColor}) {
    return Container(
      height: 32.0,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(100)),
      child: Text(
        content,
        style: BaseTextStyle.body1(color: color),
      ),
    );
  }

  static gk() {
    return _base(
        content: PositionHelper.mapKeyToTitle(Position.gk),
        color: BaseColor.red500,
        backgroundColor: BaseColor.red100);
  }

  static st() {
    return _base(
        content: PositionHelper.mapKeyToTitle(Position.st),
        color: BaseColor.blue500,
        backgroundColor: BaseColor.blue100);
  }

  static cm() {
    return _base(
        content: PositionHelper.mapKeyToTitle(Position.cm),
        color: BaseColor.green500,
        backgroundColor: BaseColor.green100);
  }

  static cb() {
    return _base(
        content: PositionHelper.mapKeyToTitle(Position.cb),
        color: BaseColor.yellow500,
        backgroundColor: BaseColor.yellow100);
  }
}
