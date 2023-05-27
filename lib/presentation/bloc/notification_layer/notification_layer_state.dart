part of 'notification_layer_cubit.dart';

@immutable
abstract class NotificationLayerState {}

class NotificationLayerInitial extends NotificationLayerState {}

class NotificationLayerErrorState extends NotificationLayerState {}

class DisconnectedState extends NotificationLayerState {}

class ConnectedState extends NotificationLayerState {
  final HubConnection hub;
  ConnectedState({
    required this.hub,
  });

  List<Object> get props => [hub];
}
