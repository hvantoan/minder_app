import 'package:minder/core/failures/failures.dart';

class ServerFailures extends Failures {
  ServerFailures({String? messageKey}) : super(message: messageKey);
}

class AuthorizationFailures extends Failures {
  AuthorizationFailures({String? messageKey}) : super(message: messageKey);
}

class ResponseDataParsingFailures extends Failures {
  ResponseDataParsingFailures({String? messageKey})
      : super(message: messageKey);
}

class DataParsingFailures extends Failures {
  DataParsingFailures({String? messageKey}) : super(message: messageKey);
}
