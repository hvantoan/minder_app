part of 'matches_cubit.dart';

abstract class MatchesState {}

class MatchesInitial extends MatchesState {}

class MatchesFailure extends MatchesState {}

class MatchesSuccess extends MatchesState {
  final List<match.Match> matches;
  final List<Team> teams;

  MatchesSuccess(this.matches, this.teams);
}
