import 'package:minder/core/exception/authentication_exception.dart';
import 'package:minder/core/exception/exception.dart';
import 'package:minder/core/service/base_api_service.dart';
import 'package:minder/core/service/base_response.dart';
import 'package:minder/util/constant/path/service_path.dart';

class OtpAPI {
  Future<void> verify(String otp) async {
    try {
      final BaseResponse response = await BaseAPIService.get(
          uri: "${ServicePath.verify}?otp=$otp", withToken: false);
      if (response.isSuccess) return;
      switch (response.statusCode) {
        case 5:
          throw IncorresctOTPException();
        default:
          throw DataParsingException();
      }
    } catch (e) {
      if (e is ResponseException || e is AuthenticationException) rethrow;
      throw DataParsingException();
    }
  }

  Future<void> resendOTP(String username) async {
    try {
      final BaseResponse response = await BaseAPIService.get(
          uri: "${ServicePath.resendOTP}?username=$username");
      if (response.isSuccess) return;
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
