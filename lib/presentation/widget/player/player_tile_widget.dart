import 'package:flutter/material.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/presentation/page/customer/team/all_team_page.dart';
import 'package:minder/presentation/widget/avatar/avatar_widget.dart';
import 'package:minder/util/style/base_style.dart';

const double playerTileHeight = 72.0;

class PlayerTileWidget {
  static base({required User user, VoidCallback? onTap, Widget? subtitle}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: playerTileHeight,
        width: double.infinity,
        padding: const EdgeInsets.all(mediumPadding),
        margin: const EdgeInsets.only(top: mediumPadding + smallPadding),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [BaseShadowStyle.common]),
        child: Row(
          children: [
            AvatarWidget.base(
                imagePath: user.avatar,
                name: user.name.toString(),
                size: mediumAvatarSize),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: mediumPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name.toString(), style: BaseTextStyle.label()),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: subtitle,
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
