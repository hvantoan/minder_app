import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/model/chat/list_message_request.dart';
import 'package:minder/data/model/chat/send_message_request.dart';
import 'package:minder/data/repository/implement/chat_repository_impl.dart';
import 'package:minder/domain/entity/chat/message.dart';
import 'package:minder/domain/usecase/interface/i_chat_usecase.dart';

class ChatUseCase extends ChatUseCaseInterface {
  @override
  Future<Either<Failures, List<Message>>> getMessage(
      ListMessageRequest request) async {
    final response = await ChatRepository().getMessage(request);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, bool>> sendMessage(SendMessageRequest request) async {
    final response = await ChatRepository().sendMessage(request);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, Message>> get(String id) async {
    final response = await ChatRepository().get(id);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }
}
