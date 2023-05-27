import 'package:either_dart/either.dart';
import 'package:minder/core/exception/exception.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/repository/interface/i_minimum_version_repository.dart';
import 'package:minder/data/service/minimum_version/minimum_version_api.dart';
import 'package:minder/domain/entity/version/app_version.dart';
import 'package:minder/util/helper/failures_helper.dart';

class MinimumVersionRepository implements MinimumVersionRepositoryInterface {
  @override
  Future<Either<Failures, AppVersion>> getMinimumVersion() async {
    try {
      final minVersionModel = await MinimumVersionAPI().getRawMinimumVersion();
      AppVersion? appVersion = AppVersion.fromString(minVersionModel);
      return Right(appVersion!);
    } catch (e) {
      if (e is ResponseException) {
        return Left(FailuresHelper.fromCommonException(e));
      }
      return Left(DataParsingFailures());
    }
  }
}
