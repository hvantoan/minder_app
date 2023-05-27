import 'package:bloc/bloc.dart';
import 'package:minder/domain/entity/match/match.dart';
import 'package:minder/domain/usecase/implement/match_usecase_impl.dart';

part 'match_state.dart';

class MatchCubit extends Cubit<MatchState> {
  MatchCubit() : super(MatchInitial());

  Future<void> getMatchById(String matchId) async {
    final response = await MatchUseCase().getMatchById(matchId);
    if (response.isLeft) {
      emit(MatchFailure());
      return;
    }

    emit(MatchSuccess(response.right));
  }

  void clean() => emit(MatchInitial());
}
