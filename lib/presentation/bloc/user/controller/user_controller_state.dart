part of 'user_controller_cubit.dart';

abstract class UserControllerState {}

class UserControllerInitial extends UserControllerState {}

class UserControllerFailure extends UserControllerState {
  final String message;

  UserControllerFailure(this.message);
}

class UserControllerSuccess extends UserControllerState {}
