import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/user/controller/user_controller_cubit.dart';
import 'package:minder/presentation/bloc/user/user_cubit.dart';
import 'package:minder/presentation/widget/common/exception_widget.dart';
import 'package:minder/presentation/widget/map/map_widget.dart';
import 'package:minder/presentation/widget/map/select_radius.dart';
import 'package:minder/presentation/widget/sheet/sheet_widget.dart';
import 'package:minder/presentation/widget/snackbar/snackbar_widget.dart';
import 'package:minder/presentation/widget/textfield/textfield_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/constant/path/image_path.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';

class PersonalPlayingAreaPage extends StatefulWidget {
  final String uid;

  const PersonalPlayingAreaPage({Key? key, required this.uid})
      : super(key: key);

  @override
  State<PersonalPlayingAreaPage> createState() =>
      _PersonalPlayingAreaPageState();
}

class _PersonalPlayingAreaPageState extends State<PersonalPlayingAreaPage> {
  LatLng? latLng;
  int initialRadius = 0;
  int radius = 0;

  bool isEdit = false;
  final TextEditingController rangeController = TextEditingController();
  bool isNear = true;

  @override
  void initState() {
    GetIt.instance.get<UserCubit>().clean();
    GetIt.instance.get<UserCubit>().getMe();
    GetIt.instance.get<UserCubit>().stream.listen((event) {
      if (!mounted) return;
      if (event is UserSuccess) {
        if ((event.me?.gameSetting?.radius?.toInt() ?? 0) != 0) {
          setState(() {
            rangeController.text =
                "${event.me!.gameSetting!.radius!.toInt()} km";
            radius = event.me!.gameSetting!.radius!.toInt();
            initialRadius = radius;
          });
        }
      }
    });
    GetIt.instance.get<UserControllerCubit>().clean();
    GetIt.instance.get<UserControllerCubit>().stream.listen((event) {
      if (!mounted) return;
      if (event is UserControllerSuccess) {
        setState(() {
          isEdit = false;
        });
        GetIt.instance.get<UserCubit>().clean();
        GetIt.instance.get<UserCubit>().getMe();
        GetIt.instance.get<UserControllerCubit>().clean();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserSuccess) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0, bottom: 8),
                        child: Row(
                          children: [
                            Text(
                              S.current.lbl_movement_range,
                              style: BaseTextStyle.label(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: BaseIcon.base(IconPath.informationLine,
                                  color: BaseColor.grey500),
                            ),
                          ],
                        ),
                      ),
                      if (!isEdit)
                        Text(
                          "$radius km",
                          style: BaseTextStyle.body1(color: BaseColor.blue500),
                        )
                      else
                        TextFieldWidget.dropdown(
                            onTap: () async {
                              final result = await SheetWidget.base(
                                  context: context,
                                  body: SelectRadius(
                                    radius,
                                  ));
                              if (result != null) {
                                setState(() {
                                  radius = result;
                                  rangeController.text = "$radius km";
                                });
                              }
                            },
                            context: context,
                            hintText: S.current.txt_hint_radius,
                            controller: rangeController),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                        child: Text(
                          S.current.lbl_playing_area,
                          style: BaseTextStyle.label(),
                        ),
                      ),
                    ],
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
                            state.me?.gameSetting?.latitude?.toDouble() ?? 0,
                            state.me?.gameSetting?.longitude?.toDouble() ?? 0);
                      });
                    }
                  },
                  isEdit: isEdit,
                  radius: radius.toDouble(),
                  latLng: LatLng(
                      state.me?.gameSetting?.latitude?.toDouble() ?? 0,
                      state.me?.gameSetting?.longitude?.toDouble() ?? 0),
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
            );
          }
          if (state is UserError) {
            return ExceptionWidget(
              subContent: S.current.txt_data_parsing_failed,
              imagePath: ImagePath.dataParsingFailed,
              buttonContent: S.current.btn_try_again,
              onButtonTap: () => GetIt.instance.get<UserCubit>().getMe(),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: isEdit
          ? TextButton(
              onPressed: () {
                setState(() {
                  isEdit = false;
                  radius = initialRadius;
                  rangeController.text = "$radius km";
                });
              },
              child: Text(
                S.current.btn_cancel,
                style: BaseTextStyle.body1(),
              ))
          : IconButton(
              onPressed: () => Navigator.pop(context),
              icon: BaseIcon.base(IconPath.arrowLeftLine)),
      title: Text(
        S.current.lbl_playing_area,
        style: BaseTextStyle.label(),
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      actions: [
        isEdit
            ? TextButton(
                onPressed: () => updateLocation(),
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
                icon: BaseIcon.base(IconPath.pencilLine)),
      ],
    );
  }

  void updateLocation() {
    if (isNear) {
      GetIt.instance.get<UserControllerCubit>().updateLocation(latLng, radius);
    }
  }
}
