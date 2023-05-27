import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/repository/implement/match_repository.dart';
import 'package:minder/domain/entity/match/match.dart' as match;
import 'package:minder/domain/usecase/interface/i_match_usecase.dart';

class MatchUseCase extends MatchUseCaseInterface {
  @override
  Future<Either<Failures, List<match.Match>>> getTeamMatches(
      String teamId) async {
    final response = await MatchRepository().getTeamMatches(teamId);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, void>> swipe(
      String hostTeamId, String opposingTeamId, bool hasInvite) async {
    final response =
        await MatchRepository().swipe(hostTeamId, opposingTeamId, hasInvite);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, match.Match>> getMatchById(String matchId) async {
    final response = await MatchRepository().getMatchById(matchId);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, void>> selectStadium(
      String matchId, String stadiumId, String teamId) async {
    final response =
        await MatchRepository().selectStadium(matchId, stadiumId, teamId);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, void>> selectTime(String matchId, num dayOfWeek,
      match.TimeOption timeOption, String teamId) async {
    final response = await MatchRepository()
        .selectTime(matchId, dayOfWeek, timeOption, teamId);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }

  @override
  Future<Either<Failures, void>> check(String matchId) async {
    final response = await MatchRepository().check(matchId);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }
}
