import 'package:minder/core/exception/authentication_exception.dart';
import 'package:minder/core/exception/exception.dart';
import 'package:minder/core/service/base_api_service.dart';
import 'package:minder/core/service/base_response.dart';
import 'package:minder/data/model/authentication/register_model.dart';
import 'package:minder/util/constant/path/service_path.dart';

class RegisterAPI {
  Future<void> register(RegisterModel registerModel) async {
    try {
      final BaseResponse response = await BaseAPIService.post(
        uri: ServicePath.register,
        params: registerModel.toJson(),
        withToken: false,
      );
      if (response.isSuccess) return;
      switch (response.statusCode) {
        case 13:
          throw RegisteredUsernameException();
        case 18:
          throw WrongPasswordException();
        case 20:
          throw PhoneEmptyException();
        default:
          throw DataParsingException();
      }
    } catch (e) {
      if (e is ResponseException || e is AuthenticationException) rethrow;
      throw DataParsingException();
    }
  }
}
