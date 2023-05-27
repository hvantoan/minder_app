import 'package:minder/debug/debug.dart';

class ResponseException implements Exception {}

class ServerException implements ResponseException {
  ServerException() : super() {
    DebugHelper.printException(exception: "ServerException");
  }
}

class AuthorizationException implements ResponseException {
  AuthorizationException() : super() {
    DebugHelper.printException(exception: "AuthorizationException");
  }
}

class ResponseDataParsingException implements ResponseException {
  ResponseDataParsingException() : super() {
    DebugHelper.printException(exception: "ResponseDataParsingException");
  }
}

class DataParsingException implements Exception {
  DataParsingException() : super() {
    DebugHelper.printException(exception: "DataParsingException");
  }
}
