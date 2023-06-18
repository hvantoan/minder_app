import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/team/controller/team_controller_cubit.dart';
import 'package:minder/presentation/bloc/team/data/team/team_cubit.dart';
import 'package:minder/presentation/bloc/team/data/teams/team_cubit.dart';
import 'package:minder/presentation/bloc/user/user_cubit.dart';
import 'package:minder/presentation/page/customer/team/my_team/member_info_page.dart';
import 'package:minder/presentation/page/customer/team/my_team/team_playing_area_page.dart';
import 'package:minder/presentation/page/customer/team/my_team/team_playing_time_page.dart';
import 'package:minder/presentation/page/customer/team/my_team/update_team_profile_page.dart';
import 'package:minder/presentation/widget/avatar/avatar_widget.dart';
import 'package:minder/presentation/widget/button/button_widget.dart';
import 'package:minder/presentation/widget/sheet/sheet_widget.dart';
import 'package:minder/presentation/widget/snackbar/snackbar_widget.dart';
import 'package:minder/presentation/widget/text/text_widget.dart';
import 'package:minder/presentation/widget/tile/tile_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/constant/path/image_path.dart';
import 'package:minder/util/helper/string_helper.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';

const double _coverHeight = 136.0;
const double _appBarHeight = 56.0;
const double _headerHeight = 243;
const double _memberCardSize = 48.0;

class TeamSettingPage extends StatefulWidget {
  final Team team;

  const TeamSettingPage({Key? key, required this.team}) : super(key: key);

  @override
  State<TeamSettingPage> createState() => _TeamSettingPageState();
}

class _TeamSettingPageState extends State<TeamSettingPage> {
  bool isMemberOnly = true;
  Member? me;
  final ScrollController scrollController = ScrollController();
  bool isScroll = false;
  bool isLeave = false;

  @override
  void initState() {
    GetIt.instance.get<TeamControllerCubit>().stream.listen((event) {
      if (!mounted) return;
      if (event is TeamControllerHaveTeamState) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBarWidget.danger(
            context: context,
            title: S.current.txt_cant_leave,
            isClosable: false));
        return;
      }
      if (event is TeamControllerErrorState) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBarWidget.danger(
            context: context, title: event.message, isClosable: false));
        setState(() {
          isLeave = false;
        });
        return;
      }
      if (event is TeamControllerSuccessState) {
        if (isLeave) {
          GetIt.instance.get<TeamsCubit>().getTeams();
          GetIt.instance.get<TeamControllerCubit>().clear();
          Navigator.popUntil(
              context, ModalRoute.withName(Navigator.defaultRouteName));
        }
      }
    });
    scrollController.addListener(_onScrollEvent);
    final dynamic userState = GetIt.instance.get<UserCubit>().state;
    if (userState is UserSuccess) {
      if (widget.team.members != null) {
        for (var member in widget.team.members!) {
          if (member.userId == userState.me?.id) {
            setState(() {
              me = member;
            });
          }
          if ((member.regency == 1 || member.regency == 2) &&
              member.userId == userState.me!.id) {
            setState(() {
              isMemberOnly = false;
            });
            return;
          }
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
        controller: scrollController,
        shrinkWrap: true,
        slivers: [
          buildHeader(),
          buildBody(),
        ],
      )),
    );
  }

  Widget buildHeader() {
    final Team team = widget.team;
    return SliverAppBar(
        backgroundColor: Colors.white,
        expandedHeight: _headerHeight,
        pinned: true,
        elevation: 0,
        titleSpacing: 0,
        title: isScroll
            ? Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: AvatarWidget.base(
                        name: team.name,
                        imagePath: team.avatar,
                        size: smallAvatarSize),
                  ),
                  Text("${team.name} ", style: BaseTextStyle.label()),
                  Text(
                    " (${team.code})",
                    style: BaseTextStyle.body1(),
                  ),
                ],
              )
            : null,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: BaseIcon.base(IconPath.arrowLeftLine,
                color: isScroll ? null : Colors.white)),
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          titlePadding: const EdgeInsets.only(bottom: 39.0),
          title: !isScroll
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${team.name} ", style: BaseTextStyle.label()),
                    Text(
                      " (${team.code})",
                      style: BaseTextStyle.body1(),
                    ),
                  ],
                )
              : null,
          expandedTitleScale: 1.0,
          background: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: _coverHeight,
                    child: team.cover != null
                        ? Image.network(
                            team.cover!,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            ImagePath.defaultCover,
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
              ),
              Positioned(
                  top: _coverHeight - largeAvatarSize / 2,
                  left:
                      (MediaQuery.of(context).size.width - largeAvatarSize) / 2,
                  child: AvatarWidget.base(
                      name: team.name, imagePath: team.avatar, isBorder: true)),
            ],
          ),
        ),
        bottom: isScroll
            ? null
            : PreferredSize(
                preferredSize: const Size(double.infinity, 39.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(S.current.lbl_number_of_matches,
                            style: BaseTextStyle.body1()),

                        ///TODO: change to real data
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("???", style: BaseTextStyle.body1()),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(S.current.lbl_average_age,
                            style: BaseTextStyle.body2()),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("${_average(members: team.members)}",
                              style: BaseTextStyle.body2()),
                        ),
                      ],
                    )
                  ],
                )),
        actions: [
          if (!isMemberOnly)
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UpdateTeamProfilePage(team: team))).then((value) {
                  if (GetIt.instance.get<TeamControllerCubit>().state
                      is TeamControllerSuccessState) {
                    Navigator.pop(context);
                    GetIt.instance.get<TeamControllerCubit>().clear();
                  }
                  GetIt.instance.get<TeamCubit>().getTeamById(teamId: team.id);
                });
              },
              icon: BaseIcon.base(IconPath.pencilLine,
                  color: isScroll ? null : Colors.white),
            ),
        ]);
  }

  Widget buildBody() {
    final Team team = widget.team;
    return SliverToBoxAdapter(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget.title(title: S.current.lbl_description),
                        Text(
                          team.description ?? S.current.txt_no_description,
                          style: BaseTextStyle.body1(),
                        ),
                        TextWidget.title(title: S.current.lbl_level),
                        _rateBar(
                            level: (team.gameSetting != null)
                                ? team.gameSetting!.rank!.toInt()
                                : 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget.title(title: S.current.lbl_member),
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: Text(
                                "${team.members?.length} ${S.current.txt_member}",
                                style: BaseTextStyle.body1(),
                              ),
                            )
                          ],
                        )
                      ])),
              if (team.members != null)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                      children: List.generate(team.members!.length, (index) {
                    return _memberCard(member: team.members![index]);
                  })),
                ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget.title(title: S.current.lbl_stadium_type),
                        Text(
                          StringHelper.defineStadiumType(
                                      team.gameSetting?.gameTypes)
                                  .isNotEmpty
                              ? StringHelper.defineStadiumType(
                                  team.gameSetting?.gameTypes)
                              : S.current.txt_no_stadium_type,
                          style: BaseTextStyle.body1(),
                        ),
                        TextWidget.title(title: S.current.lbl_playing_area),
                        TileWidget.common(
                            onTap: () async {
                              final isAllow = await requestLocationPermission();
                              if (isAllow) {
                                if (mounted) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TeamPlayingAreaPage(
                                                me: me!,
                                                team: team,
                                              )));
                                }
                              }
                            },
                            title: S.current.lbl_view_detail,
                            iconPath: IconPath.locationLine),
                        TextWidget.title(title: S.current.lbl_playing_times),
                        TileWidget.common(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TeamPlayingTimePage(
                                          me: me ??
                                              Member(
                                                  id: "",
                                                  userId: "",
                                                  teamId: "",
                                                  regency: 0),
                                          team: team,
                                        ))),
                            title: S.current.lbl_view_detail,
                            iconPath: IconPath.calendarLine),
                        Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: ButtonWidget.out(
                                onTap: () {
                                  leave();
                                  // if (me!.regency == 2) {
                                  //   DialogWidget.show(
                                  //       context: context,
                                  //       alert: DialogWidget.base(
                                  //           title: S
                                  //               .current.lbl_you_not_able_leave,
                                  //           subtitle: S.current
                                  //               .txt_let_grant_ownership,
                                  //           actions: [
                                  //             ButtonWidget.primary(
                                  //                 onTap: () =>
                                  //                     Navigator.pop(context),
                                  //                 content:
                                  //                     S.current.btn_cancel),
                                  //             ButtonWidget.tertiary(
                                  //                 onTap: () {
                                  //                   Navigator.pop(context);
                                  //                   Navigator.push(
                                  //                       context,
                                  //                       MaterialPageRoute(
                                  //                           builder: (context) =>
                                  //                               InformationVerificationPage(
                                  //                                   child:
                                  //                                       MemberNamePage(
                                  //                                 teamId:
                                  //                                     team.id,
                                  //                               ))));
                                  //                 },
                                  //                 content: S.current
                                  //                     .btn_select_member)
                                  //           ]));
                                  // } else {
                                  //   DialogWidget.show(
                                  //       context: context,
                                  //       alert: DialogWidget.base(
                                  //           title:
                                  //               S.current.lbl_you_want_to_leave,
                                  //           subtitle:
                                  //               S.current.txt_verify_to_leave,
                                  //           actions: [
                                  //             ButtonWidget.primary(
                                  //                 onTap: () =>
                                  //                     Navigator.pop(context),
                                  //                 content: S.current.btn_no),
                                  //             ButtonWidget.tertiary(
                                  //                 onTap: () {
                                  //                   Navigator.pop(context);
                                  //                   Navigator.push(
                                  //                       context,
                                  //                       MaterialPageRoute(
                                  //                           builder: (context) =>
                                  //                               InformationVerificationPage(
                                  //                                   child:
                                  //                                       ReLoginPage(
                                  //                                 userId:
                                  //                                     me?.userId ??
                                  //                                         "",
                                  //                               ))));
                                  //                 },
                                  //                 content: S.current.btn_verify)
                                  //           ]));
                                  // }
                                },
                                content: S.current.lbl_leave_team,
                                suffixIconPath: IconPath.signOutRegular))
                      ])),
            ],
          ),
        ),
      ),
    );
  }

  _rateBar({required int level}) {
    return Row(
        children:
            List.generate(5, (index) => _star(limit: index + 1, level: level)));
  }

  _star({required int limit, required int level}) {
    return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: level >= limit
            ? BaseIcon.base(IconPath.starFill, color: BaseColor.yellow500)
            : BaseIcon.base(IconPath.starLine, color: BaseColor.grey300));
  }

  _memberCard({required Member member}) {
    return GestureDetector(
      onTap: () {
        SheetWidget.base(
            context: context,
            body: MemberInfoPage(
              member: member,
              me: me!,
            ));
      },
      child: Container(
        width: _memberCardSize,
        margin: const EdgeInsets.only(right: 10.0),
        color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(
              height: _memberCardSize,
              child: Stack(
                children: [
                  AvatarWidget.base(
                      imagePath: member.user!.avatar,
                      name: member.user!.name!,
                      isBorder: member.userId == me?.userId,
                      size: mediumAvatarSize),
                  if (member.regency == 1)
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 16.0,
                        width: 16.0,
                        padding: const EdgeInsets.all(2.0),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: BaseColor.grey600),
                        child: Text("C",
                            style:
                                BaseTextStyle.caption(color: BaseColor.red500)),
                      ),
                    ),
                  if (member.regency == 2)
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                          height: 16.0,
                          width: 16.0,
                          padding: const EdgeInsets.all(2.0),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: BaseColor.grey600),
                          child: BaseIcon.base(IconPath.keyLine,
                              color: BaseColor.yellow500)),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                member.userId == me?.userId
                    ? S.current.txt_you
                    : member.user!.name!,
                style: BaseTextStyle.caption(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  _average({List<Member>? members}) {
    num avgAge = 0;
    if (members != null) {
      for (var element in members) {
        avgAge += element.user!.age ?? 0;
      }
      avgAge ~/= members.length;
    }
    return avgAge;
  }

  void _onScrollEvent() {
    final pixels = scrollController.position.pixels;
    if (pixels > _appBarHeight * 2) {
      setState(() {
        isScroll = true;
      });
    } else {
      setState(() {
        isScroll = false;
      });
    }
  }

  void leave() async {
    await GetIt.instance
        .get<TeamControllerCubit>()
        .leave(teamId: widget.team.id);
    setState(() {
      isLeave = true;
    });
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
