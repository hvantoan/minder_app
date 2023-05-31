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
      final response =
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
      return Right(match.Match.fromModel(response));
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, void>> selectStadium(
      String matchId, String stadiumId, String teamId) async {
    try {
      final response =
          await MatchAPI().selectStadium(matchId, stadiumId, teamId);
      return const Right(null);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, void>> selectTime(String matchId, num dayOfWeek,
      match.TimeOption timeOption, String teamId) async {
    try {
      final response =
          await MatchAPI().selectTime(matchId, dayOfWeek, timeOption, teamId);
      return const Right(null);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, void>> check(String matchId) async {
    try {
      final response = await MatchAPI().check(matchId);
      return const Right(null);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }
}
