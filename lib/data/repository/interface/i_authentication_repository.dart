import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/model/authentication/login_model.dart';
import 'package:minder/data/model/authentication/register_model.dart';

abstract class AuthenticationRepositoryInterface {
  Future<Either<Failures, void>> login(LoginModel loginModel);

  Future<Either<Failures, void>> refresh(String refreshToken);

  Future<Either<Failures, void>> register(RegisterModel registerModel);

  Future<Either<Failures, void>> verify(String otp);

  Future<Either<Failures, void>> resendOTP(String username);
}
