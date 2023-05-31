import 'package:flutter/material.dart';
import 'package:minder/domain/entity/match/match.dart' as match;
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/presentation/page/customer/team/all_team_page.dart';
import 'package:minder/presentation/page/customer/team/match/match_setting_page.dart';
import 'package:minder/presentation/widget/avatar/avatar_widget.dart';
import 'package:minder/util/helper/match_helper.dart';
import 'package:minder/util/style/base_shadow_style.dart';
import 'package:minder/util/style/base_text_style.dart';

class MatchWidget {
  static Widget base(match.Match match, BuildContext context, Team team) {
    return GestureDetector(
      onTap: () => (match.status ?? 0) != 0
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MatchSettingPage(
                        match: match,
                        regency: team.regency!,
                        teamId: team.id,
                      )))
          : {},
      child: Container(
        width: double.infinity,
        height: 72.0,
        margin: const EdgeInsets.only(bottom: 20.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
            boxShadow: [BaseShadowStyle.common]),
        child: Row(
          children: [
            AvatarWidget.base(
                imagePath: match.teamSide == 1
                    ? match.opposingTeam!.avatar
                    : match.hostTeam!.avatar,
                name: match.teamSide == 1
                    ? match.opposingTeam!.teamName!
                    : match.hostTeam!.teamName!,
                size: mediumAvatarSize),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: mediumPadding),
                child: Text(
                    match.teamSide == 1
                        ? match.opposingTeam!.teamName!
                        : match.hostTeam!.teamName!,
                    style: BaseTextStyle.label()),
              ),
            ),
            MatchHelper.mapStatusToText(match, team.id)
          ],
        ),
      ),
    );
  }
}
