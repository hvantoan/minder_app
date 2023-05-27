import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/repository/interface/i_file_repository.dart';
import 'package:minder/data/service/file/file_api.dart';
import 'package:minder/util/constant/enum/image_enum.dart';
import 'package:minder/util/helper/failures_helper.dart';

class FileRepository extends FileRepositoryInterface {
  @override
  Future<Either<Failures, void>> create(
      {required String id, required File file, required ImageEnum type}) async {
    try {
      await FileAPI().create(id: id, file: file, type: type);
      return const Right(null);
    } catch (e) {
      return Left(FailuresHelper.fromCommonException(e));
    }
  }
}
