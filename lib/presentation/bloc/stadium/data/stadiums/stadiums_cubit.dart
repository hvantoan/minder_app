import 'package:bloc/bloc.dart';
import 'package:minder/domain/entity/stadium/stadium.dart';
import 'package:minder/domain/usecase/implement/stadium_usecase_impl.dart';
import 'package:minder/generated/l10n.dart';

part 'stadiums_state.dart';

class StadiumsCubit extends Cubit<StadiumsState> {
  StadiumsCubit() : super(StadiumsInitial());

  Future<void> getData() async {
    final response = await StadiumUseCase().getStadiums();
    if (response.isLeft) {
      emit(StadiumsFailure(S.current.txt_data_parsing_failed));
      return;
    }

    emit(StadiumsSuccess(response.right));
  }

  Future<void> getStadiumSuggest({required String matchId}) async {
    final response = await StadiumUseCase().getStadiumSuggest(matchId: matchId);
    if (response.isLeft) {
      emit(StadiumsFailure(S.current.txt_data_parsing_failed));
      return;
    }

    emit(StadiumsSuccess(response.right));
  }

  void clean() => emit(StadiumsInitial());
}
