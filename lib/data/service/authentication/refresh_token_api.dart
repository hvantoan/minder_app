import 'package:minder/core/exception/authentication_exception.dart';
import 'package:minder/core/exception/exception.dart';
import 'package:minder/core/service/base_api_service.dart';
import 'package:minder/core/service/base_response.dart';
import 'package:minder/data/model/authentication/token_model.dart';
import 'package:minder/util/constant/path/service_path.dart';

class RefreshTokenAPI {
  Future<TokenModel> refreshToken(String refreshToken) async {
    try {
      final BaseResponse response = await BaseAPIService.get(
          uri: ServicePath.refreshToken,
          withToken: false,
          refreshToken: refreshToken);
      if (response.isSuccess) {
        TokenModel tokenModel =
            TokenModel.fromJson(response.data, refreshToken);
        return tokenModel;
      } else {
        throw WrongRefreshTokenException();
      }
    } catch (e) {
      if (e is ResponseException || e is AuthenticationException) rethrow;
      throw DataParsingException();
    }
  }
}
