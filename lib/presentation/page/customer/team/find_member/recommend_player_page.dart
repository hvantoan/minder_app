import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/team/controller/team_controller_cubit.dart';
import 'package:minder/presentation/bloc/team/data/find_member/find_member_cubit.dart';
import 'package:minder/presentation/page/customer/team/find_member/swipe_user_page.dart';
import 'package:minder/presentation/widget/snackbar/snackbar_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';

class RecommendPlayerPage extends StatefulWidget {
  final List<User> users;
  final String teamId;

  const RecommendPlayerPage(
      {Key? key, required this.users, required this.teamId})
      : super(key: key);

  @override
  State<RecommendPlayerPage> createState() => _RecommendPlayerPageState();
}

class _RecommendPlayerPageState extends State<RecommendPlayerPage> {
  final List<User> users = List.empty(growable: true);

  @override
  void initState() {
    setState(() {
      users.addAll(widget.users.reversed);
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
        GetIt.instance.get<FindMemberCubit>().getData(teamId: widget.teamId);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: SwipeUserPage(
          users: users,
          cancel: (user) => invite(user.id!, false),
          confirm: (user) => invite(user.id!, true),
          isRequest: false,
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
        S.current.lbl_players_near_you,
        style: BaseTextStyle.label(),
      ),
      centerTitle: true,
    );
  }

  void invite(String userId, bool hasInvite) => GetIt.instance
      .get<TeamControllerCubit>()
      .inviteUser(userId: userId, teamId: widget.teamId, hasInvite: hasInvite);
}
