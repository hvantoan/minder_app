import 'package:either_dart/either.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/model/authentication/token_model.dart';
import 'package:minder/domain/usecase/Implement/authentication_usecase_impl.dart';
import 'package:minder/util/constant/key/secure_storage_key.dart';
import 'package:minder/util/helper/secure_storage_helper.dart';

class TokenHelper {
  static Future<bool> checkToken() async {
    String? accessToken =
        await SecureStorageHelper.read(SecureStorageKey.accessToken);
    String? refreshToken =
        await SecureStorageHelper.read(SecureStorageKey.refreshToken);
    if (accessToken != null && !isInDate(accessToken)) {
      return true;
    }
    if (refreshToken != null && !isInDate(refreshToken)) {
      Either<Failures, void> refreshRepository =
          await AuthenticationUseCase().refreshToken(refreshToken);
      if (refreshRepository.isRight) return await TokenHelper.checkToken();
    }
    return false;
  }

  static Future<String?> getAccessToken() async {
    return await SecureStorageHelper.read(SecureStorageKey.accessToken);
  }

  static Future<void> saveToken({required TokenModel tokenModel}) async {
    await SecureStorageHelper.save(
        SecureStorageKey.accessToken, tokenModel.token);
    await SecureStorageHelper.save(
        SecureStorageKey.refreshToken, tokenModel.refreshToken);
  }

  static Future<void> removeToken() async {
    await SecureStorageHelper.delete(SecureStorageKey.accessToken);
    await SecureStorageHelper.delete(SecureStorageKey.refreshToken);
  }

  static bool isInDate(String token) {
    return JwtDecoder.isExpired(token);
  }

  static String getUserIdFromToken(String token) {
    return JwtDecoder.decode(token)["customerId"];
  }
}
