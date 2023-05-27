import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/data/model/personal/user_dto.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/file/controller/file_controller_cubit.dart';
import 'package:minder/presentation/bloc/user/user_cubit.dart';
import 'package:minder/presentation/page/customer/settings/change_password_page.dart';
import 'package:minder/presentation/page/customer/settings/edit_personal_profile_page.dart';
import 'package:minder/presentation/widget/avatar/avatar_widget.dart';
import 'package:minder/presentation/widget/common/exception_widget.dart';
import 'package:minder/presentation/widget/position_play/position_play.dart';
import 'package:minder/presentation/widget/rank/rank.dart';
import 'package:minder/presentation/widget/text/text_widget.dart';
import 'package:minder/presentation/widget/tile/tile_widget.dart';
import 'package:minder/util/constant/enum/gender_enum.dart';
import 'package:minder/util/constant/enum/position_enum.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/constant/path/image_path.dart';
import 'package:minder/util/helper/gender_helper.dart';
import 'package:minder/util/helper/position_helper.dart';
import 'package:minder/util/style/base_style.dart';

const double _coverHeight = 180.0;

class PersonalProfilePage extends StatefulWidget {
  const PersonalProfilePage({super.key});

  @override
  State<PersonalProfilePage> createState() => _PersonalProfilePageState();
}

class _PersonalProfilePageState extends State<PersonalProfilePage> {
  late UserDto _user;
  final ScrollController _scrollController = ScrollController();
  bool _isSwap = false;

  @override
  void initState() {
    GetIt.instance.get<UserCubit>().getMe();
    GetIt.instance.get<FileControllerCubit>().stream.listen((event) async {
      if (!mounted) return;
      if (event is FileControllerSuccess) {
        GetIt.instance.get<UserCubit>().getMe();
      }
    });
    _scrollController.addListener(_onScrollEvent);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollEvent);
    super.dispose();
  }

  _onScrollEvent() {
    if (_scrollController.position.pixels <= _coverHeight && _isSwap) {
      _isSwap = false;
      setState(() {});
    } else if (_scrollController.position.pixels > _coverHeight && !_isSwap) {
      _isSwap = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSwap
          ? AppBar(
              toolbarHeight: 46,
              backgroundColor: Colors.white,
              shadowColor: Colors.black.withOpacity(0.2),
              iconTheme:
                  const IconThemeData(color: BaseColor.grey900, size: 24),
              title: Row(
                children: [
                  AvatarWidget.base(imagePath: _user.avatar, size: 32),
                  const SizedBox(width: 8),
                  Text(_user.name ?? "", style: BaseTextStyle.label())
                ],
              ),
            )
          : null,
      body: BlocBuilder<UserCubit, UserState>(
        bloc: GetIt.instance.get<UserCubit>(),
        builder: (context, state) {
          if (state is UserError) {
            return buildException(message: state.message);
          }
          if (state is UserSuccess) {
            _user = state.user!;
            return SingleChildScrollView(
              controller: _scrollController,
              child: Stack(
                children: [
                  buildBody(state.user!),
                  _isSwap ? Container() : buildHeader(user: state.user!),
                ],
              ),
            );
          }
          return buildException(message: S.current.txt_err_team_not_exist);
        },
      ),
    );
  }

  Widget buildBody(UserDto user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: _coverHeight + 96),

            //Description
            TextWidget.title(title: S.current.lbl_description),
            Text(user.description ?? "", style: BaseTextStyle.body1()),

            //Position
            TextWidget.title(title: S.current.lbl_playing_position),
            PositionPlay.view(positions: user.gameSetting?.positions ?? []),
            if ((user.gameSetting?.positions ?? []).isEmpty)
              Text(S.current.txt_no_position, style: BaseTextStyle.body1()),

            //Rank

            TextWidget.title(title: S.current.lbl_level),
            Rank.view(rank: user.gameSetting?.rank ?? 0),

            // Phone
            TextWidget.title(title: S.current.lbl_phone),
            Text(user.phone ?? "", style: BaseTextStyle.body1()),

            // Email
            TextWidget.title(title: S.current.lbl_email),
            Text(user.username ?? "", style: BaseTextStyle.body1()),

            // Edit Button
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditPersonalProfilePage(),
                  ),
                );
              },
              child: TileWidget.common(
                  title: S.current.txt_update_profile,
                  iconPath: IconPath.userLine),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordPage(),
                  ),
                );
              },
              child: TileWidget.common(
                  title: S.current.txt_change_password,
                  iconPath: IconPath.lockLine),
            ),
            const SizedBox(height: 56),
          ],
        ),
      ),
    );
  }

  Widget buildException({required String message}) {
    return ExceptionWidget(
      subContent: message,
      imagePath: ImagePath.dataParsingFailed,
      buttonContent: S.current.btn_back,
      onButtonTap: () => Navigator.pop(context),
    );
  }

  Widget buildHeader({required UserDto user}) {
    return SizedBox(
      height: _coverHeight + 96,
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: _coverHeight,
            child: user.cover != null
                ? Image.network(user.cover ?? "", fit: BoxFit.cover)
                : null,
          ),
          Center(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      color: Colors.transparent,
                      child: BaseIcon.base(
                        IconPath.arrowLeftLine,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ]),
                SizedBox(
                    height: _coverHeight -
                        largeAvatarSize / 2 -
                        40 -
                        MediaQuery.of(context).padding.top),
                AvatarWidget.base(
                    name: user.name ?? "",
                    imagePath: user.avatar,
                    isBorder: true,
                    size: largeAvatarSize),
                const SizedBox(height: 12),
                Text("${user.name}", style: BaseTextStyle.label()),
                const SizedBox(height: 4),
                Text(
                    "${GenderHelper.mapKeyToName(Gender.values.elementAt(user.sex ?? 2))} - ${user.calculateAge()} ${S.current.txt_years_old}",
                    style: BaseTextStyle.body2(color: BaseColor.grey500)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
