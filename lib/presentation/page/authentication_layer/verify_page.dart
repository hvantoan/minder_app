import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/otp/otp_cubit.dart';
import 'package:minder/presentation/page/authentication_layer/register_page.dart';
import 'package:minder/presentation/widget/button/button_widget.dart';
import 'package:minder/util/constant/enum/screen_mode_enum.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/constant/path/image_path.dart';
import 'package:minder/util/controller/loading_cover_controller.dart';
import 'package:minder/util/style/base_style.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

final double verifyIconWidth =
    (instanceBaseGrid.screenMode == ScreenMode.mobile) ? 200 : 200;

class VerifyPage extends StatefulWidget {
  const VerifyPage({
    super.key,
    required this.username,
    required this.onSuccess,
  });

  final String username;
  final VoidCallback onSuccess;

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final _otpCubit = GetIt.instance.get<OTPCubit>();
  String? _verifyErrorText;
  bool _disableResend = true;
  String _otp = "";
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _otpCubit.initTimer();
  }

  @override
  void dispose() {
    _otpCubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OTPCubit, OTPState>(
      listener: (context, state) {
        if (state is MatchedOTPState) {
          widget.onSuccess();
        }
        if (state is UnmatchedOTPState) {
          _verifyErrorText = "${S.current.txt_err_otp_incorresct}.";
        }

        if (state is DisconnectState) {
          setState(() => _verifyErrorText =
              "${S.current.txt_can_not_connect_server}! ${S.current.txt_please_try_again}.");
        }
        if (state is ErrorState) {
          setState(() => _verifyErrorText =
              "${S.current.txt_data_parsing_failed}! ${S.current.txt_please_try_again}.");
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTopArea(),
                buildBodyArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTopArea() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: instanceBaseGrid.margin * 2,
        vertical: 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const RegisterPage()));
            },
            child: SvgPicture.asset(
              IconPath.arrowLeftLine,
              width: 24,
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              ImagePath.verifyIcon,
              width: verifyIconWidth,
              fit: BoxFit.fitWidth,
            ),
          )
        ],
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
          BlocBuilder<OTPCubit, OTPState>(
            builder: (context, state) {
              if (state is UpdateTimerState) {
                return RichText(
                  text: TextSpan(
                    text: S.current.lbl_verify_opt,
                    style: BaseTextStyle.label(),
                    children: [
                      TextSpan(
                        text: " ${widget.username}",
                        style: BaseTextStyle.label(color: BaseColor.green500),
                      ),
                      TextSpan(
                        text: " (${state.secondsRemaining})",
                        style: BaseTextStyle.label(color: BaseColor.green500),
                      ),
                    ],
                  ),
                );
              }
              return RichText(
                text: TextSpan(
                  text: S.current.lbl_verify_opt,
                  style: BaseTextStyle.label(),
                  children: [
                    TextSpan(
                      text: " ${widget.username}",
                      style: BaseTextStyle.label(color: BaseColor.green500),
                    ),
                    TextSpan(
                      text: "",
                      style: BaseTextStyle.label(color: BaseColor.green500),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          PinCodeTextField(
            length: 6,
            obscureText: false,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(8),
              fieldHeight: 44,
              fieldWidth: 44,
              inactiveColor: Colors.white,
              inactiveFillColor: Colors.white,
              activeFillColor: Colors.white,
              activeColor: Colors.white,
              selectedFillColor: Colors.white,
              selectedColor: Colors.white,
            ),
            textStyle: BaseTextStyle.label(color: BaseColor.grey900),
            animationDuration: const Duration(milliseconds: 300),
            backgroundColor: Colors.white,
            cursorColor: BaseColor.grey500,
            cursorHeight: 20,
            enableActiveFill: true,
            controller: _textEditingController,
            boxShadows: [BaseShadowStyle.common],
            onCompleted: (otp) {
              _otp = otp;
              turnOnLoading();
              GetIt.instance
                  .get<OTPCubit>()
                  .verifyOTP(
                    context: context,
                    otp: _otp,
                    email: widget.username,
                  )
                  .then((_) => turnOffLoading());
            },
            onChanged: (value) {},
            beforeTextPaste: (text) {
              return true;
            },
            appContext: context,
          ),
          if (_verifyErrorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                _verifyErrorText!,
                style: BaseTextStyle.body2(color: BaseColor.red500),
              ),
            ),
          const SizedBox(height: 16),
          BlocBuilder<OTPCubit, OTPState>(
            builder: (ctx, state) {
              if (state is ResendOTPState) {
                _disableResend = false;
              }
              return ButtonWidget.primary(
                onTap: () {
                  if (_disableResend) return;
                  turnOnLoading();
                  _otpCubit
                      .resendOTP(context: context, username: widget.username)
                      .then((_) {
                    turnOffLoading();
                    _disableResend = true;
                    _otpCubit.initTimer();
                  });
                },
                isDisable: _disableResend,
                content: S.current.btn_resend_otp,
              );
            },
          )
        ],
      ),
    );
  }

  void turnOffLoading() {
    GetIt.instance.get<LoadingCoverController>().off(context);
  }

  void turnOnLoading() {
    clearErrorText();
    GetIt.instance.get<LoadingCoverController>().on(context);
  }

  void clearErrorText() {
    _verifyErrorText = null;
  }
}
