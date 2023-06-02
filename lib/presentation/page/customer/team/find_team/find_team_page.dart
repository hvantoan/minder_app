import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/team/data/find_team/find_team_cubit.dart';
import 'package:minder/presentation/page/customer/team/all_team_page.dart';
import 'package:minder/presentation/page/customer/team/find_team/filter_team_page.dart';
import 'package:minder/presentation/page/customer/team/find_team/invite_page.dart';
import 'package:minder/presentation/page/customer/team/find_team/recommend_team_page.dart';
import 'package:minder/presentation/widget/common/exception_widget.dart';
import 'package:minder/presentation/widget/shimmer/shimmer_widget.dart';
import 'package:minder/presentation/widget/team/team_tile_widget.dart';
import 'package:minder/presentation/widget/team/team_widget.dart';
import 'package:minder/presentation/widget/textfield/textfield_widget.dart';
import 'package:minder/presentation/widget/tile/list_tile_widget.dart';
import 'package:minder/util/constant/enum/position_enum.dart';
import 'package:minder/util/constant/enum/weekday_enum.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/constant/path/image_path.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';
import 'package:tiengviet/tiengviet.dart';

const int _shimmerAmount = 5;

class FindTeamPage extends StatefulWidget {
  final String myTeamId;

  const FindTeamPage({Key? key, required this.myTeamId}) : super(key: key);

  @override
  State<FindTeamPage> createState() => _FindTeamPageState();
}

class _FindTeamPageState extends State<FindTeamPage> {
  int? currentRate;
  int? selectedNumberOfMembers;
  final List<int> selectedAverageAge = List.empty(growable: true);
  final List<int> selectedMatchType = List.empty(growable: true);
  final List<Position> selectedPosition = List.empty(growable: true);
  final List<Weekday> selectedWeekday = List.empty(growable: true);
  final List<int> selectedTime = List.empty(growable: true);
  bool onSearch = false;
  String currentSearchString = "";

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode()..requestFocus();

  @override
  void initState() {
    GetIt.instance.get<FindTeamCubit>().clean();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: BaseIcon.base(IconPath.arrowLeftLine)),
      titleSpacing: 0,
      title: onSearch
          ? TextFieldWidget.search(
              onChanged: (text) {
                setState(() {
                  currentSearchString = text;
                });
              },
              focusNode: searchFocusNode,
              textEditingController: searchController,
              onSuffixIconTap: () => clearSearch())
          : Text(
              S.current.lbl_find_team,
              style: BaseTextStyle.label(),
            ),
      actions: [
        if (!onSearch)
          IconButton(
              onPressed: () => setState(() {
                    onSearch = true;
                    searchFocusNode.requestFocus();
                  }),
              icon: BaseIcon.base(IconPath.searchLine)),
        IconButton(
            onPressed: () => pushFilter(),
            icon: BaseIcon.base(IconPath.filterLine)),
      ],
      centerTitle: true,
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      padding:
          const EdgeInsets.symmetric(horizontal: mediumPadding + smallPadding),
      child: BlocBuilder<FindTeamCubit, FindTeamState>(
          bloc: GetIt.instance.get<FindTeamCubit>()
            ..getTeams(teamId: widget.myTeamId),
          builder: (context, state) {
            if (state is FindTeamSuccess) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTileWidget.base(
                    title: S.current.lbl_invitation,
                    textEmpty: S.current.txt_no_team,
                    children: List.generate(
                        filterTeam(
                                teams: state.inviteTeams
                                    .map((e) => e.team!)
                                    .toList())
                            .length, (index) {
                      final team = filterTeam(
                          teams: state.inviteTeams
                              .map((e) => e.team!)
                              .toList())[index];
                      return TeamTileWidget.base(
                        team: team,
                        onTap: () {
                          final invites = state.inviteTeams;
                          final invite = invites.firstWhere(
                              (element) => element.teamId == team.id);
                          invites.remove(invite);
                          invites.insert(0, invite);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InvitePage(
                                invites: invites,
                                myTeamId: widget.myTeamId,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  ListTileWidget.base(
                    title: S.current.lbl_maybe_come_in,
                    textEmpty: S.current.txt_no_team,
                    children: List.generate(
                        filterTeam(teams: state.suggest).length, (index) {
                      final team = filterTeam(teams: state.suggest)[index];
                      return TeamTileWidget.base(
                        team: team,
                        onTap: () {
                          final teams = filterTeam(teams: state.suggest);
                          teams.remove(team);
                          teams.insert(0, team);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RecommendTeamPage(teams: teams)));
                        },
                      );
                    }),
                  ),
                ],
              );
            }
            if (state is FindTeamFailure) {
              return ExceptionWidget(
                subContent: state.message,
                imagePath: ImagePath.dataParsingFailed,
                buttonContent: S.current.btn_try_again,
                onButtonTap: () => GetIt.instance
                    .get<FindTeamCubit>()
                    .getTeams(teamId: widget.myTeamId),
              );
            }
            return _shimmer();
          }),
    );
  }

  List<Team> filterTeam({required List<Team> teams}) {
    return teams
        .where((element) =>
            TiengViet.parse(element.name)
                .toLowerCase()
                .contains(TiengViet.parse(currentSearchString).toLowerCase()) &&
            (currentRate != null
                ? element.gameSetting!.rank == currentRate
                : true) &&
            (selectedNumberOfMembers != null
                ? selectedNumberOfMembers == element.members!.length
                : true) &&
            (selectedAverageAge.isNotEmpty
                ? selectedAverageAge
                    .where((age) =>
                        _ageFilter(age, _ageCalculate(element.members!)))
                    .isNotEmpty
                : true) &&
            (selectedPosition.isNotEmpty
                ? selectedPosition
                    .where((position) =>
                        element.gameSetting!.positions!.contains(position))
                    .isNotEmpty
                : true) &&
            true &&
            (selectedMatchType.isNotEmpty
                ? selectedMatchType
                    .where((matchType) =>
                        element.gameSetting!.gameTypes!.contains(matchType))
                    .isNotEmpty
                : true) &&
            (selectedWeekday.isNotEmpty
                ? selectedWeekday
                    .where((weekday) =>
                        _weekdayFilter(weekday, element.gameSetting!))
                    .isNotEmpty
                : true) &&
            (selectedTime.isNotEmpty
                ? selectedTime
                    .where((time) =>
                        _timeFilter(time, element.gameSetting!).isNotEmpty)
                    .isNotEmpty
                : true))
        .toList();
  }

  Widget _shimmer() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: ShimmerWidget.base(
              width: double.infinity,
              height: 24.0,
              borderRadius: BorderRadius.circular(16.0)),
        ),
        ...List.generate(_shimmerAmount, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ShimmerWidget.base(
                width: double.infinity,
                height: teamWidgetHeight,
                borderRadius: BorderRadius.circular(16.0)),
          );
        }),
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: ShimmerWidget.base(
              width: double.infinity,
              height: 24.0,
              borderRadius: BorderRadius.circular(16.0)),
        ),
        ...List.generate(_shimmerAmount, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ShimmerWidget.base(
                width: double.infinity,
                height: teamWidgetHeight,
                borderRadius: BorderRadius.circular(16.0)),
          );
        })
      ],
    );
  }

  void pushFilter() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FilterTeamPage(
                  preRate: currentRate,
                  preNumberOfMembers: selectedNumberOfMembers,
                  preAverageAge: selectedAverageAge,
                  preMatchType: selectedMatchType,
                  prePosition: selectedPosition,
                  preTime: selectedTime,
                  preWeekday: selectedWeekday,
                )));
    clearFilter();
    if (result != null) {
      currentRate = result[0];
      selectedNumberOfMembers = result[1];
      selectedAverageAge.addAll(result[2]);
      selectedPosition.addAll(result[3]);
      selectedMatchType.addAll(result[5]);
      selectedWeekday.addAll(result[6]);
      selectedTime.addAll(result[7]);
    }
  }

  int _ageCalculate(List<Member> members) {
    int sum = 0;
    for (var member in members) {
      sum += member.user!.age?.toInt() ?? 0;
    }
    return sum ~/ members.length;
  }

  bool _ageFilter(int age, int averageAge) {
    if (age == 0) {
      return averageAge < 16;
    }
    if (age == 16) {
      return averageAge >= 16 && averageAge <= 25;
    }
    if (age == 25) {
      return averageAge > 25 && averageAge <= 35;
    }
    if (age == 35) {
      return averageAge > 35;
    }
    return true;
  }

  bool _weekdayFilter(Weekday weekday, GameSetting gameSetting) {
    if (weekday == Weekday.monday) {
      return gameSetting.gameTime!.monday!.isNotEmpty;
    }
    if (weekday == Weekday.tuesday) {
      return gameSetting.gameTime!.tuesday!.isNotEmpty;
    }
    if (weekday == Weekday.wednesday) {
      return gameSetting.gameTime!.wednesday!.isNotEmpty;
    }
    if (weekday == Weekday.thursday) {
      return gameSetting.gameTime!.thursday!.isNotEmpty;
    }
    if (weekday == Weekday.friday) {
      return gameSetting.gameTime!.friday!.isNotEmpty;
    }
    if (weekday == Weekday.saturday) {
      return gameSetting.gameTime!.saturday!.isNotEmpty;
    }
    if (weekday == Weekday.sunday) {
      return gameSetting.gameTime!.sunday!.isNotEmpty;
    }
    return true;
  }

  List<num> _timeFilter(int time, GameSetting gameSetting) {
    final List<num> times = List.empty(growable: true);
    if (time == 0) {
      times.addAll(
          gameSetting.gameTime!.monday!.where((element) => element <= 6));
      times.addAll(
          gameSetting.gameTime!.tuesday!.where((element) => element <= 6));
      times.addAll(
          gameSetting.gameTime!.wednesday!.where((element) => element <= 6));
      times.addAll(
          gameSetting.gameTime!.thursday!.where((element) => element <= 6));
      times.addAll(
          gameSetting.gameTime!.friday!.where((element) => element <= 6));
      times.addAll(
          gameSetting.gameTime!.saturday!.where((element) => element <= 6));
      times.addAll(
          gameSetting.gameTime!.sunday!.where((element) => element <= 6));
    }

    if (time == 6) {
      times.addAll(gameSetting.gameTime!.monday!
          .where((element) => element > 6 && element <= 12));
      times.addAll(gameSetting.gameTime!.tuesday!
          .where((element) => element > 6 && element <= 12));
      times.addAll(gameSetting.gameTime!.wednesday!
          .where((element) => element > 6 && element <= 12));
      times.addAll(gameSetting.gameTime!.thursday!
          .where((element) => element > 6 && element <= 12));
      times.addAll(gameSetting.gameTime!.friday!
          .where((element) => element > 6 && element <= 12));
      times.addAll(gameSetting.gameTime!.saturday!
          .where((element) => element > 6 && element <= 12));
      times.addAll(gameSetting.gameTime!.sunday!
          .where((element) => element > 6 && element <= 12));
    }

    if (time == 12) {
      times.addAll(gameSetting.gameTime!.monday!
          .where((element) => element > 12 && element <= 18));
      times.addAll(gameSetting.gameTime!.tuesday!
          .where((element) => element > 12 && element <= 18));
      times.addAll(gameSetting.gameTime!.wednesday!
          .where((element) => element > 12 && element <= 18));
      times.addAll(gameSetting.gameTime!.thursday!
          .where((element) => element > 12 && element <= 18));
      times.addAll(gameSetting.gameTime!.friday!
          .where((element) => element > 12 && element <= 18));
      times.addAll(gameSetting.gameTime!.saturday!
          .where((element) => element > 12 && element <= 18));
      times.addAll(gameSetting.gameTime!.sunday!
          .where((element) => element > 12 && element <= 18));
    }

    if (time == 18) {
      times.addAll(gameSetting.gameTime!.monday!
          .where((element) => element > 18 && element <= 24));
      times.addAll(gameSetting.gameTime!.tuesday!
          .where((element) => element > 18 && element <= 24));
      times.addAll(gameSetting.gameTime!.wednesday!
          .where((element) => element > 18 && element <= 24));
      times.addAll(gameSetting.gameTime!.thursday!
          .where((element) => element > 18 && element <= 24));
      times.addAll(gameSetting.gameTime!.friday!
          .where((element) => element > 18 && element <= 24));
      times.addAll(gameSetting.gameTime!.saturday!
          .where((element) => element > 18 && element <= 24));
      times.addAll(gameSetting.gameTime!.sunday!
          .where((element) => element > 18 && element <= 24));
    }

    return times;
  }

  void clearFilter() => setState(() {
        currentRate = null;
        selectedAverageAge.clear();
        selectedMatchType.clear();
        selectedNumberOfMembers = null;
        selectedTime.clear();
        selectedWeekday.clear();
        selectedPosition.clear();
      });

  void clearSearch() => setState(() {
        onSearch = false;
        searchController.clear();
        currentSearchString = "";
        searchFocusNode.unfocus();
      });
}
