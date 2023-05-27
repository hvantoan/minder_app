import 'package:minder/util/constant/enum/response_status_case_enum.dart';

class ResponseHelper {
  static ResponseStatusCase checkResponseStatusCase(int statusCode) {
    if (statusCode ~/ 100 == 2) return ResponseStatusCase.success;
    if (statusCode ~/ 100 == 4) return ResponseStatusCase.unAuthorization;
    return ResponseStatusCase.serverDisconnect;
  }
}
