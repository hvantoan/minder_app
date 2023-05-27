import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/core/failures/authentication_failures.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/debug/debug.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/register/register_cubit.dart';
import 'package:minder/presentation/page/authentication_layer/login_page.dart';
import 'package:minder/presentation/page/authentication_layer/verify_page.dart';
import 'package:minder/presentation/widget/button/button_widget.dart';
import 'package:minder/presentation/widget/textfield/textfield_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/constant/path/image_path.dart';
import 'package:minder/util/controller/loading_cover_controller.dart';
import 'package:minder/util/helper/authentication_helper.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_grid.dart';
import 'package:minder/util/style/base_text_style.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late Stream registerCubitStream;
  bool _isHidePassword = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _usernameErrorText;
  String? _passwordErrorText;
  String? _confirmPasswordErrorText;
  String? _nameErrorText;
  String? _phoneErrorText;

  String? _registerErrorText;

  @override
  void initState() {
    if (DebugConfig.mode == Mode.debug) {
      _usernameController.text = DebugConfig.autoFillRegisterAccount.username!;
      _passwordController.text = DebugConfig.autoFillRegisterAccount.password!;
      _confirmPasswordController.text =
          DebugConfig.autoFillRegisterAccount.password!;
      _nameController.text = DebugConfig.autoFillRegisterAccount.name!;
      _phoneController.text = DebugConfig.autoFillRegisterAccount.phone!;
    }

    registerCubitStream = GetIt.instance.get<RegisterCubit>().stream;
    registerCubitStream.listen((event) {
      if (!mounted) return;
      GetIt.instance.get<LoadingCoverController>().off(context);
      if (event is DisconnectState) {
        setState(() => _registerErrorText =
            "${S.current.txt_can_not_connect_server}! ${S.current.txt_please_try_again}.");
        return;
      }

      if (event is ErrorState) {
        setState(() => _registerErrorText =
            "${S.current.txt_data_parsing_failed}! ${S.current.txt_please_try_again}.");
        return;
      }

      if (event is RegisteredUsernameState) {
        setState(() =>
            _usernameErrorText = "${S.current.txt_err_registered_username}!");
        return;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  buildTopArea(),
                  buildBodyArea(),
                  buildBottomArea(),
                ],
              ),
            ),
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
            Text(S.current.lbl_register, style: BaseTextStyle.heading2()),
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
              labelText: S.current.lbl_name,
              hintText: S.current.txt_name_hint,
              textEditingController: _nameController,
              errorText: _nameErrorText,
              required: true,
              prefixIconPath: IconPath.lockLine,
            ),
            const SizedBox(height: 16),
            TextFieldWidget.common(
                onChanged: (value) {},
                labelText: S.current.lbl_phone,
                hintText: S.current.txt_phone_hint,
                textEditingController: _phoneController,
                errorText: _phoneErrorText,
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
            const SizedBox(height: 16),
            TextFieldWidget.common(
              onChanged: (value) {},
              labelText: S.current.lbl_confirm_password,
              hintText: S.current.txt_password_hint,
              isObscured: _isHidePassword,
              textEditingController: _confirmPasswordController,
              errorText: _confirmPasswordErrorText,
              required: true,
              prefixIconPath: IconPath.lockLine,
              suffixIconPath:
                  _isHidePassword ? IconPath.eyeCloseLine : IconPath.eyeLine,
              onSuffixIconTap: () => setState(() {
                _isHidePassword = !_isHidePassword;
              }),
            ),
            if (_registerErrorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Text(
                  _registerErrorText!,
                  style: BaseTextStyle.body2(color: BaseColor.red500),
                ),
              ),
            const SizedBox(height: 24),
            ButtonWidget.primary(
              onTap: () => validation(),
              content: S.current.btn_register,
            ),
            const SizedBox(height: 16),
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
    return SizedBox(
      height: bottomHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(S.current.lbl_already_have_account,
              style: BaseTextStyle.body1()),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(S.current.btn_login,
                  style: BaseTextStyle.label(color: BaseColor.green500)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> validation() async {
    unFocus();
    clearError();
    resetHidePasswordState();
    Either<Failures, void> validUsername =
        AuthenticationHelper.validUsername(_usernameController.text);
    Either<Failures, void> validPassword =
        AuthenticationHelper.validPassword(_passwordController.text);
    Either<Failures, void> validConfirmPassword =
        AuthenticationHelper.validConfirmPassword(
            _passwordController.text, _confirmPasswordController.text);

    if (validUsername.isLeft) {
      setState(() {
        if (validUsername.left is EmptyDataFailures) {
          _usernameErrorText = S.current.txt_please_enter_username;
        }
        if (validUsername.left is InvalidEmailFailures) {
          _usernameErrorText = S.current.txt_err_invalid_email;
        }
      });
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
    }
    if (validConfirmPassword.isLeft) {
      setState(() {
        if (validConfirmPassword.left is EmptyDataFailures) {
          _confirmPasswordErrorText = S.current.txt_please_enter_password;
        }
        if (validConfirmPassword.left is ConfirmPasswordFailures) {
          _confirmPasswordErrorText =
              S.current.txt_err_password_confirm_not_match;
        }
      });
    }

    if (validUsername.isRight &&
        validPassword.isRight &&
        validConfirmPassword.isRight) {
      await register();
    }
  }

  Future<void> register() async {
    GetIt.instance.get<LoadingCoverController>().on(context);
    GetIt.instance
        .get<RegisterCubit>()
        .register(
          context: context,
          name: _nameController.text,
          username: _usernameController.text,
          password: _passwordController.text,
          phone: _phoneController.text,
        )
        .then(
      (value) {
        GetIt.instance.get<LoadingCoverController>().off(context);
        if (value) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => VerifyPage(
                  username: _usernameController.text,
                  onSuccess: () {
                    // Pop 2 times to navigate to Login page
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }),
            ),
          );
        }
      },
    );
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
      _registerErrorText = null;
      _confirmPasswordErrorText = null;
      _nameErrorText = null;
      _phoneErrorText = null;
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
