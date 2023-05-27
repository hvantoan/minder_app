import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/data/model/personal/user_dto.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/authentication_layer/authentication_layer_cubit.dart';
import 'package:minder/presentation/bloc/user/user_cubit.dart';
import 'package:minder/presentation/page/customer/settings/change_language_page.dart';
import 'package:minder/presentation/page/customer/settings/personal_playing_area_page.dart';
import 'package:minder/presentation/page/customer/settings/personal_playing_time_page.dart';
import 'package:minder/presentation/page/customer/settings/personal_profile_page.dart';
import 'package:minder/presentation/widget/avatar/avatar_widget.dart';
import 'package:minder/presentation/widget/bottom_navigation/customer_bottom_navigation.dart';
import 'package:minder/presentation/widget/bottom_sheet_component/bottom_sheet_components.dart';
import 'package:minder/presentation/widget/button/button_widget.dart';
import 'package:minder/presentation/widget/sheet/sheet_widget.dart';
import 'package:minder/presentation/widget/tile/tile_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_style.dart';

class PersonalSettingsPage extends StatefulWidget {
  const PersonalSettingsPage({Key? key}) : super(key: key);

  @override
  State<PersonalSettingsPage> createState() => _PersonalSettingsPageState();
}

class _PersonalSettingsPageState extends State<PersonalSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      bloc: GetIt.instance.get<UserCubit>()..getMe(),
      builder: (context, state) {
        if (state is UserSuccess) {
          return buildBody(user: state.user!, context: context);
        }
        return buildBody(user: UserDto(), context: context);
      },
    );
  }

  Widget buildBody({required UserDto user, required BuildContext context}) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: instanceBaseGrid.margin),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 24 + MediaQuery.of(context).padding.top),
              buildAvatar(user: user),
              const SizedBox(height: 24),
              buildProfile(),
              const SizedBox(height: 24),
              buildMatch(user: user),
              const SizedBox(height: 24),
              buildSystem(),
              const SizedBox(height: 24),
              buildSupport(),
              const SizedBox(height: 24),
              buildLogout(context),
              const SizedBox(height: contentBottomPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAvatar({required UserDto user}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AvatarWidget.base(
            imagePath: user.avatar, name: user.name ?? "User", isBorder: true),
        const SizedBox(height: 8),
        Text(user.name ?? "User", style: BaseTextStyle.label()),
      ],
    );
  }

  Widget buildProfile() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PersonalProfilePage()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(S.current.lbl_personal, style: BaseTextStyle.label()),
          const SizedBox(height: 16),
          TileWidget.common(
              title: S.current.lbl_personal_profile,
              iconPath: IconPath.userLine),
        ],
      ),
    );
  }

  Widget buildMatch({required UserDto user}) {
    String displayGameType = "";
    if (user.gameSetting != null) {
      user.gameSetting?.gameTypes?.forEach((element) {
        if (displayGameType.isEmpty) {
          displayGameType += "$element";
        } else {
          displayGameType += "/$element";
        }
      });
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(S.current.lbl_match, style: BaseTextStyle.label()),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            BottomSheetComponents.settingStadiumType(
              context: context,
              onSuccess: (value) {
                user.gameSetting?.gameTypes = value;
              },
              types: user.gameSetting?.gameTypes ?? [],
            );
          },
          child: TileWidget.common(
              title: S.current.lbl_stadium_type,
              iconPath: IconPath.playgroundLine,
              trailing: displayGameType,
              isDirector: false),
        ),
        const SizedBox(height: 16),
        TileWidget.common(
            onTap: () async {
              final isAllow = await requestLocationPermission();
              if (isAllow) {
                if (mounted) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PersonalPlayingAreaPage(uid: user.id!)));
                }
              }
            },
            title: S.current.lbl_playing_area,
            iconPath: IconPath.locationLine),
        const SizedBox(height: 16),
        TileWidget.common(
            title: S.current.lbl_playing_times,
            iconPath: IconPath.timeLine,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PersonalPlayingTimePage(
                        uid: user.id!,
                        gameTime: user.gameSetting!.gameTime!.toGameTime()!)))),
      ],
    );
  }

  Widget buildSystem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(S.current.lbl_system, style: BaseTextStyle.label()),
        const SizedBox(height: 16),
        TileWidget.common(
            title: S.current.lbl_notification,
            iconPath: IconPath.notificationLine),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => SheetWidget.base(
              context: context, body: const ChangeLanguagePage()),
          child: TileWidget.common(
            title: S.current.lbl_language,
            iconPath: IconPath.earthLine,
            trailing: S.current.txt_language,
            isDirector: false,
          ),
        ),
        const SizedBox(height: 16),
        TileWidget.common(
          title: S.current.lbl_version,
          iconPath: IconPath.cellphoneLine,
          trailing: "v1.0.0",
          isDirector: false,
        ),
      ],
    );
  }

  Widget buildSupport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(S.current.lbl_support, style: BaseTextStyle.label()),
        const SizedBox(height: 16),
        TileWidget.common(
            title: S.current.lbl_about_us, iconPath: IconPath.informationLine),
        const SizedBox(height: 16),
        TileWidget.common(
            title: S.current.lbl_contact,
            iconPath: IconPath.serviceLine,
            trailing: "0374171617",
            trailingColor: BaseColor.red500,
            isDirector: false),
      ],
    );
  }

  Widget buildLogout(BuildContext context) {
    return Center(
      child: ButtonWidget.primary(
          onTap: () {
            GetIt.instance.get<AuthenticationLayerCubit>().logout(context);
          },
          content: S.current.btn_logout),
    );
  }

  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      permission = await Geolocator.requestPermission();
    }

    if (permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever &&
        permission != LocationPermission.unableToDetermine) {
      return true;
    }
    return false;
  }
}
