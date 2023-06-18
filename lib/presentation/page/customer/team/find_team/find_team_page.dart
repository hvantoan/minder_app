import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/domain/entity/team/team.dart';
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
  const FindTeamPage({Key? key}) : super(key: key);

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
            ..find(
              pageIndex: 0,
              pageSize: 100,
            ),
          builder: (context, state) {
            if (state is FindTeamSuccess) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTileWidget.base(
                    title: S.current.lbl_invitation,
                    textEmpty: S.current.txt_no_team,
                    children: List.generate(state.inviteTeams.length, (index) {
                      var team = state.inviteTeams[index].team;
                      return TeamTileWidget.base(
                        team: team!,
                        onTap: () {
                          final invites = state.inviteTeams;
                          final invite = invites.firstWhere(
                              (element) => element.teamId == team.id);
                          invites.remove(invite);
                          invites.insert(0, invite);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      InvitePage(invites: invites)));
                        },
                      );
                    }),
                  ),
                  ListTileWidget.base(
                    title: S.current.lbl_maybe_come_in,
                    textEmpty: S.current.txt_no_team,
                    children: List.generate(state.suggest.length, (index) {
                      final team = state.suggest[index];
                      return TeamTileWidget.base(
                        team: team,
                        onTap: () {
                          final teams = state.suggest;
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
                onButtonTap: () => GetIt.instance.get<FindTeamCubit>().find(),
              );
            }
            return _shimmer();
          }),
    );
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
