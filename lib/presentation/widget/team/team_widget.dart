import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/widget/avatar/avatar_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/constant/path/image_path.dart';
import 'package:minder/util/helper/location_helper.dart';
import 'package:minder/util/helper/position_helper.dart';
import 'package:minder/util/helper/time_helper.dart';
import 'package:minder/util/style/base_style.dart';

const double teamWidgetHeight = 80.0;
const double _avatarHeight = 450.0;

class TeamWidget {
  static tile({required Team team}) {
    return Container(
      width: double.infinity,
      height: teamWidgetHeight,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
          boxShadow: [BaseShadowStyle.common]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarWidget.base(
              size: 48.0, name: team.name, imagePath: team.avatar),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                team.name,
                style: BaseTextStyle.label(color: BaseColor.green600),
              ),
              const SizedBox(
                height: 2.0,
              ),
              Row(
                children: [
                  Text(
                    S.current.txt_owner,
                    style: BaseTextStyle.caption(color: BaseColor.grey500),
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  if (team.members != null)
                    Text(
                      team.members!
                          .firstWhere((element) => element.regency == 2)
                          .user!
                          .name!,
                      style: BaseTextStyle.caption(color: BaseColor.grey900),
                    ),
                ],
              ),
            ],
          )),
          if (team.regency == 2)
            BaseIcon.base(IconPath.keyLine,
                color: BaseColor.yellow500, size: const Size(16.0, 16.0)),
          if (team.regency == 1)
            Text("C", style: BaseTextStyle.body1(color: BaseColor.red500))
        ],
      ),
    );
  }

  static card({required Team team, bool isMatch = false}) {
    String? address;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (team.gameSetting!.latitude!.floorToDouble() != 0 ||
          team.gameSetting!.longitude!.floorToDouble() != 0) {
        address = await LocationHelper.address(LatLng(
            team.gameSetting!.latitude!.toDouble(),
            team.gameSetting!.longitude!.toDouble()));
      }
    });
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          team.avatar != null
              ? Image.network(
                  team.avatar!,
                  height: _avatarHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  ImagePath.defaultCover,
                  height: _avatarHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(
                top: 24, left: 16.0, right: 16, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    team.name,
                    style: BaseTextStyle.heading1(),
                  ),
                ),
                Text(
                  team.description ?? S.current.txt_no_description,
                  style: BaseTextStyle.body1(),
                ),
                _label(S.current.lbl_number_member),
                Text(
                  "${team.members?.length ?? 1} ${(team.members?.length ?? 1) > 1 ? S.current.txt_members : S.current.txt_member}",
                  style: BaseTextStyle.body1(),
                ),
                _label(S.current.lbl_level),
                _rateBar(level: team.gameSetting?.rank?.toInt() ?? 0),
                if (!isMatch)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(S.current.lbl_invitation_position),
                      (team.gameSetting!.positions != null &&
                              team.gameSetting!.positions!.isNotEmpty)
                          ? Row(
                              children: team.gameSetting!.positions!
                                  .map((e) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: PositionHelper.mapKeyToChip(e),
                                      ))
                                  .toList(),
                            )
                          : Text(
                              S.current.txt_no_position,
                              style: BaseTextStyle.body1(),
                            ),
                    ],
                  ),
                _label(S.current.lbl_playing_area),
                Text(
                  address ?? S.current.txt_no_position,
                  style: BaseTextStyle.body1(),
                ),
                _label(S.current.lbl_match_type),
                Text(
                  team.gameSetting!.gameTypes!.join("/"),
                  style: BaseTextStyle.body1(),
                ),
                _label(S.current.lbl_playing_times),
                TimeHelper.mapTimeToWidget(team.gameSetting!.gameTime!)
              ],
            ),
          )
        ],
      ),
    );
  }

  static _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
      child: Text(
        text,
        style: BaseTextStyle.label(),
      ),
    );
  }

  static _rateBar({required int level}) {
    return Row(
        children:
            List.generate(5, (index) => _star(limit: index + 1, level: level)));
  }

  static _star({required int limit, required int level}) {
    return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: level >= limit
            ? BaseIcon.base(IconPath.starFill, color: BaseColor.yellow500)
            : BaseIcon.base(IconPath.starLine, color: BaseColor.grey300));
  }
}
