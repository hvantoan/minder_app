import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/domain/entity/match/match.dart' as match;

abstract class MatchRepositoryInterface {
  Future<Either<Failures, List<match.Match>>> getTeamMatches(String teamId);

  Future<Either<Failures, void>> swipe(
      String hostTeamId, String opposingTeamId, bool hasInvite);

  Future<Either<Failures, match.Match>> getMatchById(String matchId);

  Future<Either<Failures, void>> selectTime(String matchId, DateTime date,
      num dayOfWeek, match.TimeOption timeOption, String teamId);

  Future<Either<Failures, void>> selectStadium(
      String matchId, String stadiumId, String teamId);

  Future<Either<Failures, void>> check(String matchId);
}
