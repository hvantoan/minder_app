import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/util/constant/enum/image_enum.dart';

abstract class FileRepositoryInterface {
  Future<Either<Failures, void>> create(
      {required String id, required File file, required ImageEnum type});
}
