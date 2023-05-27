import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/repository/implement/group_repository_impl.dart';
import 'package:minder/domain/entity/group/group.dart';
import 'package:minder/domain/usecase/interface/i_group_usecase.dart';

class GroupUsecase extends GroupUsecaseInterface {
  @override
  Future<Either<Failures, List<Group>>> list(
      {required int pageIndex, required int pageSize}) async {
    final response =
        await GroupRepository().list(pageIndex: pageIndex, pageSize: pageSize);
    if (response.isLeft) return Left(response.left);
    return Right(response.right);
  }
}
