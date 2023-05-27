import 'package:minder/core/exception/exception.dart';
import 'package:minder/core/failures/failures.dart';

class FailuresHelper {
  static Failures fromCommonException(Object exception) {
    if (exception is ServerException) return ServerFailures();
    if (exception is AuthorizationException) return AuthorizationFailures();
    if (exception is ResponseDataParsingException) {
      return ResponseDataParsingFailures();
    }
    if (exception is DataParsingException) return DataParsingFailures();
    return DataParsingFailures();
  }
}
