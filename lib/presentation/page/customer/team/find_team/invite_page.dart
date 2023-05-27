import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/domain/entity/invite/invite.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/team/controller/team_controller_cubit.dart';
import 'package:minder/presentation/bloc/team/data/find_team/find_team_cubit.dart';
import 'package:minder/presentation/bloc/team/data/teams/team_cubit.dart';
import 'package:minder/presentation/page/customer/team/find_team/swipe_team_page.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';

class InvitePage extends StatefulWidget {
  final List<Invite> invites;
  final String myTeamId;

  const InvitePage({Key? key, required this.invites, required this.myTeamId})
      : super(key: key);

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  final List<Invite> invites = List.empty(growable: true);

  @override
  void initState() {
    setState(() {
      invites.addAll(widget.invites.reversed);
    });
    GetIt.instance.get<TeamControllerCubit>().stream.listen((event) {
      if (!mounted) return;
      if (event is TeamControllerSuccessState) {
        GetIt.instance.get<TeamsCubit>().getTeams();
        GetIt.instance.get<FindTeamCubit>().getTeams(teamId: widget.myTeamId);
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
            teams: invites.map((e) => e.team!).toList(),
            cancel: (team) => accept(
                invites.firstWhere((element) => element.teamId == team.id).id,
                false),
            confirm: (team) => accept(
                invites.firstWhere((element) => element.teamId == team.id).id),
            isInvite: true));
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
        S.current.lbl_invitation,
        style: BaseTextStyle.label(),
      ),
      centerTitle: true,
    );
  }

  void accept(String id, [bool isJoin = true]) async {
    await GetIt.instance
        .get<TeamControllerCubit>()
        .accept(id: id, isJoin: isJoin);
  }
}
