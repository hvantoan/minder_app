import 'package:flutter/material.dart';
import 'package:minder/util/helper/string_helper.dart';
import 'package:minder/util/style/base_style.dart';

const double extraSmallAvatarSize = 24;
const double smallAvatarSize = 32;
const double mediumAvatarSize = 48;
const double largeAvatarSize = 80;

class AvatarWidget {
  static Widget base({
    String? imagePath,
    double? size,
    String name = "",
    bool isBorder = false,
  }) {
    final finalSize = size ?? largeAvatarSize;
    return Container(
        height: finalSize,
        width: finalSize,
        padding: EdgeInsets.all(isBorder ? (finalSize ~/ 30).toDouble() : 0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: isBorder ? Border.all(color: BaseColor.green400) : null),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                height: finalSize,
                width: finalSize,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: BaseColor.grey200),
                child: Text(StringHelper.createNameKey(name),
                    style: BaseTextStyle.label()
                        .copyWith(fontSize: finalSize / 3))),
            if (imagePath != null && imagePath.isNotEmpty)
              Container(
                height: finalSize,
                width: finalSize,
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: BaseColor.grey200)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(largeAvatarSize),
                  child: Image.network(imagePath, fit: BoxFit.cover),
                ),
              ),
          ],
        ));
  }
}
