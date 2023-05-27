part of 'otp_cubit.dart';

abstract class OTPState {}

class OTPDefaultState extends OTPState {}

class UpdateTimerState extends OTPState {
  UpdateTimerState(this.secondsRemaining);

  final int secondsRemaining;

  List<Object> get props => [secondsRemaining];
}

class ResendOTPState extends OTPState {}

class MatchedOTPState extends OTPState {}

class UnmatchedOTPState extends OTPState {}

class DisconnectState extends OTPState {}

class ErrorState extends OTPState {}
