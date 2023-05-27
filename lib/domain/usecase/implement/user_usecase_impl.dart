import 'package:either_dart/either.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/model/personal/change_password_request.dart';
import 'package:minder/data/model/personal/user_dto.dart' as dto;
import 'package:minder/data/repository/implement/user_repository_impl.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/domain/usecase/interface/i_user_usecase.dart';

class UserUseCase extends UserUseCaseInterface {
  @override
  Future<Either<Failures, User>> getMe() async {
    final response = await UserRepository().getMe();
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, User>> getUser({required String uid}) async {
    final response = await UserRepository().getUser(uid: uid);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, dto.UserDto>> updateMe(dto.UserDto user) async {
    final response = await UserRepository().updateMe(user);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, bool>> changePassword(
      ChangePasswordRequest request) async {
    final response = await UserRepository().changePassword(request);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, dto.UserDto>> getMeDto() async {
    final response = await UserRepository().getMeDto();
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, List<User>>> getUsers({List<String>? userIds}) async {
    final response = await UserRepository().getUsers(userIds: userIds);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, void>> updateGameTime(GameTime gameTime) async {
    final response = await UserRepository().updateGameTime(gameTime);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, void>> updateLocation(
      LatLng? latLng, int radius) async {
    final response = await UserRepository().updateLocation(latLng, radius);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }
}
