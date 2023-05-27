import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/team/controller/team_controller_cubit.dart';
import 'package:minder/presentation/page/customer/team/find_team/swipe_team_page.dart';
import 'package:minder/presentation/widget/snackbar/snackbar_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';

class RecommendTeamPage extends StatefulWidget {
  final List<Team> teams;

  const RecommendTeamPage({Key? key, required this.teams}) : super(key: key);

  @override
  State<RecommendTeamPage> createState() => _RecommendTeamPageState();
}

class _RecommendTeamPageState extends State<RecommendTeamPage> {
  final List<Team> teams = List.empty(growable: true);

  @override
  void initState() {
    setState(() {
      teams.addAll(widget.teams.reversed);
    });
    GetIt.instance.get<TeamControllerCubit>().stream.listen((event) {
      if (!mounted) return;
      if (event is TeamControllerErrorState) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBarWidget.danger(
            context: context, title: event.message, isClosable: false));
        return;
      }
      if (event is TeamControllerSuccessState) {
        GetIt.instance.get<TeamControllerCubit>().clear();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: SwipeTeamPage(
            teams: teams,
            cancel: (team) {},
            confirm: (team) => join(team.id),
            isInvite: false));
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: BaseIcon.base(IconPath.arrowLeftLine)),
      titleSpacing: 0,
      title: Text(
        S.current.lbl_recommend,
        style: BaseTextStyle.label(),
      ),
      centerTitle: true,
    );
  }

  void join(String teamId) =>
      GetIt.instance.get<TeamControllerCubit>().join(teamId: teamId);
}
