import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:minder/core/failures/team_failures.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/domain/usecase/implement/team_usecase_impl.dart';
import 'package:minder/generated/l10n.dart';

part 'team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  TeamCubit() : super(TeamInitial());

  Future<void> getTeamById({required String teamId}) async {
    final team = await TeamUseCase().getTeamById(teamId: teamId);
    if (team.isLeft) {
      if (team.left is TeamNotExistFailures) {
        emit(TeamErrorState(message: S.current.txt_err_team_not_exist));
        return;
      }
      emit(TeamErrorState(message: S.current.txt_data_parsing_failed));
      return;
    }
    emit(TeamSuccessState(team: team.right));
  }

  void clean() {
    emit(TeamInitial());
  }
}
