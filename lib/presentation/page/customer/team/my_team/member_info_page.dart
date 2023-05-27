import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/user/user_cubit.dart';
import 'package:minder/presentation/page/customer/team/my_team/member_profile_page.dart';
import 'package:minder/presentation/widget/button/button_widget.dart';
import 'package:minder/presentation/widget/common/exception_widget.dart';
import 'package:minder/presentation/widget/sheet/sheet_widget.dart';
import 'package:minder/presentation/widget/tile/tile_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/constant/path/image_path.dart';

class MemberInfoPage extends StatelessWidget {
  final Member member;
  final Member me;

  const MemberInfoPage({Key? key, required this.member, required this.me})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      SheetWidget.title(
          context: context,
          title: S.current.lbl_information,
          submitContent: S.current.btn_done,
          rollbackContent: S.current.btn_cancel,
          onRollback: () {
            Navigator.pop(context);
          },
          onSubmit: () {
            Navigator.pop(context);
          }),
      BlocBuilder<UserCubit, UserState>(
        bloc: GetIt.instance.get<UserCubit>()..getMe(),
        builder: (context, state) {
          if (state is UserSuccess) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(
                  top: 16, bottom: 32, left: 16, right: 16.0),
              child: Column(
                children: [
                  TileWidget.common(
                      title: member.user!.phone!,
                      isDirector: false,
                      iconPath: IconPath.phoneLine),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 16.0),
                    child: TileWidget.common(
                        title: member.user!.username!,
                        isDirector: false,
                        iconPath: IconPath.mailLine),
                  ),
                  ButtonWidget.secondary(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MemberProfilePage(
                                      me: me,
                                      member: member,
                                    )));
                      },
                      content: S.current.btn_view_profile)
                ],
              ),
            );
          }
          return ExceptionWidget(
            subContent: S.current.txt_data_parsing_failed,
            imagePath: ImagePath.dataParsingFailed,
            buttonContent: S.current.btn_try_again,
            onButtonTap: () => GetIt.instance.get<UserCubit>().getMe(),
          );
        },
      ),
    ]);
  }
}
