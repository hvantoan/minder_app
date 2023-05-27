import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/domain/usecase/implement/user_usecase_impl.dart';
import 'package:minder/generated/l10n.dart';

part 'user_controller_state.dart';

class UserControllerCubit extends Cubit<UserControllerState> {
  UserControllerCubit() : super(UserControllerInitial());

  Future<void> updateGameTime(GameTime gameTime) async {
    final response = await UserUseCase().updateGameTime(gameTime);
    if (response.isLeft) {
      emit(UserControllerFailure(S.current.txt_data_parsing_failed));
      return;
    }

    emit(UserControllerSuccess());
  }

  Future<void> updateLocation(LatLng? latLng, int radius) async {
    final response = await UserUseCase().updateLocation(latLng, radius);
    if (response.isLeft) {
      emit(UserControllerFailure(S.current.txt_data_parsing_failed));
      return;
    }

    emit(UserControllerSuccess());
  }

  void clean() => emit(UserControllerInitial());
}
