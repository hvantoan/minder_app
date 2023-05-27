part of 'stadiums_cubit.dart';

abstract class StadiumsState {}

class StadiumsInitial extends StadiumsState {}

class StadiumsFailure extends StadiumsState {
  final String message;

  StadiumsFailure(this.message);
}

class StadiumsSuccess extends StadiumsState {
  final List<Stadium> stadiums;

  StadiumsSuccess(this.stadiums);
}
