import 'package:minder/core/exception/authentication_exception.dart';
import 'package:minder/core/exception/exception.dart';
import 'package:minder/core/service/base_api_service.dart';
import 'package:minder/core/service/base_response.dart';
import 'package:minder/data/model/authentication/login_model.dart';
import 'package:minder/data/model/authentication/token_model.dart';
import 'package:minder/util/constant/path/service_path.dart';

class LoginAPI {
  Future<TokenModel> login(LoginModel loginModel) async {
    try {
      final BaseResponse response = await BaseAPIService.post(
          uri: ServicePath.login,
          params: loginModel.toJson(),
          withToken: false);
      if (response.isSuccess) {
        TokenModel tokenModel = TokenModel.fromJson(response.data);
        return tokenModel;
      }
      switch (response.statusCode) {
        case 1:
          throw UnregisteredUsernameException();
        case 3:
          throw WrongPasswordException();
        default:
          throw DataParsingException();
      }
    } catch (e) {
      if (e is ResponseException || e is AuthenticationException) rethrow;
      throw DataParsingException();
    }
  }
}
