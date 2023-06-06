import 'package:either_dart/either.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/model/personal/change_password_request.dart';
import 'package:minder/data/model/personal/user_dto.dart' as dto;
import 'package:minder/domain/entity/user/user.dart';

abstract class UserUseCaseInterface {
  Future<List<User>> getUsers({List<String>? userIds});

  Future<Either<Failures, User>> getMe();

  Future<Either<Failures, dto.UserDto>> getMeDto();

  Future<Either<Failures, User>> getUser({required String uid});

  Future<Either<Failures, dto.UserDto>> updateMe(dto.UserDto user);

  Future<Either<Failures, bool>> changePassword(ChangePasswordRequest request);

  Future<Either<Failures, void>> updateGameTime(GameTime gameTime);

  Future<Either<Failures, void>> updateLocation(LatLng? latLng, int radius);
}
