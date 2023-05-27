import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:minder/domain/usecase/implement/file_usecase_impl.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/util/constant/enum/image_enum.dart';

part 'file_controller_state.dart';

class FileControllerCubit extends Cubit<FileControllerState> {
  FileControllerCubit() : super(FileControllerInitial());

  Future<void> create(
      {required String id, required File file, required ImageEnum type}) async {
    final response = await FileUseCase().create(id: id, file: file, type: type);
    if (response.isLeft) {
      emit(FileControllerFailure(S.current.txt_data_parsing_failed));
      return;
    }

    emit(FileControllerSuccess());
  }

  void clean() => emit(FileControllerInitial());
}
