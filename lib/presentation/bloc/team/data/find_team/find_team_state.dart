part of 'find_team_cubit.dart';

abstract class FindTeamState {}

class FindTeamInitial extends FindTeamState {}

class FindTeamFailure extends FindTeamState {
  final String message;

  FindTeamFailure({required this.message});
}

class FindTeamSuccess extends FindTeamState {
  final List<Team> suggest;
  final List<Invite> inviteTeams;

  FindTeamSuccess({required this.suggest, required this.inviteTeams});
}
