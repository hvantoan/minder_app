import 'dart:io';

import 'package:minder/core/exception/common_exception.dart';
import 'package:minder/core/exception/team_exception.dart';
import 'package:minder/core/service/base_api_service.dart';
import 'package:minder/core/service/base_response.dart';
import 'package:minder/data/model/personal/invite_model.dart';
import 'package:minder/data/model/personal/team_model.dart';
import 'package:minder/data/model/personal/user_model.dart';
import 'package:minder/domain/entity/team/team.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/util/constant/path/service_path.dart';

class TeamAPI {
  Future<List<TeamModel>> getTeams({bool isMyTeam = true}) async {
    try {
      final BaseResponse response = await BaseAPIService.get(
          uri: "${ServicePath.getTeam}?isMyTeam=1", withToken: true);
      if (response.isSuccess) {
        final List<TeamModel> teamModels =
            (response.data!["items"] as List).map((team) {
          return TeamModel.fromJson(team);
        }).toList();
        return teamModels;
      }
      throw DataParsingException();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<InviteModel>> getInvitedTeams({String? teamId}) async {
    try {
      final BaseResponse response = await BaseAPIService.post(
          uri: ServicePath.invites,
          withToken: true,
          params: teamId != null ? {"TeamId": teamId} : {});
      if (response.isSuccess) {
        final List<InviteModel> inviteModels = List.empty(growable: true);
        for (var element in (response.data!["items"] as List)) {
          final inviteModel = InviteModel.fromJson(element);
          inviteModels.add(inviteModel);
        }
        return inviteModels;
      }
      throw DataParsingException();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> createTeam({
    required String name,
    required String code,
    required int level,
    required List<int> stadiumType,
    String? description,
    File? avatarData,
    File? coverData,
  }) async {
    try {
      final BaseResponse response = await BaseAPIService.post(
          uri: ServicePath.saveTeam,
          withToken: true,
          params: {
            "name": name,
            "code": code,
            "gameSetting": GameSettingModel(
                    gameTypes: stadiumType.cast<num>(), rank: level)
                .toJson(),
            "description": description,
            "avatarData":
                avatarData != null ? avatarData.readAsBytesSync() : [],
            "coverData": coverData != null ? coverData.readAsBytesSync() : []
          });
      if (response.statusCode == 31) {
        throw TeamCodeExistException();
      }
      if (response.statusCode == 36) {
        throw HaveTeamException();
      }

      return response.data!["id"].toString();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTeam(
      {required String id,
      required String name,
      required String code,
      required int level,
      required List<int> stadiumType,
      String? description}) async {
    try {
      final BaseResponse response = await BaseAPIService.post(
          uri: ServicePath.saveTeam,
          withToken: true,
          params: {
            "id": id,
            "name": name,
            "code": code,
            "gameSetting": GameSettingModel(
                    gameTypes: stadiumType.cast<num>(), rank: level)
                .toJson(),
            "description": description
          });
      if (response.statusCode == 31) {
        throw TeamCodeExistException();
      }
      if (response.statusCode == 36) {
        throw HaveTeamException();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<TeamModel> getTeamById({required String teamId}) async {
    try {
      final BaseResponse response = await BaseAPIService.get(
          uri: "${ServicePath.getTeam}/$teamId", withToken: true);
      if (response.statusCode == 35) {
        throw TeamNotExistException();
      }
      if (response.isSuccess) {
        final TeamModel teamModel = TeamModel.fromJson(response.data!);
        return teamModel;
      }
      throw DataParsingException();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> accept({required String id, bool isJoin = true}) async {
    try {
      await BaseAPIService.post(
          uri: "${ServicePath.invites}/${ServicePath.confirm}",
          withToken: true,
          params: {"id": id, "isJoin": isJoin});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> joinTeam({required String teamId, String? userId}) async {
    try {
      final BaseResponse response = await BaseAPIService.post(
          uri: "${ServicePath.invites}/${ServicePath.create}",
          withToken: true,
          params: {
            "TeamId": teamId,
            "Type": 1,
          });
      if (response.statusCode == 64) {
        throw AlreadyJoinRequestException();
      }
      if (response.statusCode == 60) {
        throw AlreadyInviteException();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> kick({required String userId}) async {
    try {
      await BaseAPIService.get(
          uri: "${ServicePath.getTeam}/$userId/${ServicePath.kick}",
          withToken: true);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> leave({required String teamId}) async {
    try {
      final BaseResponse response = await BaseAPIService.get(
          uri: "${ServicePath.getTeam}/$teamId/${ServicePath.leave}",
          withToken: true);
      if (response.statusCode == 36) {
        throw HaveTeamException();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateGameTime(Team team) async {
    try {
      if (team.isAutoTime ?? false) {
        final gameTime =
            GameTimeModel.fromJson((await _autoCall(2, team.id)).data);
        team.gameSetting?.gameTime = GameTime.fromModel(gameTime);
      }

      await BaseAPIService.post(
        params: {
          "id": team.id,
          "code": team.code,
          "name": team.name,
          "isAutoTime": team.isAutoTime ?? false,
          "isAutoLocation": team.isAutoLocation ?? false,
          "gameSetting": {
            "gameTime": {
              "id": team.gameSetting?.gameTime?.id,
              "monday": team.gameSetting?.gameTime?.monday ?? [],
              "tuesday": team.gameSetting?.gameTime?.tuesday ?? [],
              "wednesday": team.gameSetting?.gameTime?.wednesday ?? [],
              "thursday": team.gameSetting?.gameTime?.thursday ?? [],
              "friday": team.gameSetting?.gameTime?.friday ?? [],
              "saturday": team.gameSetting?.gameTime?.saturday ?? [],
              "sunday": team.gameSetting?.gameTime?.sunday ?? []
            }
          }
        },
        uri: ServicePath.saveTeam,
        withToken: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateLocation(Team team) async {
    try {
      if (team.isAutoLocation ?? false) {
        final response = await _autoCall(1, team.id);
        team.gameSetting?.latitude = response.data!["latitude"];
        team.gameSetting?.longitude = response.data!["longitude"];
      }

      await BaseAPIService.post(
        params: {
          "id": team.id,
          "code": team.code,
          "name": team.name,
          "isAutoTime": team.isAutoTime ?? false,
          "isAutoLocation": team.isAutoLocation ?? false,
          "gameSetting": {
            "longitude": team.gameSetting?.longitude,
            "latitude": team.gameSetting?.latitude
          }
        },
        uri: ServicePath.saveTeam,
        withToken: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponse> _autoCall(int type, String teamId) async {
    try {
      return await BaseAPIService.get(
        uri: "${ServicePath.autoCal}/$teamId/?type=$type",
        withToken: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> getSuggest({required String teamId}) async {
    try {
      final BaseResponse response = await BaseAPIService.post(
          uri: ServicePath.suggestUser,
          withToken: true,
          params: {"teamId": teamId});
      if (response.isSuccess) {
        final List<UserModel> userModels = List.empty(growable: true);
        final data = response.data!["items"];
        for (var element in (data as List)) {
          final UserModel userModel = UserModel.fromJson(element);
          userModels.add(userModel);
        }
        return userModels;
      }
      throw DataParsingException();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> inviteUser(
      {required String teamId,
      required String userId,
      required bool hasInvite}) async {
    try {
      await BaseAPIService.post(
          uri: "${ServicePath.invites}/${ServicePath.swipe}",
          withToken: true,
          params: {"teamId": teamId, "userId": userId, "hasInvite": hasInvite});
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TeamModel>> getSuggestTeam({required String teamId}) async {
    try {
      final BaseResponse response = await BaseAPIService.post(
          uri: ServicePath.suggestTeam,
          withToken: true,
          params: {"teamId": teamId});
      if (response.isSuccess) {
        final List<TeamModel> teamModels = List.empty(growable: true);
        final data = response.data!["items"];
        for (var element in (data as List)) {
          final TeamModel teamModel = TeamModel.fromJson(element);
          teamModels.add(teamModel);
        }
        return teamModels;
      }
      throw DataParsingException();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TeamModel>> find({
    int pageIndex = 0,
    int pageSize = 10,
    int? member,
    int? rank,
    int? age,
    int? position,
    int? gameType,
    int? day,
    int? time,
  }) async {
    try {
      final BaseResponse response = await BaseAPIService.post(
          uri: ServicePath.findTeam,
          withToken: true,
          params: {
            "pageIndex": pageIndex,
            "pageSize": pageSize,
            "member": member,
            "rank": rank,
            "age": age,
            "position": position,
            "gameType": gameType,
            "day": day,
            "time": time
          });
      if (response.isSuccess) {
        final List<TeamModel> teamModels = List.empty(growable: true);
        final data = response.data!["items"];
        for (var element in (data as List)) {
          final TeamModel teamModel = TeamModel.fromJson(element);
          teamModels.add(teamModel);
        }
        return teamModels;
      }
      throw DataParsingException();
    } catch (e) {
      rethrow;
    }
  }
}
