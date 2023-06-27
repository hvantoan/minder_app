import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/data/repository/implement/match_repository.dart';
import 'package:minder/domain/entity/match/match.dart' as match;
import 'package:minder/domain/entity/participant/participant.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/match/data/matches/matches_cubit.dart';
import 'package:minder/presentation/bloc/user/user_cubit.dart';
import 'package:minder/presentation/page/customer/team/all_team_page.dart';
import 'package:minder/presentation/page/customer/team/match/match_setting_page.dart';
import 'package:minder/presentation/widget/avatar/avatar_widget.dart';
import 'package:minder/presentation/widget/button/button_widget.dart';
import 'package:minder/presentation/widget/sheet/sheet_widget.dart';
import 'package:minder/presentation/widget/text/text_widget.dart';
import 'package:minder/presentation/widget/tile/tile_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/helper/match_helper.dart';
import 'package:minder/util/helper/time_helper.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_shadow_style.dart';
import 'package:minder/util/style/base_text_style.dart';

class MatchWidget extends StatefulWidget {
  final match.Match thisMatch;
  final Team team;

  const MatchWidget({super.key, required this.thisMatch, required this.team});

  @override
  State<MatchWidget> createState() => _MatchWidgetState();
}

class _MatchWidgetState extends State<MatchWidget> {
  int regency = 0;
  int status = 0;
  bool isExpand = false;
  late match.Match thisMatch;
  late Team team;
  String userId = "";

  @override
  void initState() {
    if (widget.thisMatch.status != null) {
      setState(() {
        status = widget.thisMatch.status!;
      });
    }
    if (widget.team.regency != null) {
      setState(() {
        regency = widget.team.regency!;
      });
    }

    setState(() {
      thisMatch = widget.thisMatch;
      team = widget.team;
    });

    final userState = GetIt.instance.get<UserCubit>().state;
    if (userState is UserSuccess) {
      setState(() {
        userId = userState.me!.id!;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    match.MatchTeam? host, opposite;
    if (thisMatch.teamSide == 1) {
      host = thisMatch.hostTeam!;
      opposite = thisMatch.opposingTeam!;
    } else {
      opposite = thisMatch.hostTeam!;
      host = thisMatch.opposingTeam!;
    }
    return GestureDetector(
      onTap: () => regency != 0
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MatchSettingPage(
                        match: thisMatch,
                        regency: regency,
                        teamId: team.id,
                      )))
          : {
              if (status == 2 || status == 3)
                setState(() {
                  isExpand = !isExpand;
                })
            },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
            boxShadow: [BaseShadowStyle.common]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AvatarWidget.base(
                    imagePath: opposite.avatar,
                    name: opposite.teamName!,
                    size: mediumAvatarSize),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: mediumPadding),
                    child:
                        Text(opposite.teamName!, style: BaseTextStyle.label()),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: MatchHelper.mapStatusToText(thisMatch, team.id),
                )
              ],
            ),
            if (regency == 0)
              if ((status == 2 ||
                      status == 3 ||
                      (status == 1 && (host.hasConfirm ?? true))) &&
                  thisMatch.participants!
                      .where((element) => element.userId == userId)
                      .isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ButtonWidget.secondary(
                            onTap: () {},
                            content: S.current.btn_decline,
                            buttonHeight: 32,
                            isExpand: true),
                      ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      Expanded(
                        child: ButtonWidget.primary(
                            onTap: () => MatchRepository()
                                    .memberConfirm(thisMatch.id!, userId)
                                    .then((value) async {
                                  GetIt.instance.get<MatchesCubit>().clean();
                                  await GetIt.instance
                                      .get<MatchesCubit>()
                                      .getData(widget.team.id);
                                }),
                            content: S.current.btn_join,
                            buttonHeight: 32,
                            isExpand: true),
                      )
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ButtonWidget.tertiary(
                    onTap: () {},
                    content: S.current.btn_joined,
                  ),
                ),
            if (isExpand)
              thisMatch.stadium == null ||
                      thisMatch.from == null ||
                      thisMatch.to == null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        S.current.txt_host_has_not_chosen,
                        style: BaseTextStyle.body1(color: BaseColor.grey500),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AvatarWidget.base(
                                  name: thisMatch.stadium!.name!,
                                  imagePath: thisMatch.stadium?.avatar,
                                  size: mediumAvatarSize),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        thisMatch.stadium!.name!,
                                        style: BaseTextStyle.label(),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          "${TimeHelper.formatDate(thisMatch.selectedDate.toString())} | ${thisMatch.from!.toInt() > 9 ? thisMatch.from!.toInt() : "0${thisMatch.from!.toInt()}"}:00",
                                          style: BaseTextStyle.body1(
                                            color: BaseColor.grey500,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          thisMatch.stadium!.fullAddress!,
                                          style: BaseTextStyle.body1(
                                              color: BaseColor.grey500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          if (thisMatch.participants != null &&
                              thisMatch.participants!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget.title(
                                        title: S.current.lbl_member),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 24.0),
                                      child: Text(
                                        "${thisMatch.participants!.length} ${S.current.txt_member}",
                                        style: BaseTextStyle.body1(),
                                      ),
                                    )
                                  ],
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: List.generate(
                                          thisMatch.participants?.length ?? 0,
                                          (index) {
                                    return _memberCard(
                                        participant:
                                            thisMatch.participants![index]);
                                  })),
                                ),
                              ],
                            )
                        ],
                      ),
                    )
          ],
        ),
      ),
    );
  }

  _memberCard({required Participant participant}) {
    return GestureDetector(
      onTap: () {
        SheetWidget.base(
            context: context,
            body: Wrap(children: [
              SheetWidget.title(
                  context: context,
                  title: S.current.lbl_information,
                  submitContent: S.current.btn_done,
                  onSubmit: () {
                    Navigator.pop(context);
                  }),
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                    top: 16, bottom: 32, left: 16, right: 16.0),
                child: Column(
                  children: [
                    TileWidget.common(
                        title: participant.phone ?? "",
                        isDirector: false,
                        iconPath: IconPath.phoneLine),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 16.0),
                      child: TileWidget.common(
                          title: participant.email ?? "",
                          isDirector: false,
                          iconPath: IconPath.mailLine),
                    ),
                  ],
                ),
              )
            ]));
      },
      child: Container(
        width: 48,
        margin: const EdgeInsets.only(right: 10.0),
        color: Colors.transparent,
        child: Column(
          children: [
            AvatarWidget.base(
                imagePath: participant.avatar,
                name: participant.name ?? "",
                isBorder: participant.userId == userId,
                size: mediumAvatarSize),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                participant.userId == userId
                    ? S.current.txt_you
                    : participant.name ?? "",
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
}
