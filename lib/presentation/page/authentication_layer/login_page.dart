import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/core/failures/authentication_failures.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/debug/debug.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/authentication_layer/authentication_layer_cubit.dart';
import 'package:minder/presentation/bloc/login/login_cubit.dart';
import 'package:minder/presentation/bloc/user/user_cubit.dart';
import 'package:minder/presentation/page/authentication_layer/register_page.dart';
import 'package:minder/presentation/widget/button/button_widget.dart';
import 'package:minder/presentation/widget/textfield/textfield_widget.dart';
import 'package:minder/util/constant/enum/screen_mode_enum.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/constant/path/image_path.dart';
import 'package:minder/util/controller/loading_cover_controller.dart';
import 'package:minder/util/helper/authentication_helper.dart';
import 'package:minder/util/style/base_style.dart';

const String _filePath =
    "lib/presentation/page/authentication_layer/login_page.dart";

final double appIconWidth =
    (instanceBaseGrid.screenMode == ScreenMode.mobile) ? 80 : 160;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Stream loginCubitStream;

  bool _isHidePassword = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _usernameErrorText;
  String? _passwordErrorText;
  String? _loginErrorText;

  @override
  void initState() {
    if (DebugConfig.mode == Mode.debug) {
      _usernameController.text = DebugConfig.autoFillAccount.username!;
      _passwordController.text = DebugConfig.autoFillAccount.password!;
    }
    loginCubitStream = GetIt.instance.get<LoginCubit>().stream;
    loginCubitStream.listen((event) {
      if (!mounted) return;
      if (event is DisconnectState) {
        setState(() => _loginErrorText =
            "${S.current.txt_can_not_connect_server}! ${S.current.txt_please_try_again}.");
        return;
      }
      if (event is ErrorState) {
        setState(() => _loginErrorText =
            "${S.current.txt_data_parsing_failed}! ${S.current.txt_please_try_again}.");
        return;
      }
      if (event is UnregisteredUsernameState) {
        setState(() =>
            _usernameErrorText = "${S.current.txt_unregistered_username}!");
        return;
      }
      if (event is WrongPasswordState) {
        setState(() => _passwordErrorText = "${S.current.txt_wrong_password}!");
        return;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DebugHelper.printPageBuild(filePath: _filePath, widget: "Login Page");
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            buildBottomArea(),
            SingleChildScrollView(
              child: Column(
                children: [
                  buildTopArea(),
                  buildBodyArea(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildBodyArea() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: instanceBaseGrid.margin * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(S.current.lbl_login, style: BaseTextStyle.heading2()),
            const SizedBox(height: 32),
            TextFieldWidget.common(
                onChanged: (value) {},
                labelText: S.current.lbl_email,
                hintText: S.current.txt_username_hint,
                textEditingController: _usernameController,
                errorText: _usernameErrorText,
                required: true,
                prefixIconPath: IconPath.mailLine),
            const SizedBox(height: 16),
            TextFieldWidget.common(
              onChanged: (value) {},
              labelText: S.current.lbl_password,
              hintText: S.current.txt_password_hint,
              isObscured: _isHidePassword,
              textEditingController: _passwordController,
              errorText: _passwordErrorText,
              required: true,
              prefixIconPath: IconPath.lockLine,
              suffixIconPath:
                  _isHidePassword ? IconPath.eyeCloseLine : IconPath.eyeLine,
              onSuffixIconTap: () => setState(() {
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
                onTap: () => login(), content: S.current.btn_login),
            const SizedBox(height: 16),
            Row(
              children: [
                const Spacer(),
                InkWell(
                  onTap: () {},
                  child: Text(
                    S.current.btn_forgot_password,
                    style: BaseTextStyle.label(color: BaseColor.blue500),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Widget buildTopArea() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Image.asset(
        ImagePath.appIcon,
        width: appIconWidth,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget buildBottomArea() {
    const double bottomHeight = 40;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.vertical -
                  bottomHeight),
          SizedBox(
            height: bottomHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(S.current.lbl_not_have_account,
                    style: BaseTextStyle.body1()),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RegisterPage()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    color: Colors.transparent,
                    child: Text(S.current.btn_register,
                        style: BaseTextStyle.label(color: BaseColor.green500)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> login() async {
    unFocus();
    resetHidePasswordState();
    Either<Failures, void> validUsername =
        AuthenticationHelper.validUsername(_usernameController.text);
    Either<Failures, void> validPassword =
        AuthenticationHelper.validPassword(_passwordController.text);
    if (validUsername.isLeft) {
      setState(() {
        if (validUsername.left is EmptyDataFailures) {
          _usernameErrorText = S.current.txt_please_enter_username;
        }
        if (validUsername.left is InvalidEmailFailures) {
          _usernameErrorText = S.current.txt_err_invalid_email;
        }
      });
      return;
    }
    if (validPassword.isLeft) {
      setState(() {
        if (validPassword.left is EmptyDataFailures) {
          _passwordErrorText = S.current.txt_please_enter_password;
        }
        if (validPassword.left is LessThan8CharFailures) {
          _passwordErrorText = S.current.txt_err_less_8_chars_password;
        }
        if (validPassword.left is HaveSpaceFailures) {
          _passwordErrorText = S.current.txt_err_no_space_password;
        }
      });
      return;
    }
    GetIt.instance.get<LoadingCoverController>().on(context);
    bool loginResult = await GetIt.instance.get<LoginCubit>().login(
        context: context,
        username: _usernameController.text,
        password: _passwordController.text);
    if (mounted) GetIt.instance.get<LoadingCoverController>().off(context);
    if (loginResult) {
      GetIt.instance.get<AuthenticationLayerCubit>().authenticate(this);
      GetIt.instance.get<UserCubit>().getMe();
    } else {
      if (mounted) GetIt.instance.get<LoadingCoverController>().off(context);
    }
  }

  void clearPassword() {
    setState(() {
      _passwordController.clear();
    });
  }

  void clearError() {
    setState(() {
      _usernameErrorText = null;
      _passwordErrorText = null;
      _loginErrorText = null;
    });
  }

  void resetHidePasswordState() {
    setState(() {
      _isHidePassword = true;
    });
  }

  void updateHidePasswordState() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  void unFocus() {
    FocusScope.of(context).unfocus();
  }
}
