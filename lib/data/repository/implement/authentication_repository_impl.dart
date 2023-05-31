import 'package:either_dart/either.dart';
import 'package:minder/core/exception/authentication_exception.dart';
import 'package:minder/core/exception/common_exception.dart';
import 'package:minder/core/failures/authentication_failures.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/model/authentication/login_model.dart';
import 'package:minder/data/model/authentication/register_model.dart';
import 'package:minder/data/model/authentication/token_model.dart';
import 'package:minder/data/repository/interface/i_authentication_repository.dart';
import 'package:minder/data/service/authentication/login_api.dart';
import 'package:minder/data/service/authentication/opt_api.dart';
import 'package:minder/data/service/authentication/refresh_token_api.dart';
import 'package:minder/data/service/authentication/register_api.dart';
import 'package:minder/util/helper/failures_helper.dart';
import 'package:minder/util/helper/token_helper.dart';

class AuthenticationRepository implements AuthenticationRepositoryInterface {
  @override
  Future<Either<Failures, void>> login(LoginModel loginModel) async {
    try {
      final TokenModel token = await LoginAPI().login(loginModel);
      await TokenHelper.saveToken(tokenModel: token);
      return const Right(null);
    } catch (e) {
      if (e is UnregisteredUsernameException) {
        return Left(UnregisteredUsernameFailures());
      }
      if (e is WrongPasswordException) {
        return Left(WrongPasswordFailures());
      }
      if (e is ResponseException) {
        return Left(FailuresHelper.fromCommonException(e));
      }
      return Left(DataParsingFailures());
    }
  }

  @override
  Future<Either<Failures, void>> refresh(String refreshToken) async {
    try {
      final TokenModel token =
          await RefreshTokenAPI().refreshToken(refreshToken);
      await TokenHelper.saveToken(tokenModel: token);
      return const Right(null);
    } catch (e) {
      if (e is WrongRefreshTokenException) {
        return Left(WrongRefreshTokenFailures());
      }
      if (e is ResponseException) {
        return Left(FailuresHelper.fromCommonException(e));
      }
      return Left(DataParsingFailures());
    }
  }

  @override
  Future<Either<Failures, void>> register(RegisterModel registerModel) async {
    try {
      await RegisterAPI().register(registerModel);
      return const Right(null);
    } catch (e) {
      if (e is RegisteredUsernameException) {
        return Left(RegisteredUsernameFailures());
      }
      if (e is WrongPasswordException) {
        return Left(WrongPasswordFailures());
      }
      if (e is ResponseException) {
        return Left(FailuresHelper.fromCommonException(e));
      }
      return Left(DataParsingFailures());
    }
  }

  @override
  Future<Either<Failures, void>> verify(String otp, String email) async {
    try {
      await OtpAPI().verify(otp, email);
      return const Right(null);
    } catch (e) {
      if (e is IncorresctOTPException) {
        return Left(IncorresctOTPFailures());
      }

      if (e is ResponseException) {
        return Left(FailuresHelper.fromCommonException(e));
      }
      return Left(DataParsingFailures());
    }
  }

  @override
  Future<Either<Failures, void>> resendOTP(String username) async {
    try {
      await OtpAPI().resendOTP(username);
      return const Right(null);
    } catch (e) {
      if (e is ResponseException) {
        return Left(FailuresHelper.fromCommonException(e));
      }
      return Left(DataParsingFailures());
    }
  }
}
