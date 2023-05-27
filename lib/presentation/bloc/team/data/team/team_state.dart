part of 'team_cubit.dart';

@immutable
abstract class TeamState {}

class TeamInitial extends TeamState {}

class TeamSuccessState extends TeamState {
  final Team team;

  TeamSuccessState({required this.team});
}

class TeamErrorState extends TeamState {
  final String message;

  TeamErrorState({required this.message});
}
