import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/team/data/teams/team_cubit.dart';
import 'package:minder/presentation/bloc/team/data/teams/team_state.dart';
import 'package:minder/presentation/page/customer/team/create_team_page.dart';
import 'package:minder/presentation/page/customer/team/find_team/find_team_page.dart';
import 'package:minder/presentation/page/customer/team/my_team/team_detail_page.dart';
import 'package:minder/presentation/widget/button/button_widget.dart';
import 'package:minder/presentation/widget/common/exception_widget.dart';
import 'package:minder/presentation/widget/shimmer/shimmer_widget.dart';
import 'package:minder/presentation/widget/team/team_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/constant/path/image_path.dart';
import 'package:minder/util/style/base_style.dart';

const double teamImageSize = 192.0;
const double smallPadding = 4.0;
const double mediumPadding = 12.0;
const double largePadding = 24.0;

class AllTeamPage extends StatefulWidget {
  const AllTeamPage({Key? key}) : super(key: key);

  @override
  State<AllTeamPage> createState() => _AllTeamPageState();
}

class _AllTeamPageState extends State<AllTeamPage> {
  bool isMemberOnly = true;
  String myTeamId = "";

  @override
  void initState() {
    GetIt.instance.get<TeamsCubit>().clean();
    GetIt.instance.get<TeamsCubit>().getTeams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: BlocBuilder<TeamsCubit, TeamsState>(
        builder: (context, state) {
          if (state is TeamsSuccessState) {
            if (state.teams.isNotEmpty) {
              return _listState(teams: state.teams);
            }
            return _emptyState();
          }
          if (state is TeamsErrorState) {
            return ExceptionWidget(
              subContent: state.message,
              imagePath: ImagePath.dataParsingFailed,
              buttonContent: S.current.btn_try_again,
              onButtonTap: () => GetIt.instance.get<TeamsCubit>().getTeams(),
            );
          }
          return _shimmer();
        },
      )),
    );
  }

  Widget _emptyState() {
    final double overlayHeight = MediaQuery.of(context).padding.top;
    return Container(
      height: MediaQuery.of(context).size.height - overlayHeight,
      padding: const EdgeInsets.symmetric(horizontal: largePadding * 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImagePath.team,
            width: teamImageSize,
            height: teamImageSize,
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: largePadding, bottom: smallPadding),
            child: Text(S.current.lbl_have_no_team,
                style: BaseTextStyle.subtitle2(color: const Color(0xff070707))),
          ),
          Text(
            S.current.txt_create_team_and_join,
            style: BaseTextStyle.body1(color: BaseColor.grey500),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(top: largePadding),
            child: _buttonArea(),
          )
        ],
      ),
    );
  }

  Widget _listState({required List<Team> teams}) {
    final double overlayHeight = MediaQuery.of(context).padding.top;
    final double bottomInsets = MediaQuery.of(context).viewPadding.bottom;
    return SingleChildScrollView(
      padding: EdgeInsets.only(
          top: overlayHeight + mediumPadding + smallPadding,
          left: mediumPadding + smallPadding,
          right: mediumPadding + smallPadding,
          bottom: bottomInsets + largePadding * 4),
      child: Column(
        children: [
          ...List.generate(teams.length, (index) {
            if ((teams[index].regency ?? 0) > 0) {
              isMemberOnly = false;
            }
            if ((teams[index].regency ?? 0) == 2) {
              myTeamId = teams[index].id;
            }
            return GestureDetector(
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TeamDetailPage(
                              teamId: teams[index].id,
                              regency: teams[index].regency ?? 0,
                            )));
                GetIt.instance.get<TeamsCubit>().getTeams();
              },
              child: TeamWidget.tile(team: teams[index]),
            );
          }),
          Padding(
            padding: const EdgeInsets.only(top: smallPadding * 2),
            child: _buttonArea(),
          )
        ],
      ),
    );
  }

  Widget _shimmer() {
    final double overlayHeight = MediaQuery.of(context).padding.top;
    final double bottomInsets = MediaQuery.of(context).viewPadding.bottom;
    return SingleChildScrollView(
      padding: EdgeInsets.only(
          top: overlayHeight + mediumPadding + smallPadding,
          left: mediumPadding + smallPadding,
          right: mediumPadding + smallPadding,
          bottom: bottomInsets + largePadding * 4),
      child: Column(
        children: [
          ...List.generate(10, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ShimmerWidget.base(
                  width: double.infinity,
                  height: teamWidgetHeight,
                  borderRadius: BorderRadius.circular(16.0)),
            );
          })
        ],
      ),
    );
  }

  Widget _buttonArea() {
    return Column(
      children: [
        if (isMemberOnly)
          Padding(
            padding: const EdgeInsets.only(bottom: mediumPadding),
            child: ButtonWidget.primaryWhite(
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateTeamPage()));
                  GetIt.instance.get<TeamsCubit>().getTeams();
                },
                content: S.current.btn_create_team,
                prefixIconPath: IconPath.addLine),
          ),
        ButtonWidget.primary(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FindTeamPage(
                          myTeamId: myTeamId,
                        ))),
            content: S.current.btn_find_team,
            prefixIconPath: IconPath.searchLine),
      ],
    );
  }
}
