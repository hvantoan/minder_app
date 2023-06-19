// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'message_cubit.dart';

@immutable
abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageLoadingState extends MessageState {}

class MessageLoadedState extends MessageState {
  final List<Message> messages;
  MessageLoadedState({required this.messages});

  List<Object> get props => [messages];
}

class MessageErrorState extends MessageState {}

class SendingMessageState extends MessageState {
  final Message message;
  final Uint8List? file;
  SendingMessageState(this.file, {required this.message});

  List<Object?> get props => [message, file];
}

class SendedMessageState extends MessageState {}
