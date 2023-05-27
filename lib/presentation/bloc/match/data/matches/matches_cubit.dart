import 'package:bloc/bloc.dart';
import 'package:minder/domain/entity/match/match.dart' as match;
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/domain/usecase/implement/match_usecase_impl.dart';
import 'package:minder/domain/usecase/implement/team_usecase_impl.dart';

part 'matches_state.dart';

class MatchesCubit extends Cubit<MatchesState> {
  MatchesCubit() : super(MatchesInitial());

  Future<void> getData(String teamId) async {
    final response = await MatchUseCase().getTeamMatches(teamId);
    if (response.isLeft) {
      emit(MatchesFailure());
      return;
    }

    final team = await TeamUseCase().getTeams(isMyTeam: false);
    if (team.isLeft) {
      emit(MatchesFailure());
      return;
    }

    emit(MatchesSuccess(
        response.right,
        team.right
            .where((team) =>
                team.id != teamId &&
                response.right
                    .where((match) =>
                        (match.opposingTeam!.teamId! == team.id ||
                            match.hostTeam!.teamId! == team.id) &&
                        (match.status ?? 0) > 0)
                    .isEmpty)
            .toList()));
  }

  void clean() => emit(MatchesInitial());
}
