import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/match/controller/match_controller_cubit.dart';
import 'package:minder/presentation/bloc/match/data/matches/matches_cubit.dart';
import 'package:minder/presentation/bloc/team/data/find_team/find_team_cubit.dart';
import 'package:minder/presentation/page/customer/team/match/swipe_match_team_page.dart';
import 'package:minder/presentation/widget/button/button_widget.dart';
import 'package:minder/presentation/widget/common/exception_widget.dart';
import 'package:minder/presentation/widget/match/match_widget.dart';
import 'package:minder/presentation/widget/player/player_tile_widget.dart';
import 'package:minder/presentation/widget/shimmer/shimmer_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/constant/path/image_path.dart';
import 'package:minder/util/style/base_text_style.dart';

class MatchTeamPage extends StatefulWidget {
  final Team team;
  final int regency;
  final bool isScroll;

  const MatchTeamPage(
      {Key? key,
      required this.regency,
      required this.team,
      required this.isScroll})
      : super(key: key);

  @override
  State<MatchTeamPage> createState() => _MatchTeamPageState();
}

class _MatchTeamPageState extends State<MatchTeamPage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    setState(() {
      widget.team.regency = widget.regency;
    });
    GetIt.instance.get<MatchesCubit>().clean();
    GetIt.instance.get<MatchesCubit>().getData(widget.team.id);
    GetIt.instance.get<MatchControllerCubit>().clean();
    GetIt.instance.get<MatchControllerCubit>().stream.listen((event) {
      if (!mounted) return;
      if (event is MatchControllerSuccess) {
        GetIt.instance.get<MatchControllerCubit>().clean();
        GetIt.instance.get<MatchesCubit>().getData(widget.team.id);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: widget.isScroll
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: BlocBuilder<MatchesCubit, MatchesState>(
        builder: (context, state) {
          if (state is MatchesSuccess) {
            return Column(
              children: [
                if (widget.regency > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ButtonWidget.primaryWhite(
                        onTap: () => findMoreTeams(),
                        content: S.current.btn_find_more_teams,
                        prefixIconPath: IconPath.searchLine),
                  ),
                if (state.matches.isNotEmpty)
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.matches.length,
                      itemBuilder: (context, index) => MatchWidget.base(
                          state.matches[index], context, widget.team))
                else
                  Center(
                    child: Text(
                      S.current.txt_no_match,
                      style: BaseTextStyle.body1(),
                    ),
                  ),
              ],
            );
          }
          if (state is MatchesFailure) {
            return ExceptionWidget(
              subContent: S.current.txt_data_parsing_failed,
              imagePath: ImagePath.dataParsingFailed,
              buttonContent: S.current.btn_try_again,
              onButtonTap: () => GetIt.instance.get<MatchesCubit>()
                ..clean()
                ..getData(widget.team.id),
            );
          }
          return _shimmer();
        },
      ),
    );
  }

  Widget _shimmer() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: ShimmerWidget.base(
              width: double.infinity,
              height: 40.0,
              borderRadius: BorderRadius.circular(80.0)),
        ),
        ...List.generate(10, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ShimmerWidget.base(
                width: double.infinity,
                height: playerTileHeight,
                borderRadius: BorderRadius.circular(16.0)),
          );
        }),
      ],
    );
  }

  void findMoreTeams() {
    GetIt.instance.get<FindTeamCubit>().clean();
    GetIt.instance.get<FindTeamCubit>().getTeams(teamId: widget.team.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocBuilder<FindTeamCubit, FindTeamState>(
          builder: (context, state) {
            if (state is FindTeamSuccess) {
              return FindMoreTeamPage(
                  teams: state.suggest,
                  cancel: (team) => swipe(false, team),
                  confirm: (team) => swipe(true, team));
            }

            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }

  void swipe(bool hasInvite, Team team) {
    GetIt.instance
        .get<MatchControllerCubit>()
        .swipe(widget.team.id, team.id, hasInvite);
  }
}
