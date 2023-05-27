import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/repository/implement/minimum_version_repository_impl.dart';
import 'package:minder/domain/entity/version/app_version.dart';
import 'package:minder/domain/usecase/Interface/i_minimum_version_usecase.dart';

class MinimumVersionUseCase extends MinimumVersionUseCaseInterface {
  @override
  Future<Either<Failures, AppVersion>> getMinimumVersion() async {
    Either<Failures, AppVersion> getMinimumVersion =
        await MinimumVersionRepository().getMinimumVersion();
    if (getMinimumVersion.isLeft) return Left(getMinimumVersion.left);
    return Right(getMinimumVersion.right);
  }
}
