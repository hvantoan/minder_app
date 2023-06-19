import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/repository/interface/i_match_repository.dart';
import 'package:minder/data/service/match/match_api.dart';
import 'package:minder/domain/entity/match/match.dart' as match;
import 'package:minder/util/helper/failures_helper.dart';

class MatchRepository extends MatchRepositoryInterface {
  @override
  Future<Either<Failures, List<match.Match>>> getTeamMatches(
      String teamId) async {
    try {
      final response = await MatchAPI().getTeamMatch(teamId);
      final List<match.Match> matches =
          response.map((e) => match.Match.fromModel(e)).toList();

      return Right(matches);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, void>> swipe(
      String hostTeamId, String opposingTeamId, bool hasInvite) async {
    try {
      await MatchAPI().swipe(hostTeamId, opposingTeamId, hasInvite);
      return const Right(null);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, match.Match>> getMatchById(String matchId) async {
    try {
      final response = await MatchAPI().getMatchById(matchId);
      final result = match.Match.fromModel(response);
      return Right(result);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, void>> selectStadium(
      String matchId, String stadiumId, String teamId) async {
    try {
      await MatchAPI().selectStadium(matchId, stadiumId, teamId);
      return const Right(null);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, void>> selectTime(String matchId, DateTime date,
      num dayOfWeek, match.TimeOption timeOption, String teamId) async {
    try {
      await MatchAPI().selectTime(matchId, date, dayOfWeek, timeOption, teamId);
      return const Right(null);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, void>> addTimeOption(
      String matchId, DateTime date, num from, num to) async {
    try {
      await MatchAPI().addTimeOption(matchId, date, from, to);
      return const Right(null);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, void>> confirmSettingMatch(
      String matchId, String teamId) async {
    try {
      await MatchAPI().confirmSettingMatch(matchId, teamId);
      return const Right(null);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, void>> memberConfirm(
      String matchId, String userId) async {
    try {
      await MatchAPI().memberConfirm(matchId, userId);
      return const Right(null);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }
}
