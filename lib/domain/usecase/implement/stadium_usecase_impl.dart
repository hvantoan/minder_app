import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/repository/implement/stadium_repository_impl.dart';
import 'package:minder/domain/entity/stadium/stadium.dart';
import 'package:minder/domain/usecase/interface/i_stadium_usecase.dart';

class StadiumUseCase extends StadiumUseCaseInterface {
  @override
  Future<Either<Failures, List<Stadium>>> getStadiums() async {
    final response = await StadiumRepository().getStadiums();
    if (response.isLeft) {
      return Left(response.left);
    }
    return Right(response.right);
  }
}
