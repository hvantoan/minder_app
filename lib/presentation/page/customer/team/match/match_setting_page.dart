import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minder/domain/entity/match/match.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/match/controller/match_controller_cubit.dart';
import 'package:minder/presentation/bloc/match/data/match/match_cubit.dart';
import 'package:minder/presentation/page/customer/team/all_team_page.dart';
import 'package:minder/presentation/page/customer/team/match/select_stadium_page.dart';
import 'package:minder/presentation/widget/avatar/avatar_widget.dart';
import 'package:minder/presentation/widget/button/button_widget.dart';
import 'package:minder/presentation/widget/match/time_choice_widget.dart';
import 'package:minder/presentation/widget/sheet/sheet_widget.dart';
import 'package:minder/presentation/widget/shimmer/shimmer_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/controller/loading_cover_controller.dart';
import 'package:minder/util/helper/match_helper.dart';
import 'package:minder/util/helper/time_helper.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_shadow_style.dart';
import 'package:minder/util/style/base_text_style.dart';

class MatchSettingPage extends StatefulWidget {
  final int regency;
  final Match match;
  final String teamId;

  const MatchSettingPage(
      {Key? key,
      required this.match,
      required this.regency,
      required this.teamId})
      : super(key: key);

  @override
  State<MatchSettingPage> createState() => _MatchSettingPageState();
}

class _MatchSettingPageState extends State<MatchSettingPage> {
  TimeOption? timeOption;

  @override
  void initState() {
    GetIt.instance.get<MatchCubit>().clean();
    GetIt.instance.get<MatchControllerCubit>().check(widget.match.id!);
    GetIt.instance.get<MatchControllerCubit>().stream.listen((event) async {
      if (!mounted) return;
      if (event is MatchControllerSuccess) {
        GetIt.instance.get<MatchCubit>().getMatchById(widget.match.id!);
        GetIt.instance.get<MatchControllerCubit>().clean();
        return;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    GetIt.instance.get<MatchCubit>().clean();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: BaseIcon.base(IconPath.arrowLeftLine),
      ),
      title: Text(
        S.current.lbl_match_setting,
        style: BaseTextStyle.label(),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, 1),
        child: Container(
          height: 1,
          decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: BaseColor.grey200))),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<MatchCubit, MatchState>(
      builder: (context, state) {
        changeDone();
        if (state is MatchSuccess) {
          final match = state.match;
          final opposite =
              match.teamSide == 1 ? match.opposingTeam : match.hostTeam;
          final host =
              match.teamSide == 1 ? match.hostTeam : match.opposingTeam;
          return SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: (match.status ?? 0) == 1
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            S.current.lbl_opposite_team,
                            style: BaseTextStyle.label(),
                          ),
                        ),
                        if (opposite!.stadium == null ||
                            opposite.from == null ||
                            opposite.to == null)
                          Container(
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            padding: const EdgeInsets.all(mediumPadding),
                            margin: const EdgeInsets.only(
                                top: mediumPadding + smallPadding,
                                bottom: 20.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [BaseShadowStyle.common]),
                            child: Text(
                              S.current.txt_opponent_has_not_chosen,
                              style:
                                  BaseTextStyle.body1(color: BaseColor.grey500),
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 20.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [BaseShadowStyle.common]),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AvatarWidget.base(
                                    name: opposite.stadium!.name!,
                                    imagePath: opposite.stadium!.avatar,
                                    size: mediumAvatarSize),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          opposite.stadium!.name!,
                                          style: BaseTextStyle.label(),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Text(
                                            "${TimeHelper.formatDate(opposite.date.toString())} | ${opposite.from!.toInt() > 9 ? opposite.from!.toInt() : "0${opposite.from!.toInt()}"}:00",
                                            style: BaseTextStyle.body1(
                                                color: BaseColor.grey500),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Text(
                                            opposite.stadium!.fullAddress!,
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
                          ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            S.current.lbl_your_team,
                            style: BaseTextStyle.label(),
                          ),
                        ),
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [BaseShadowStyle.common]),
                            child: (widget.regency > 0)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (host!.stadium != null)
                                        GestureDetector(
                                          onTap: () =>
                                              selectStadium(host),
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AvatarWidget.base(
                                                    name: host.stadium!.name!,
                                                    imagePath:
                                                        host.stadium!.avatar,
                                                    size: mediumAvatarSize),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          host.stadium!.name!,
                                                          style: BaseTextStyle
                                                              .label(),
                                                        ),
                                                        if (widget.regency == 0)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 2.0),
                                                            child: Text(
                                                              "${TimeHelper.formatDate(host.date.toString())} | ${host.from!.toInt() > 9 ? host.from!.toInt() : "0${host.from!.toInt()}"}:00",
                                                              style: BaseTextStyle.body1(
                                                                  color: BaseColor
                                                                      .grey500),
                                                            ),
                                                          ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 2.0),
                                                          child: Text(
                                                            host.stadium!
                                                                .fullAddress!,
                                                            style: BaseTextStyle
                                                                .body1(
                                                                    color: BaseColor
                                                                        .grey500),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      else
                                        ButtonWidget.primaryWhite(
                                            onTap: () =>
                                                selectStadium(host),
                                            content:
                                                S.current.btn_select_stadium),
                                      ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              match.timeChoices?.length ?? 0,
                                          itemBuilder: (context, index) =>
                                              TimeChoiceWidget(
                                                  timeChoice:
                                                      match.timeChoices![index],
                                                  matchId: match.id!,
                                                  team: host)),
                                    ],
                                  )
                                : (host!.stadium == null ||
                                        host.from == null ||
                                        host.to == null)
                                    ? Container(
                                        alignment: Alignment.centerLeft,
                                        width: double.infinity,
                                        padding:
                                            const EdgeInsets.all(mediumPadding),
                                        margin: const EdgeInsets.only(
                                            top: mediumPadding + smallPadding,
                                            bottom: 20.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            boxShadow: [
                                              BaseShadowStyle.common
                                            ]),
                                        child: Text(
                                          S.current.txt_host_has_not_chosen,
                                          style: BaseTextStyle.body1(
                                              color: BaseColor.grey500),
                                        ),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        margin:
                                            const EdgeInsets.only(bottom: 20.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BaseShadowStyle.common
                                            ]),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                AvatarWidget.base(
                                                    name: host.stadium!.name!,
                                                    imagePath: opposite
                                                        .stadium!.avatar,
                                                    size: mediumAvatarSize),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          host.stadium!.name!,
                                                          style: BaseTextStyle
                                                              .label(),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 2.0),
                                                          child: Text(
                                                            "${TimeHelper.formatDate(host.date.toString())} | ${host.from!.toInt() > 9 ? host.from!.toInt() : "0${host.from!.toInt()}"}:00",
                                                            style: BaseTextStyle
                                                                .body1(
                                                                    color: BaseColor
                                                                        .grey500),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 2.0),
                                                          child: Text(
                                                            host.stadium!
                                                                .fullAddress!,
                                                            style: BaseTextStyle
                                                                .body1(
                                                                    color: BaseColor
                                                                        .grey500),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ))
                      ],
                    )
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 20.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BaseShadowStyle.common]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AvatarWidget.base(
                                  name: host!.stadium!.name!,
                                  imagePath: host.stadium!.avatar,
                                  size: mediumAvatarSize),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        host.stadium!.name!,
                                        style: BaseTextStyle.label(),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          "${TimeHelper.formatDate(host.date.toString())} | ${host.from!.toInt() > 9 ? host.from!.toInt() : "0${host.from!.toInt()}"}:00",
                                          style: BaseTextStyle.body1(
                                              color: BaseColor.grey500),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          host.stadium!.fullAddress!,
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
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              (match.status ?? 0) == 2
                                  ? MatchHelper.calculateTime(
                                              host.date.toString()) ==
                                          0
                                      ? S.current.txt_match_in_progress
                                      : MatchHelper.calculateTime(
                                                  host.date.toString()) ==
                                              1
                                          ? "${S.current.txt_match_start_in} ${MatchHelper.getTime(host.date.toString())}"
                                          : S.current.txt_match_done
                                  : S.current.txt_match_cancel,
                              style: BaseTextStyle.body1(
                                  color: (match.status ?? 0) == 2
                                      ? MatchHelper.calculateTime(
                                                  host.date.toString()) >
                                              -1
                                          ? BaseColor.green500
                                          : BaseColor.grey500
                                      : BaseColor.red500),
                            ),
                          )
                        ],
                      ),
                    ));
        }
        return _shimmer();
      },
    );
  }

  Widget _shimmer() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: Column(
        children: [
          ShimmerWidget.base(
              width: double.infinity,
              height: 24,
              borderRadius: BorderRadius.circular(12.0)),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 20.0),
            child: ShimmerWidget.base(
                width: double.infinity,
                height: 80,
                borderRadius: BorderRadius.circular(12.0)),
          ),
          ShimmerWidget.base(
              width: double.infinity,
              height: 24,
              borderRadius: BorderRadius.circular(12.0)),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 20.0),
            child: ShimmerWidget.base(
                width: double.infinity,
                height: 80,
                borderRadius: BorderRadius.circular(12.0)),
          ),
        ],
      ),
    );
  }

  void selectStadium(MatchTeam team) async {
    final result = await SheetWidget.base(
        context: context,
        isExpand: true,
        body: SelectStadiumPage(
          stadium: team.stadium,
          latLng: LatLng(team.latitude!,
              team.longitude!),
        ));
    if (result != null) {
      if (mounted) GetIt.instance.get<LoadingCoverController>().on(context);
      GetIt.instance
          .get<MatchControllerCubit>()
          .selectStadium(widget.match.id!, result, team.teamId!).then((value) =>     GetIt.instance.get<MatchControllerCubit>().check(widget.match.id!));
    }
  }

  Future<void> changeDone() async {
    await Future.delayed(Duration.zero);
    if (mounted) GetIt.instance.get<LoadingCoverController>().off(context);
  }
}
