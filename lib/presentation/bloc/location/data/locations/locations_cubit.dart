import 'package:bloc/bloc.dart';
import 'package:minder/domain/entity/location/location.dart';
import 'package:minder/domain/usecase/implement/location_repository.dart';

part 'locations_state.dart';

class LocationsCubit extends Cubit<LocationsState> {
  LocationsCubit() : super(LocationsInitial());

  Future<void> getData(String text) async {
    final response = await LocationUseCase().getLocationData(text);
    if (response.isLeft) {
      emit(LocationsFailure());
      return;
    }
    emit(LocationsSuccess(response.right));
  }

  void clean() => emit(LocationsInitial());
}
