import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/domain/entity/group/group.dart';

abstract class GroupUsecaseInterface {
  Future<Either<Failures, List<Group>>> list(
      {required int pageIndex, required int pageSize});
}
