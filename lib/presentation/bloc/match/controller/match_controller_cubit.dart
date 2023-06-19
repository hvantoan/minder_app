import 'package:bloc/bloc.dart';
import 'package:minder/domain/entity/match/match.dart' as match;
import 'package:minder/domain/usecase/implement/match_usecase_impl.dart';

part 'match_controller_state.dart';

class MatchControllerCubit extends Cubit<MatchControllerState> {
  MatchControllerCubit() : super(MatchControllerInitial());

  Future<void> swipe(
      String hostTeamId, String opposingTeamId, bool hasInvite) async {
    final response =
        await MatchUseCase().swipe(hostTeamId, opposingTeamId, hasInvite);
    if (response.isLeft) {
      emit(MatchControllerFailure());
      return;
    }

    emit(MatchControllerSuccess());
  }

  Future<void> selectTime(String matchId, DateTime date, num dayOfWeek,
      match.TimeOption timeOption, String teamId) async {
    final response = await MatchUseCase()
        .selectTime(matchId, date, dayOfWeek, timeOption, teamId);
    if (response.isLeft) {
      emit(MatchControllerFailure());
      return;
    }

    emit(MatchControllerSuccess());
  }

  Future<void> selectStadium(
      String matchId, String stadiumId, String teamId) async {
    final response =
        await MatchUseCase().selectStadium(matchId, stadiumId, teamId);
    if (response.isLeft) {
      emit(MatchControllerFailure());
      return;
    }

    emit(MatchControllerSuccess());
  }

  void clean() => emit(MatchControllerInitial());
}
