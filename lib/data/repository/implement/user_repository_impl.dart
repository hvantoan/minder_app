import 'package:either_dart/either.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minder/core/exception/user_exception.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/core/failures/user_failures.dart';
import 'package:minder/data/model/personal/change_password_request.dart';
import 'package:minder/data/model/personal/user_dto.dart' as dto;
import 'package:minder/data/repository/interface/i_user_repository.dart';
import 'package:minder/data/service/user/user_api.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/util/helper/failures_helper.dart';

class UserRepository extends UserRepositoryInterface {
  @override
  Future<Either<Failures, User>> getMe() async {
    try {
      final response = await UserAPI().getMe();
      User user = User.fromModel(response);
      return Right(user);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, User>> getUser({required String uid}) async {
    try {
      final response = await UserAPI().getUserById(id: uid);
      final User user = User.fromModel(response);
      return Right(user);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, dto.UserDto>> updateMe(dto.UserDto user) async {
    try {
      final response = await UserAPI().updateMe(user);
      return Right(response);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, bool>> changePassword(
      ChangePasswordRequest request) async {
    try {
      final response = await UserAPI().changePassword(request);
      return Right(response);
    } catch (e) {
      if (e is OldPasswordNotMatch) {
        return Left(OldPasswordNotMatchFailures());
      }
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, dto.UserDto>> getMeDto() async {
    try {
      final response = await UserAPI().getMeDto();
      return Right(response);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, List<User>>> getUsers({List<String>? userIds}) async {
    try {
      final response = await UserAPI().getUsers(userIds: userIds);
      final List<User> users =
          response.map((userModel) => User.fromModel(userModel)).toList();
      return Right(users);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, void>> updateGameTime(GameTime gameTime) async {
    try {
      await UserAPI().updateGameTime(gameTime);
      return const Right(null);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, void>> updateLocation(
      LatLng? latLng, int radius) async {
    try {
      await UserAPI().updateLocation(latLng, radius);
      return const Right(null);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }
}
