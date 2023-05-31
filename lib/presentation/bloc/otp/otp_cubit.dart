import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minder/core/failures/authentication_failures.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/domain/usecase/Implement/authentication_usecase_impl.dart';

part 'otp_state.dart';

const int _countdownTime = 30;

class OTPCubit extends Cubit<OTPState> {
  OTPCubit() : super(OTPDefaultState());

  late Timer _timer;
  var _counter = _countdownTime;

  void initTimer() async {
    emit(UpdateTimerState(_countdownTime));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _counter--;
      emit(UpdateTimerState(_counter));
      if (_counter == 0) {
        _timer.cancel();
        _counter = _countdownTime;
        showResendOtp();
      }
    });
  }

  Future<void> verifyOTP({
    required BuildContext context,
    required String otp,
    required String email,
  }) async {
    Either<Failures, void> verifyRepository =
        await AuthenticationUseCase().verify(otp, email);
    if (verifyRepository.isLeft) {
      if (verifyRepository.left is IncorresctOTPFailures) {
        emit(UnmatchedOTPState());
      } else if (verifyRepository.left is ServerFailures ||
          verifyRepository.left is AuthorizationFailures) {
        emit(DisconnectState());
      } else {
        emit(ErrorState());
      }
    } else {
      emit(MatchedOTPState());
    }
  }

  Future<void> resendOTP(
      {required BuildContext context, required String username}) async {
    Either<Failures, void> resendOTPRepository =
        await AuthenticationUseCase().resendOTP(username);
    if (resendOTPRepository.isLeft) {
      if (resendOTPRepository is ServerFailures ||
          resendOTPRepository is AuthorizationFailures) {
        emit(DisconnectState());
        return;
      }
      emit(ErrorState());
      return;
    }
  }

  void showResendOtp() {
    emit(ResendOTPState());
  }

  void dispose() {
    _timer.cancel();
    _counter = _countdownTime;
  }
}
