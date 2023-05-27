import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/core/failures/authentication_failures.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/model/personal/change_password_request.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/user/user_cubit.dart';
import 'package:minder/presentation/widget/button/button_widget.dart';
import 'package:minder/presentation/widget/common/exception_widget.dart';
import 'package:minder/presentation/widget/textfield/textfield_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/constant/path/image_path.dart';
import 'package:minder/util/controller/loading_cover_controller.dart';
import 'package:minder/util/helper/authentication_helper.dart';
import 'package:minder/util/style/base_style.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  ChangePasswordRequest request =
      ChangePasswordRequest(oldPassword: "11111111", newPassword: "12345678");
  final TextEditingController _confirmPassword = TextEditingController();
  late Stream _loginCubitStream;
  bool _isHidePassword = true;
  String? _oldPasswordErrorText;
  String? _newPasswordErrorText;
  String? _confirmPasswordErrorText;
  String? _changePasswordErrorText;

  @override
  void initState() {
    _confirmPassword.text = "12345678";
    _loginCubitStream = GetIt.instance.get<UserCubit>().stream;
    _loginCubitStream.listen((event) {
      if (!mounted) return;
      if (event is UserOldPasswordNotMatchState) {
        setState(() =>
            _changePasswordErrorText = S.current.txt_old_password_not_match);

        return;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black.withOpacity(0.2),
        iconTheme: const IconThemeData(color: BaseColor.grey900),
        toolbarHeight: 48,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          S.current.txt_change_password,
          style: BaseTextStyle.label(),
        ),
      ),
      body: BlocBuilder<UserCubit, UserState>(
        bloc: GetIt.instance.get<UserCubit>(),
        builder: (context, state) {
          if (state is UserError) {
            return buildException(message: state.message);
          }
          return buildBody();
        },
      ),
    );
  }

  SingleChildScrollView buildBody() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            TextFieldWidget.common(
              errorText: _oldPasswordErrorText,
              initialValue: request.oldPassword,
              onChanged: (value) {
                request.oldPassword = value;
              },
              labelText: S.current.lbl_old_password,
              hintText: S.current.txt_err_less_8_chars_password,
              isObscured: _isHidePassword,
              suffixIconPath:
                  _isHidePassword ? IconPath.eyeCloseLine : IconPath.eyeLine,
              onSuffixIconTap: () => setState(() {
                _isHidePassword = !_isHidePassword;
              }),
            ),
            const SizedBox(height: 24),
            TextFieldWidget.common(
              initialValue: request.newPassword,
              errorText: _newPasswordErrorText,
              onChanged: (value) {
                request.newPassword = value;
              },
              labelText: S.current.lbl_new_password,
              hintText: S.current.txt_err_less_8_chars_password,
              isObscured: _isHidePassword,
              suffixIconPath:
                  _isHidePassword ? IconPath.eyeCloseLine : IconPath.eyeLine,
              onSuffixIconTap: () => setState(() {
                _isHidePassword = !_isHidePassword;
              }),
            ),
            const SizedBox(height: 24),
            TextFieldWidget.common(
              errorText: _confirmPasswordErrorText,
              isObscured: _isHidePassword,
              textEditingController: _confirmPassword,
              onChanged: (value) {},
              labelText: S.current.lbl_confirm_password,
              hintText: S.current.txt_err_less_8_chars_password,
              suffixIconPath:
                  _isHidePassword ? IconPath.eyeCloseLine : IconPath.eyeLine,
              onSuffixIconTap: () => setState(() {
                _isHidePassword = !_isHidePassword;
              }),
            ),
            const SizedBox(height: 24),
            if (_changePasswordErrorText != null)
              Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Text(_changePasswordErrorText!,
                      style: BaseTextStyle.body2(color: BaseColor.red500))),
            const SizedBox(height: 24),
            ButtonWidget.base(onTap: validation, content: S.current.btn_done)
          ],
        ),
      ),
    );
  }

  void unFocus() {
    FocusScope.of(context).unfocus();
  }

  void clearError() {
    _confirmPasswordErrorText = null;
    _newPasswordErrorText = null;
    _oldPasswordErrorText = null;
    _changePasswordErrorText = null;
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

  void validation() async {
    unFocus();
    clearError();
    resetHidePasswordState();

    Either<Failures, void> validOldPassword =
        AuthenticationHelper.validPassword(request.oldPassword);
    Either<Failures, void> validNewPassword =
        AuthenticationHelper.validPassword(request.newPassword);
    Either<Failures, void> validConfirmPassword =
        AuthenticationHelper.validConfirmPassword(
            request.newPassword, _confirmPassword.text);
    if (validOldPassword.isLeft) {
      setState(() {
        if (validOldPassword.left is EmptyDataFailures) {
          _oldPasswordErrorText = S.current.txt_please_enter_password;
        }
        if (validOldPassword.left is LessThan8CharFailures) {
          _oldPasswordErrorText = S.current.txt_err_less_8_chars_password;
        }
        if (validOldPassword.left is HaveSpaceFailures) {
          _oldPasswordErrorText = S.current.txt_err_no_space_password;
        }
      });
    }
    if (validNewPassword.isLeft) {
      setState(() {
        if (validNewPassword.left is EmptyDataFailures) {
          _newPasswordErrorText = S.current.txt_please_enter_password;
        }
        if (validNewPassword.left is LessThan8CharFailures) {
          _newPasswordErrorText = S.current.txt_err_less_8_chars_password;
        }
        if (validNewPassword.left is HaveSpaceFailures) {
          _newPasswordErrorText = S.current.txt_err_no_space_password;
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

    if (validNewPassword.isRight &&
        validOldPassword.isRight &&
        validConfirmPassword.isRight) {
      GetIt.instance.get<LoadingCoverController>().on(context);
      GetIt.instance.get<UserCubit>().changePassword(request).then((value) {
        if (value) {
          Navigator.of(context).pop();
        }
        GetIt.instance.get<LoadingCoverController>().off(context);
      });
    }
  }

  Widget buildException({required String message}) {
    return ExceptionWidget(
      subContent: message,
      imagePath: ImagePath.dataParsingFailed,
      buttonContent: S.current.btn_back,
      onButtonTap: () => Navigator.pop(context),
    );
  }
}
