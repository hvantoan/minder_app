import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/domain/entity/location/location.dart';

abstract class LocationRepositoryInterface {
  Future<Either<Failures, List<Location>>> getLocationData(String text);
}
