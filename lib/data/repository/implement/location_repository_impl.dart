import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/repository/interface/i_location_repoitory.dart';
import 'package:minder/data/service/location/location_api.dart';
import 'package:minder/domain/entity/location/location.dart';
import 'package:minder/util/helper/failures_helper.dart';

class LocationRepository extends LocationRepositoryInterface {
  @override
  Future<Either<Failures, List<Location>>> getLocationData(String text) async {
    try {
      final response = await LocationAPi().getLocationData(text);
      final List<Location> locations =
          response.map((e) => Location.fromModel(e)).toList();
      return Right(locations);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }
}
