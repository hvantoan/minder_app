part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitialState extends ChatState {}

class SendButtonState extends ChatState {
  final bool hasSend;
  SendButtonState({required this.hasSend});

  List<Object> get props => [hasSend];
}

class ChangeEventState extends ChatState {
  final bool emojiShowing;
  final bool imageShowing;
  ChangeEventState({
    this.emojiShowing = false,
    this.imageShowing = false,
  });

  List<Object> get props => [emojiShowing];
}
