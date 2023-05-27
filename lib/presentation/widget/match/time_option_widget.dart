import 'package:flutter/material.dart';
import 'package:minder/domain/entity/match/match.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';

class TimeOptionWidget {
  static base(TimeOption timeOption, bool isSelected, VoidCallback? onTap) {
    final bool isValid = (timeOption.memberCount ?? 0) > 5;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 40,
        margin: const EdgeInsets.only(top: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: isSelected
                ? BaseColor.green500
                : (isValid ? Colors.white : BaseColor.grey100),
            border: isValid ? Border.all(color: BaseColor.grey200) : null),
        child: Row(
          children: [
            Expanded(
              child: Text(
                timeOption.displayTime ?? "",
                style: BaseTextStyle.body1(
                    color: isSelected
                        ? Colors.white
                        : (isValid ? null : BaseColor.grey500)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: Text(
                timeOption.memberCount?.toString() ?? "",
                style: BaseTextStyle.body1(
                    color: isSelected
                        ? Colors.white
                        : (isValid ? null : BaseColor.grey500)),
              ),
            ),
            BaseIcon.base(IconPath.userLine,
                color: isSelected
                    ? Colors.white
                    : (isValid ? null : BaseColor.grey500))
          ],
        ),
      ),
    );
  }
}
