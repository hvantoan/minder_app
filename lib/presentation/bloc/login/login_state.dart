part of 'login_cubit.dart';

abstract class LoginState {}

class LoginDefaultState extends LoginState {}

class UnregisteredUsernameState extends LoginState {}

class WrongPasswordState extends LoginState {}

class DisconnectState extends LoginState {}

class ErrorState extends LoginState {}
