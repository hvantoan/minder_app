import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/repository/implement/file_repository_impl.dart';
import 'package:minder/domain/usecase/interface/i_file_usecase.dart';
import 'package:minder/util/constant/enum/image_enum.dart';

class FileUseCase extends FileUseCaseInterface {
  @override
  Future<Either<Failures, void>> create(
      {required String id, required File file, required ImageEnum type}) async {
    final response =
        await FileRepository().create(id: id, file: file, type: type);
    if (response.isLeft) return Left(response.left);
    return Right(response.right);
  }
}
