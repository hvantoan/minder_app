import 'package:minder/domain/entity/team/team.dart';

abstract class TeamsState {}

class TeamsInitialState extends TeamsState {}

class TeamsSuccessState extends TeamsState {
  final List<Team> teams;

  TeamsSuccessState({required this.teams});
}

class TeamsErrorState extends TeamsState {
  final String message;

  TeamsErrorState({required this.message});
}
