import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/team/controller/team_controller_cubit.dart';
import 'package:minder/presentation/page/customer/team/my_team/select_minimum_number_of_member_page.dart';
import 'package:minder/presentation/widget/map/map_widget.dart';
import 'package:minder/presentation/widget/sheet/sheet_widget.dart';
import 'package:minder/presentation/widget/snackbar/snackbar_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';

class TeamPlayingAreaPage extends StatefulWidget {
  final Team team;
  final Member me;

  const TeamPlayingAreaPage({Key? key, required this.team, required this.me})
      : super(key: key);

  @override
  State<TeamPlayingAreaPage> createState() => _TeamPlayingAreaPageState();
}

class _TeamPlayingAreaPageState extends State<TeamPlayingAreaPage> {
  bool isEdit = false;
  bool isAuto = false;
  final TextEditingController minNumberOfMemberController =
      TextEditingController();
  int? minNumberOfMember;
  LatLng? latLng;
  bool isNear = true;

  @override
  void initState() {
    setState(() {
      isAuto = widget.team.isAutoLocation ?? false;
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
                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
              child: Text(
                isAuto ? S.current.txt_automatic : S.current.txt_manual,
                style: BaseTextStyle.label(),
              ),
            )
          else
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
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
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Text(
              S.current.lbl_choose_location,
              style: BaseTextStyle.label(),
            ),
          ),
          MapWidget(
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  latLng = value;
                });
              } else {
                setState(() {
                  latLng = LatLng(
                      widget.team.gameSetting?.latitude?.toDouble() ?? 0,
                      widget.team.gameSetting?.longitude?.toDouble() ?? 0);
                });
              }
            },
            isEdit: isEdit,
            radius: (widget.team.gameSetting?.radius?.toDouble() ?? 0) == 0
                ? 5
                : widget.team.gameSetting?.radius?.toDouble() ?? 0,
            latLng: LatLng(widget.team.gameSetting?.latitude?.toDouble() ?? 0,
                widget.team.gameSetting?.longitude?.toDouble() ?? 0),
            isNearByStadium: (value) {
              setState(() {
                isNear = value;
              });
              if (!isNear) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBarWidget.danger(
                        context: context,
                        title: S.current.txt_not_have_stadium_match,
                        isClosable: false));
              }
            },
          )
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
        isEdit ? S.current.lbl_update_playing_area : S.current.lbl_playing_area,
        style: BaseTextStyle.label(),
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      actions: [
        widget.me.regency > 0
            ? isEdit
                ? TextButton(
                    onPressed: () => updateLocation(),
                    child: Text(
                      S.current.btn_done,
                      style: BaseTextStyle.body1(color: BaseColor.green500),
                    ))
                : IconButton(
                    onPressed: () => setState(() {
                          isEdit = true;
                        }),
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

  void updateLocation() {
    setState(() {
      widget.team.isAutoLocation = isAuto;
      if (latLng != null) {
        widget.team.gameSetting!.latitude = latLng!.latitude;
        widget.team.gameSetting!.longitude = latLng!.longitude;
      }
      GetIt.instance.get<TeamControllerCubit>().updateLocation(widget.team);
    });
  }
}
