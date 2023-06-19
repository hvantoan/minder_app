import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/repository/interface/i_stadium_repository.dart';
import 'package:minder/data/service/stadium/stadium_api.dart';
import 'package:minder/domain/entity/stadium/stadium.dart';
import 'package:minder/util/helper/failures_helper.dart';

class StadiumRepository extends StadiumRepositoryInterface {
  @override
  Future<Either<Failures, List<Stadium>>> getStadiums() async {
    try {
      final response = await StadiumAPI().getStadiums();
      final List<Stadium> teams =
          response.map((e) => Stadium.fromModel(e)).toList();
      return Right(teams);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<Either<Failures, List<Stadium>>> getStadiumSuggest(
      {required String matchId}) async {
    try {
      final response = await StadiumAPI().getStadiumSuggest(matchId: matchId);
      final List<Stadium> teams =
          response.map((e) => Stadium.fromModel(e)).toList();
      return Right(teams);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }
}
