import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/model/chat/list_message_request.dart';
import 'package:minder/data/model/chat/send_message_request.dart';
import 'package:minder/domain/entity/chat/message.dart';

abstract class ChatUseCaseInterface {
  Future<Either<Failures, List<Message>>> getMessage(
      ListMessageRequest request);

  Future<Either<Failures, bool>> sendMessage(SendMessageRequest request);
  Future<Either<Failures, Message>> get(String id);
}
