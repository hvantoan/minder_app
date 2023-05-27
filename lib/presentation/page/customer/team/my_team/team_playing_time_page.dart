import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/team/controller/team_controller_cubit.dart';
import 'package:minder/presentation/bloc/user/user_cubit.dart';
import 'package:minder/presentation/page/customer/team/my_team/select_minimum_number_of_member_page.dart';
import 'package:minder/presentation/widget/sheet/sheet_widget.dart';
import 'package:minder/presentation/widget/time/time_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';

class TeamPlayingTimePage extends StatefulWidget {
  final Team team;
  final Member me;

  const TeamPlayingTimePage({Key? key, required this.me, required this.team})
      : super(key: key);

  @override
  State<TeamPlayingTimePage> createState() => _TeamPlayingTimePageState();
}

class _TeamPlayingTimePageState extends State<TeamPlayingTimePage> {
  bool isEdit = false;
  GameTime gameTime = GameTime();
  final List<GameTime> gameTimes = List.empty(growable: true);
  bool isAuto = false;
  final TextEditingController minNumberOfMemberController =
      TextEditingController();
  int? minNumberOfMember;

  @override
  void initState() {
    setState(() {
      gameTime = widget.team.gameSetting!.gameTime!;
      gameTimes.addAll(
          widget.team.members!.map((e) => e.user!.gameSetting!.gameTime!));
      isAuto = widget.team.isAutoTime ?? false;
    });
    GetIt.instance.get<TeamControllerCubit>().clear();
    GetIt.instance.get<TeamControllerCubit>().stream.listen((event) {
      if (!mounted) return;
      if (event is TeamControllerSuccessState) {
        setState(() {
          isEdit = false;
        });
        GetIt.instance.get<TeamControllerCubit>().clear();
        Navigator.popUntil(
            context, ModalRoute.withName(Navigator.defaultRouteName));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isEdit)
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Text(
                isAuto ? S.current.txt_automatic : S.current.txt_manual,
                style: BaseTextStyle.label(),
              ),
            )
          else
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        S.current.txt_automatic,
                        style: BaseTextStyle.label(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: BaseIcon.base(IconPath.informationLine,
                            color: BaseColor.grey500),
                      ),
                      const Spacer(),
                      Switch(
                          value: isAuto,
                          onChanged: (value) {
                            setState(() {
                              isAuto = value;
                            });
                          })
                    ],
                  ),
                  // if (isAuto)
                  //   Column(
                  //     children: [
                  //       Padding(
                  //         padding:
                  //             const EdgeInsets.only(top: 24.0, bottom: 8.0),
                  //         child: Row(
                  //           children: [
                  //             Text(
                  //               S.current.txt_min_number_member,
                  //               style: BaseTextStyle.label(),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.only(left: 8.0),
                  //               child: BaseIcon.base(IconPath.informationLine,
                  //                   color: BaseColor.grey500),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       TextFieldWidget.dropdown(
                  //           onTap: () => selectMinNOM(),
                  //           controller: minNumberOfMemberController,
                  //           hintText: S.current.txt_min_number_member,
                  //           context: context),
                  //     ],
                  //   ),
                ],
              ),
            ),
          Expanded(
            child: TimeWidget(
              gameTime: gameTime,
              gameTimes: gameTimes,
              isEdit: isEdit,
              onChanged: (value) {
                gameTime = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: isEdit
          ? TextButton(
              onPressed: () => setState(() {
                    isEdit = false;
                  }),
              child: Text(
                S.current.btn_cancel,
                style: BaseTextStyle.body1(),
              ))
          : IconButton(
              onPressed: () => Navigator.pop(context),
              icon: BaseIcon.base(IconPath.arrowLeftLine)),
      title: Text(
        isEdit
            ? S.current.lbl_update_playing_times
            : S.current.lbl_playing_times,
        style: BaseTextStyle.label(),
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      actions: [
        widget.me.regency > 0
            ? isEdit
                ? TextButton(
                    onPressed: () => updateGameTime(),
                    child: Text(
                      S.current.btn_done,
                      style: BaseTextStyle.body1(color: BaseColor.green500),
                    ))
                : IconButton(
                    onPressed: () =>
                        GetIt.instance.get<UserCubit>().state is UserSuccess
                            ? setState(() {
                                isEdit = true;
                              })
                            : {},
                    icon: BaseIcon.base(IconPath.pencilLine))
            : const SizedBox.shrink(),
      ],
    );
  }

  void selectMinNOM() async {
    final result = await SheetWidget.base(
        context: context,
        body: SelectMinimumNOM(
          minNumberOfMember: minNumberOfMember,
        ));
    if (result != null) {
      setState(() {
        minNumberOfMember = result;
        minNumberOfMemberController.clear();
        minNumberOfMemberController.text =
            "$result ${result > 1 ? S.current.txt_members : S.current.txt_member}";
      });
    }
  }

  void updateGameTime() {
    setState(() {
      widget.team.gameSetting?.gameTime = gameTime;
      widget.team.isAutoTime = isAuto;
    });
    GetIt.instance.get<TeamControllerCubit>().updateGameTime(widget.team);
  }
}
