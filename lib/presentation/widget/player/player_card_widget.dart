import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/constant/path/image_path.dart';
import 'package:minder/util/helper/age_helper.dart';
import 'package:minder/util/helper/gender_helper.dart';
import 'package:minder/util/helper/location_helper.dart';
import 'package:minder/util/helper/position_helper.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';

const double _avatarHeight = 450.0;

class PlayerCardWidget {
  static card(User user) {
    String? address;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      address = await LocationHelper.address(LatLng(
          user.gameSetting!.latitude!.toDouble(),
          user.gameSetting!.longitude!.toDouble()));
    });
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          user.avatar != null
              ? Image.network(
                  user.avatar!,
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
                top: 20, left: 16.0, right: 16, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    "${user.name!}, ${AgeHelper.calculate(user.dayOfBirth)}",
                    style: BaseTextStyle.heading1(),
                  ),
                ),
                Text(
                  user.description ?? S.current.txt_no_description,
                  style: BaseTextStyle.body1(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: (user.gameSetting!.positions != null &&
                          user.gameSetting!.positions!.isNotEmpty)
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: user.gameSetting!.positions!
                                .map((e) => Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: PositionHelper.mapKeyToChip(e),
                                    ))
                                .toList(),
                          ),
                        )
                      : Text(
                          S.current.txt_no_position,
                          style: BaseTextStyle.body1(),
                        ),
                ),
                Row(
                  children: [
                    Image.asset(
                      ImagePath.genderIntersex,
                      width: 24.0,
                      height: 24.0,
                      fit: BoxFit.contain,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        GenderHelper.mapKeyToName(user.sex!),
                        style: BaseTextStyle.body1(),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    children: [
                      BaseIcon.base(IconPath.locationLine),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          address ?? S.current.txt_no_position,
                          style: BaseTextStyle.body1(),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
