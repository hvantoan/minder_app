import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/repository/implement/location_repository_impl.dart';
import 'package:minder/domain/entity/location/location.dart';
import 'package:minder/domain/usecase/interface/i_location_usecase.dart';

class LocationUseCase extends LocationUseCaseInterface {
  @override
  Future<Either<Failures, List<Location>>> getLocationData(String text) async {
    final response = await LocationRepository().getLocationData(text);
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }
}
