import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/model/chat/list_message_request.dart';
import 'package:minder/data/model/chat/send_message_request.dart';
import 'package:minder/domain/entity/chat/message.dart';
import 'package:minder/domain/usecase/implement/chat_usecase_impl.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial());

  getMessage(ListMessageRequest request) async {
    emit(MessageLoadingState());

    Either<Failures, List<Message>> messages =
        await ChatUseCase().getMessage(request);
    if (messages.isRight) {
      emit(MessageLoadedState(message: messages.right));
    } else {
      emit(MessageErrorState());
    }
  }

  onNotify() {
    emit(OnLoadMessageState());
  }

  sendMessage(SendMessageRequest request) async {
    Either<Failures, bool> messages = await ChatUseCase().sendMessage(request);
    if (messages.isLeft) {
      emit(MessageErrorState());
    } else {
      emit(OnLoadMessageState());
    }
  }
}
