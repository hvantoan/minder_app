import 'package:minder/core/exception/common_exception.dart';
import 'package:minder/core/service/base_api_service.dart';
import 'package:minder/core/service/base_response.dart';
import 'package:minder/data/model/match/match_model.dart';
import 'package:minder/domain/entity/match/match.dart';
import 'package:minder/util/constant/path/service_path.dart';

class MatchAPI {
  Future<List<MatchModel>> getTeamMatch(String teamId) async {
    try {
      final BaseResponse response = await BaseAPIService.post(
          uri: ServicePath.matches,
          withToken: true,
          params: {"teamId": teamId});
      if (response.isSuccess) {
        final List<MatchModel> matchModels =
            (response.data!["items"] as List).map((matchModel) {
          return MatchModel.fromJson(matchModel);
        }).toList();
        return matchModels;
      }
      throw DataParsingException();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> swipe(
    String hostTeamId,
    String opposingTeamId,
    bool hasInvite,
  ) async {
    try {
      await BaseAPIService.post(
          uri: "${ServicePath.matches}/${ServicePath.swipe}",
          withToken: true,
          params: {
            "hostTeamId": hostTeamId,
            "opposingTeamId": opposingTeamId,
            "hasInvite": hasInvite
          });
    } catch (e) {
      rethrow;
    }
  }

  Future<MatchModel> getMatchById(String matchId) async {
    try {
      final BaseResponse response = await BaseAPIService.get(
        uri: "${ServicePath.matches}/$matchId",
        withToken: true,
      );
      if (response.isSuccess) {
        return MatchModel.fromJson(response.data!);
      }
      throw DataParsingException();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> selectTime(String matchId, DateTime date, num dayOfWeek,
      TimeOption timeOption, String teamId) async {
    try {
      await BaseAPIService.post(
        uri: "${ServicePath.matches}/$matchId/${ServicePath.selectTime}",
        withToken: true,
        params: {
          "teamId": teamId,
          "dayOfWeek": dayOfWeek,
          "from": timeOption.from,
          "to": timeOption.to,
          "date": date.toString()
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> selectStadium(
      String matchId, String stadiumId, String teamId) async {
    try {
      await BaseAPIService.post(
        uri: "${ServicePath.matches}/$matchId/${ServicePath.selectStadium}",
        withToken: true,
        params: {
          "teamId": teamId,
          "stadiumId": stadiumId,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> confirmSettingMatch(String matchId, String teamId) async {
    try {
      await BaseAPIService.get(
        uri:
            "${ServicePath.matches}/$matchId/${ServicePath.confirmSettingMatch}?teamId=$teamId",
        withToken: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTimeOption(
    String matchId,
    DateTime date,
    num from,
    num to,
  ) async {
    try {
      await BaseAPIService.post(
        uri: "${ServicePath.matches}/${ServicePath.addTimeOption}",
        withToken: true,
        params: {
          "matchId": matchId,
          "date": date.toUtc().toString(),
          "from": from,
          "to": to
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> memberConfirm(String matchId, String userId) async {
    try {
      await BaseAPIService.get(
        uri:
            "${ServicePath.matches}/$matchId/${ServicePath.memberConfirm}?userId=$userId",
        withToken: true,
      );
    } catch (e) {
      rethrow;
    }
  }
}
