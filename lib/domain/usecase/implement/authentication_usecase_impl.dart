import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/model/authentication/login_model.dart';
import 'package:minder/data/model/authentication/register_model.dart';
import 'package:minder/data/repository/implement/authentication_repository_impl.dart';
import 'package:minder/domain/usecase/Interface/i_authentication_usecase.dart';

class AuthenticationUseCase extends AuthenticationUseCaseInterface {
  @override
  Future<Either<Failures, void>> login(LoginModel loginModel) async {
    Either<Failures, void> getUserId =
        await AuthenticationRepository().login(loginModel);
    if (getUserId.isLeft) return Left(getUserId.left);
    return const Right(null);
  }

  @override
  Future<Either<Failures, void>> refreshToken(String refreshToken) async {
    Either<Failures, void> refresh =
        await AuthenticationRepository().refresh(refreshToken);
    if (refresh.isLeft) return Left(refresh.left);
    return const Right(null);
  }

  @override
  Future<Either<Failures, void>> register(RegisterModel registerModel) async {
    Either<Failures, void> register =
        await AuthenticationRepository().register(registerModel);
    if (register.isLeft) return Left(register.left);
    return const Right(null);
  }

  @override
  Future<Either<Failures, void>> verify(String otp) async {
    Either<Failures, void> verify =
        await AuthenticationRepository().verify(otp);
    if (verify.isLeft) return Left(verify.left);
    return const Right(null);
  }

  @override
  Future<Either<Failures, void>> resendOTP(String username) async {
    Either<Failures, void> resendOTP =
        await AuthenticationRepository().resendOTP(username);
    if (resendOTP.isLeft) return Left(resendOTP.left);
    return const Right(null);
  }
}
