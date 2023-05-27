import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/user/controller/user_controller_cubit.dart';
import 'package:minder/presentation/bloc/user/user_cubit.dart';
import 'package:minder/presentation/widget/common/exception_widget.dart';
import 'package:minder/presentation/widget/time/time_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/constant/path/image_path.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';

class PersonalPlayingTimePage extends StatefulWidget {
  final String uid;
  final GameTime gameTime;

  const PersonalPlayingTimePage(
      {Key? key, required this.gameTime, required this.uid})
      : super(key: key);

  @override
  State<PersonalPlayingTimePage> createState() =>
      _PersonalPlayingTimePageState();
}

class _PersonalPlayingTimePageState extends State<PersonalPlayingTimePage> {
  bool isEdit = false;
  GameTime gameTime = GameTime();

  @override
  void initState() {
    GetIt.instance.get<UserCubit>().clean();
    GetIt.instance.get<UserCubit>().getMe();
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
            return TimeWidget(
              gameTime: state.me!.gameSetting!.gameTime!,
              isEdit: isEdit,
              onChanged: (value) {
                setState(() {
                  gameTime = value;
                });
              },
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
        S.current.lbl_playing_times,
        style: BaseTextStyle.label(),
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      actions: [
        isEdit
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
                icon: BaseIcon.base(IconPath.pencilLine)),
      ],
    );
  }

  void updateGameTime() {
    GetIt.instance.get<UserControllerCubit>().updateGameTime(gameTime);
  }
}
