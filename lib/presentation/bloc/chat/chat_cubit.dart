// ignore_for_file: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitialState());

  changeButtonSendState(bool hasSend) {
    emit(SendButtonState(hasSend: hasSend));
  }

  changeDisplayEmojiPicker(bool emojiShowing) {
    print("Change EmojiPicker: $emojiShowing");
    emit(ChangeEventState(emojiShowing: emojiShowing));
  }

  changeDisplayImagePicker(bool imageShowing) {
    print("Change Image: $imageShowing");
    emit(ChangeEventState(imageShowing: imageShowing));
  }
}
