import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/repository/interface/i_group_repository.dart';
import 'package:minder/data/service/group/group_api.dart';
import 'package:minder/domain/entity/group/group.dart';
import 'package:minder/util/helper/failures_helper.dart';

class GroupRepository extends GroupRepositoryInterface {
  @override
  Future<Either<Failures, List<Group>>> list(
      {required int pageIndex, required int pageSize}) async {
    try {
      var groupModels =
          await GroupAPI().list(pageIndex: pageIndex, pageSize: pageSize);
      return Right(groupModels.map((e) => Group.fromModel(e)).toList());
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }

  @override
  Future<void> create({required List<String> userIds}) async {
    await GroupAPI().create(userIds: userIds);
  }
}
