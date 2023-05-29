part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitialState extends ChatState {}

class SendButtonState extends ChatState {
  final bool hasSend;
  SendButtonState({required this.hasSend});

  List<Object> get props => [hasSend];
}

class EmojiPickerDisplayState extends ChatState {
  final bool emojiShowing;
  EmojiPickerDisplayState({required this.emojiShowing});

  List<Object> get props => [emojiShowing];
}

class ImagePickerState extends ChatState {
  final bool imageShowing;
  ImagePickerState({required this.imageShowing});

  List<Object> get props => [imageShowing];
}
