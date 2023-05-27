import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/team/controller/team_controller_cubit.dart';
import 'package:minder/presentation/bloc/team/data/teams/team_cubit.dart';
import 'package:minder/presentation/widget/button/button_widget.dart';
import 'package:minder/presentation/widget/textfield/textfield_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_text_style.dart';

class ReLoginPage extends StatefulWidget {
  final String userId;

  const ReLoginPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ReLoginPage> createState() => _ReLoginPageState();
}

class _ReLoginPageState extends State<ReLoginPage> {
  bool _isHidePassword = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _loginErrorText;

  @override
  void initState() {
    GetIt.instance.get<TeamControllerCubit>().clear();
    GetIt.instance
        .get<TeamControllerCubit>()
        .stream
        .listen((event) {
      if (!mounted) return;
      if (event is TeamControllerErrorState) {
        setState(() => _loginErrorText = event.message);
        return;
      }
      if (event is TeamControllerSuccessState) {
        Navigator.popUntil(
            context, ModalRoute.withName(Navigator.defaultRouteName));
        GetIt.instance.get<TeamsCubit>().getTeams();
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
            labelText: S.current.lbl_username,
            hintText: S.current.txt_username_hint,
            textEditingController: _usernameController,
            required: true,
            prefixIconPath: IconPath.mailLine),
        const SizedBox(height: 16),
        TextFieldWidget.common(
          onChanged: (value) {},
          labelText: S.current.lbl_password,
          hintText: S.current.txt_password_hint,
          isObscured: _isHidePassword,
          textEditingController: _passwordController,
          required: true,
          prefixIconPath: IconPath.lockLine,
          suffixIconPath:
          _isHidePassword ? IconPath.eyeCloseLine : IconPath.eyeLine,
          onSuffixIconTap: () =>
              setState(() {
                _isHidePassword = !_isHidePassword;
              }),
        ),
        if (_loginErrorText != null)
          Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(_loginErrorText!,
                  style: BaseTextStyle.body2(color: BaseColor.red500))),
        const SizedBox(height: 24),
        ButtonWidget.primary(
            onTap: () => verify(), content: S.current.btn_verify),
      ],
    );
  }

  void clearError() => setState(() => _loginErrorText = null);

  void unFocus() => FocusScope.of(context).unfocus();

  void verify() {
    clearError();
    unFocus();
    GetIt.instance.get<TeamControllerCubit>().verify(
        username: _usernameController.text, password: _passwordController.text);
  }
}
