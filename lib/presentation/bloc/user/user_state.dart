part of 'user_cubit.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserSuccess extends UserState {
  final User? me;
  final User? other;
  final UserDto? user;

  UserSuccess({
    this.other,
    this.me,
    this.user,
  });
}

class UserError extends UserState {
  final String message;

  UserError({required this.message});
}

class UserOldPasswordNotMatchState extends UserState {}
