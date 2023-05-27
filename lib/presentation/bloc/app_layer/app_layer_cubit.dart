import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/domain/entity/version/app_version.dart';
import 'package:minder/domain/usecase/Implement/minimum_version_impl.dart';
import 'package:minder/util/helper/version_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'app_layer_state.dart';

class AppLayerCubit extends Cubit<AppLayerState> {
  /// This is the second cubit of project.
  /// It handle network connect state, app version, media controller and loading layer.
  AppLayerCubit() : super(AppLayerInitialState());

  Future<void> init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Either<Failures, AppVersion> minimumRepository =
        await MinimumVersionUseCase().getMinimumVersion();
    if (minimumRepository.isLeft) {
      if (minimumRepository.left is ServerFailures ||
          minimumRepository.left is AuthorizationFailures) {
        emit(AppDisconnectedState());
        return;
      }
      if (minimumRepository.left is DataParsingFailures ||
          minimumRepository.left is ResponseDataParsingFailures) {
        emit(ErrorDataParsingState());
        return;
      }
    }
    if (minimumRepository.isRight) {
      bool? isSupportedVersion =
          await VersionHelper.isSupportedVersion(minimumRepository.right);
      if (isSupportedVersion == null) {
        emit(ErrorDataParsingState());
        return;
      }
      if (isSupportedVersion == false) {
        emit(UnsupportedVersionState(
            AppVersion.toDisplayString(minimumRepository.right),
            packageInfo.version));
        return;
      }
    }
    emit(AppCheckedState());
  }

  Future<void> retry() async {
    emit(AppLayerInitialState());
    init();
  }
}
