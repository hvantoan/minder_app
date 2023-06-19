import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/domain/entity/stadium/stadium.dart';

abstract class StadiumRepositoryInterface {
  Future<Either<Failures, List<Stadium>>> getStadiums();
  Future<Either<Failures, List<Stadium>>> getStadiumSuggest(
      {required String matchId});
}
