part of 'team_controller_cubit.dart';

@immutable
abstract class TeamControllerState {}

class TeamControllerInitial extends TeamControllerState {}

class TeamControllerSuccessState extends TeamControllerState {
  final String? id;

  TeamControllerSuccessState({this.id});
}

class TeamControllerNameEmptyState extends TeamControllerState {}

class TeamControllerCodeEmptyState extends TeamControllerState {}

class TeamControllerCodeExistState extends TeamControllerState {}

class TeamControllerStadiumTypeEmptyState extends TeamControllerState {}

class TeamControllerHaveTeamState extends TeamControllerState {}

class TeamControllerErrorState extends TeamControllerState {
  final String message;

  TeamControllerErrorState({required this.message});
}
