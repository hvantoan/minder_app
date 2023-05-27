import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/domain/entity/invite/invite.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/team/controller/team_controller_cubit.dart';
import 'package:minder/presentation/bloc/team/data/team/team_cubit.dart';
import 'package:minder/presentation/page/customer/team/find_member/swipe_user_page.dart';
import 'package:minder/presentation/widget/snackbar/snackbar_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';

class RequestJoinPage extends StatefulWidget {
  final List<Invite> invites;

  const RequestJoinPage({Key? key, required this.invites}) : super(key: key);

  @override
  State<RequestJoinPage> createState() => _RequestJoinPageState();
}

class _RequestJoinPageState extends State<RequestJoinPage> {
  final List<Invite> invites = List.empty(growable: true);

  @override
  void initState() {
    setState(() {
      invites.addAll(widget.invites.reversed);
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

    GetIt.instance.get<TeamControllerCubit>().stream.listen((event) {
      if (!mounted) return;
      if (event is TeamControllerSuccessState) {
        GetIt.instance.get<TeamCubit>().clean();
        GetIt.instance
            .get<TeamCubit>()
            .getTeamById(teamId: widget.invites.first.teamId);
        GetIt.instance.get<TeamControllerCubit>().clear();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: SwipeUserPage(
          users: invites.map((e) => e.user!).toList(),
          cancel: (user) => accept(
              invites.firstWhere((element) => element.userId == user.id),
              false),
          confirm: (user) => accept(
              invites.firstWhere((element) => element.userId == user.id)),
          isRequest: true,
        ));
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
        S.current.lbl_want_to_join,
        style: BaseTextStyle.label(),
      ),
      centerTitle: true,
    );
  }

  void accept(Invite invite, [bool isJoin = true]) async {
    await GetIt.instance
        .get<TeamControllerCubit>()
        .accept(id: invite.id, isJoin: isJoin);
  }
}
