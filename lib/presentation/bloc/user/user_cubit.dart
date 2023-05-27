import 'package:bloc/bloc.dart';
import 'package:minder/core/failures/user_failures.dart';
import 'package:minder/data/model/personal/user_dto.dart';
import 'package:minder/data/model/personal/change_password_request.dart';
import 'package:minder/domain/entity/user/user.dart';
import 'package:minder/domain/usecase/implement/user_usecase_impl.dart';
import 'package:minder/generated/l10n.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  Future<void> getMe() async {
    final response = await UserUseCase().getMe();
    if (response.isLeft) {
      emit(UserError(message: S.current.txt_data_parsing_failed));
      return;
    }
    final dto = await UserUseCase().getMeDto();
    if (dto.isLeft) {
      emit(UserError(message: S.current.txt_data_parsing_failed));
      return;
    }
    emit(UserSuccess(me: response.right, user: dto.right));
  }

  Future<void> getUser({required User me, required String uid}) async {
    final response = await UserUseCase().getUser(uid: uid);
    if (response.isLeft) {
      emit(UserError(message: S.current.txt_data_parsing_failed));
      return;
    }
    emit(UserSuccess(me: me, other: response.right));
  }

  Future<void> updateMe(UserDto user) async {
    final response = await UserUseCase().updateMe(user);
    if (response.isLeft) {
      emit(UserError(message: S.current.txt_data_parsing_failed));
      return;
    }
    emit(UserSuccess(user: response.right));
  }

  void clean() => emit(UserInitial());

  Future<bool> changePassword(ChangePasswordRequest request) async {
    final response = await UserUseCase().changePassword(request);
    if (response.isLeft) {
      if (response.left is OldPasswordNotMatchFailures) {
        emit(UserOldPasswordNotMatchState());
        return false;
      }
      emit(UserError(message: S.current.txt_data_parsing_failed));
      return false;
    }
    return true;
  }
}
