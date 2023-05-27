import 'package:flutter/material.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/presentation/page/customer/team/all_team_page.dart';
import 'package:minder/presentation/widget/avatar/avatar_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_style.dart';

class TeamTileWidget {
  static base({required Team team, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 72.0,
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
                imagePath: team.avatar,
                name: team.name,
                size: mediumAvatarSize),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: mediumPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(team.name, style: BaseTextStyle.label()),
                    _rateBar(level: team.gameSetting?.rank?.toInt() ?? 0)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static _rateBar({required int level}) {
    return Container(
      margin: const EdgeInsets.only(top: 2.0),
      child: Row(
          children: List.generate(
              5, (index) => _star(limit: index + 1, level: level))),
    );
  }

  static _star({required int limit, required int level}) {
    return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: level >= limit
            ? BaseIcon.base(IconPath.starFill,
                color: BaseColor.yellow500, size: const Size(12.0, 12.0))
            : BaseIcon.base(IconPath.starLine,
                color: BaseColor.grey300, size: const Size(12.0, 12.0)));
  }
}
