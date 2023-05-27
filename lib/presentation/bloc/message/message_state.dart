// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'message_cubit.dart';

@immutable
abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageLoadingState extends MessageState {}

class MessageLoadedState extends MessageState {
  final List<Message> message;
  MessageLoadedState({required this.message});

  List<Object> get props => [message];
}

class MessageErrorState extends MessageState {}

class SendMessageState extends MessageState {}

class OnLoadMessageState extends MessageState {}

class OnUpdateMessageState extends MessageState {
  final List<Message> message;
  OnUpdateMessageState({required this.message});

  List<Object> get props => [message];
}

class OnReceiveMessageState extends MessageState {
  final List<Message> message;
  OnReceiveMessageState({required this.message});

  List<Object> get props => [message];
}
