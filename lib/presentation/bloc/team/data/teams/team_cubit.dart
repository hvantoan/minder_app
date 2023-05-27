import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/domain/usecase/implement/team_usecase_impl.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/team/data/teams/team_state.dart';

class TeamsCubit extends Cubit<TeamsState> {
  TeamsCubit() : super(TeamsInitialState());

  Future<void> getTeams() async {
    final response = await TeamUseCase().getTeams();
    if (response.isLeft) {
      emit(TeamsErrorState(message: S.current.txt_data_parsing_failed));
      return;
    }
    List<Team> teams = response.right;
    emit(TeamsSuccessState(teams: teams));
  }

  void clean() => emit(TeamsInitialState());
}
