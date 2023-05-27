part of 'register_cubit.dart';

abstract class RegisterState {}

class RegisterDefaultState extends RegisterState {}

class RegisteredUsernameState extends RegisterState {}

class DisconnectState extends RegisterState {}

class ErrorState extends RegisterState {}
