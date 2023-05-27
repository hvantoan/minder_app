import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/domain/entity/version/app_version.dart';

abstract class MinimumVersionRepositoryInterface {
  Future<Either<Failures, AppVersion>> getMinimumVersion();
}
