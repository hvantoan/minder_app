import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/team/controller/team_controller_cubit.dart';
import 'package:minder/presentation/page/customer/team/my_team/info_verify_page.dart';
import 'package:minder/presentation/page/customer/team/my_team/relogin_page.dart';
import 'package:minder/presentation/widget/button/button_widget.dart';
import 'package:minder/presentation/widget/textfield/textfield_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';

class MemberNamePage extends StatefulWidget {
  final String teamId;

  const MemberNamePage({Key? key, required this.teamId}) : super(key: key);

  @override
  State<MemberNamePage> createState() => _MemberNamePageState();
}

class _MemberNamePageState extends State<MemberNamePage> {
  final TextEditingController _memberNameController = TextEditingController();
  String? _memberNameErrorText;

  @override
  void initState() {
    GetIt.instance.get<TeamControllerCubit>().clear();
    GetIt.instance.get<TeamControllerCubit>().stream.listen((event) {
      if (!mounted) return;
      if (event is TeamControllerErrorState) {
        setState(() {
          _memberNameErrorText = event.message;
        });
      }
      if (event is TeamControllerSuccessState) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => InformationVerificationPage(
                        child: ReLoginPage(
                      userId: event.id ?? "",
                    ))));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget.common(
            onChanged: (value) {},
            labelText: S.current.lbl_member_name,
            hintText: S.current.txt_enter_member_name,
            textEditingController: _memberNameController,
            errorText: _memberNameErrorText,
            required: true,
            prefixIconPath: IconPath.userLine),
        // if (_memberNameErrorText != null)
        //   Padding(
        //       padding: const EdgeInsets.only(top: 24.0),
        //       child: Text(_memberNameErrorText!,
        //           style: BaseTextStyle.body2(color: BaseColor.red500))),
        const SizedBox(height: 24),
        ButtonWidget.primary(
            onTap: () => enterMemberName(), content: S.current.btn_continue),
      ],
    );
  }

  void enterMemberName() {
    unFocus();
    clearError();
    GetIt.instance.get<TeamControllerCubit>().enterMemberName(
        memberName: _memberNameController.text, teamId: widget.teamId);
  }

  void unFocus() => FocusScope.of(context).unfocus();

  void clearError() => setState(() {
        _memberNameErrorText = null;
      });
}
