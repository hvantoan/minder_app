part of 'app_layer_cubit.dart';

abstract class AppLayerState {}

class AppLayerInitialState extends AppLayerState {}

class AppDisconnectedState extends AppLayerState {}

class ErrorDataParsingState extends AppLayerState {}

class UnsupportedVersionState extends AppLayerState {
  UnsupportedVersionState(this.minimumVersion, this.appVersion);

  final String minimumVersion;
  final String appVersion;

  List<Object> get props => [minimumVersion, appVersion];
}

class AppCheckedState extends AppLayerState {}
