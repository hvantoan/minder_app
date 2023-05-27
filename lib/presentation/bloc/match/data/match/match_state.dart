part of 'match_cubit.dart';

abstract class MatchState {}

class MatchInitial extends MatchState {}

class MatchFailure extends MatchState {}

class MatchSuccess extends MatchState {
  final Match match;

  MatchSuccess(this.match);
}
