import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/model/chat/list_message_request.dart';
import 'package:minder/data/model/chat/send_message_request.dart';
import 'package:minder/data/repository/interface/i_chat_repository.dart';
import 'package:minder/data/service/chat/message_api.dart';
import 'package:minder/domain/entity/chat/message.dart';

class ChatRepository extends ChatRepositoryInterface {
  @override
  Future<Either<Failures, List<Message>>> getMessage(
      ListMessageRequest request) async {
    try {
      final messageModels = await MessageAPI().list(request);
      return Right(messageModels.map((e) => Message.fromModel(e)).toList());
    } catch (e) {
      return Left(DataParsingFailures());
    }
  }

  @override
  Future<Either<Failures, bool>> sendMessage(SendMessageRequest request) async {
    try {
      final messageModels = await MessageAPI().send(request);
      return Right(messageModels);
    } catch (e) {
      return Left(DataParsingFailures());
    }
  }

  @override
  Future<Either<Failures, Message>> get(String id) async {
    try {
      final messageModel = await MessageAPI().get(id);

      return Right(Message.fromModel(messageModel));
    } catch (e) {
      return Left(DataParsingFailures());
    }
  }
}
