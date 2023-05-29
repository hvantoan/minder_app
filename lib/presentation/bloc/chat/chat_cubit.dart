// ignore_for_file: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitialState());

  changeButtonSendState(String text) {
    emit(SendButtonState(hasSend: text.isNotEmpty));
  }

  changeDisplayEmojiPicker(bool emojiShowing) {
    emit(EmojiPickerDisplayState(emojiShowing: !emojiShowing));
  }

  changeDisplayImagePicker(bool imageShowing) {
    emit(ImagePickerState(imageShowing: !imageShowing));
  }
}
