import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minder/core/exception/common_exception.dart';
import 'package:minder/core/exception/user_exception.dart';
import 'package:minder/core/service/base_api_service.dart';
import 'package:minder/core/service/base_response.dart';
import 'package:minder/data/model/personal/change_password_request.dart';
import 'package:minder/data/model/personal/user_dto.dart' as dto;
import 'package:minder/data/model/personal/user_model.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/util/constant/path/service_path.dart';

class UserAPI {
  Future<List<UserModel>> getUsers({List<String>? userIds}) async {
    try {
      final BaseResponse response = await BaseAPIService.post(
          uri: ServicePath.user,
          withToken: true,
          params: userIds != null ? {"userIds": userIds} : {});
      if (response.isSuccess) {
        final List<UserModel> userModels = List.empty(growable: true);
        userModels.addAll((response.data!["items"] as List)
            .map((e) => UserModel.fromJson(e)));
        return userModels;
      }
      throw DataParsingException();
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getUserById({required String id}) async {
    try {
      final BaseResponse response = await BaseAPIService.get(
          uri: "${ServicePath.user}/$id", withToken: true);
      if (response.isSuccess) {
        final UserModel userModel = UserModel.fromJson(response.data!);
        return userModel;
      }
      throw DataParsingException();
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getMe() async {
    try {
      final BaseResponse response = await BaseAPIService.get(
          uri: "${ServicePath.user}/me", withToken: true);
      if (response.isSuccess) {
        final userModel = UserModel.fromJson(response.data!);
        return userModel;
      }
      throw DataParsingException();
    } catch (e) {
      rethrow;
    }
  }

  Future<dto.UserDto> getMeDto() async {
    try {
      final BaseResponse response = await BaseAPIService.get(
          uri: "${ServicePath.user}/me", withToken: true);

      if (response.isSuccess) {
        final userModel = dto.UserDto.fromJson(response.data!);
        return userModel;
      }
      throw DataParsingException();
    } catch (e) {
      rethrow;
    }
  }

  Future<dto.UserDto> updateMe(dto.UserDto user) async {
    try {
      final BaseResponse response = await BaseAPIService.post(
        params: user.toJson(),
        uri: "${ServicePath.user}/save",
        withToken: true,
      );

      if (response.isSuccess) {
        return dto.UserDto.fromJson(response.data!);
      }
      throw DataParsingException();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> changePassword(ChangePasswordRequest request) async {
    try {
      final BaseResponse response = await BaseAPIService.post(
        params: request.toMap(),
        uri: "${ServicePath.user}/change-password",
        withToken: true,
      );
      switch (response.statusCode) {
        case 10:
          throw OldPasswordNotMatch();
      }
      return response.isSuccess;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateGameTime(GameTime gameTime) async {
    try {
      await BaseAPIService.post(
        params: {
          "gameSetting": {
            "gameTime": {
              "monday": gameTime.monday ?? [],
              "tuesday": gameTime.tuesday ?? [],
              "wednesday": gameTime.wednesday ?? [],
              "thursday": gameTime.thursday ?? [],
              "friday": gameTime.friday ?? [],
              "saturday": gameTime.saturday ?? [],
              "sunday": gameTime.sunday ?? []
            }
          }
        },
        uri: ServicePath.saveUser,
        withToken: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateLocation(LatLng? latLng, int radius) async {
    try {
      final params = latLng != null
          ? {
              "gameSetting": {
                "latitude": latLng.latitude,
                "longitude": latLng.longitude,
                "radius": radius
              }
            }
          : {
              "gameSetting": {"radius": radius}
            };

      await BaseAPIService.post(
        params: params,
        uri: ServicePath.saveUser,
        withToken: true,
      );
    } catch (e) {
      rethrow;
    }
  }
}
