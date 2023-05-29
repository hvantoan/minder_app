import 'package:minder/core/exception/authentication_exception.dart';
import 'package:minder/core/exception/exception.dart';
import 'package:minder/core/service/base_api_service.dart';
import 'package:minder/core/service/base_response.dart';
import 'package:minder/data/model/chat/message_model.dart';
import 'package:minder/data/model/chat/send_message_request.dart';
import 'package:minder/util/constant/path/service_path.dart';
import 'package:minder/data/model/chat/list_message_request.dart';

class MessageAPI {
  Future<List<MessageModel>> list(ListMessageRequest request) async {
    try {
      final BaseResponse response = await BaseAPIService.post(
          uri: ServicePath.message, params: request.toMap(), withToken: true);
      if (response.isSuccess) {
        List<MessageModel> messages = (response.data?['items'] as List)
            .map((o) => MessageModel.fromJson(o))
            .toList();
        return messages;
      }
      switch (response.statusCode) {
        default:
          throw DataParsingException();
      }
    } catch (e) {
      if (e is ResponseException || e is AuthenticationException) rethrow;
      throw DataParsingException();
    }
  }

  Future<bool> send(SendMessageRequest request) async {
    try {
      final BaseResponse response = await BaseAPIService.post(
        uri: ServicePath.sendMessage,
        params: request.toMap(),
        withToken: true,
      );
      return response.isSuccess;
    } catch (e) {
      if (e is ResponseException || e is AuthenticationException) rethrow;
      throw DataParsingException();
    }
  }

  Future<MessageModel> get(String id) async {
    try {
      final BaseResponse response = await BaseAPIService.get(
        uri: "${ServicePath.sendMessage}/$id",
        withToken: true,
      );

      if (response.isSuccess) {
        return MessageModel.fromJson(response.data!);
      }

      switch (response.statusCode) {
        default:
          throw DataParsingException();
      }
    } catch (e) {
      if (e is ResponseException || e is AuthenticationException) rethrow;
      throw DataParsingException();
    }
  }
}
