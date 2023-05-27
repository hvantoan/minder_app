import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minder/core/failures/authentication_failures.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/model/authentication/login_model.dart';
import 'package:minder/domain/usecase/Implement/authentication_usecase_impl.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginDefaultState());

  Future<bool> login(
      {required BuildContext context,
      required String username,
      required String password}) async {
    Either<Failures, void> loginRepository =
        await AuthenticationUseCase().login(LoginModel(username, password));
    if (loginRepository.isLeft) {
      if (loginRepository.left is UnregisteredUsernameFailures) {
        emit(UnregisteredUsernameState());
        return false;
      }
      if (loginRepository.left is WrongPasswordFailures) {
        emit(WrongPasswordState());
        return false;
      }
      if (loginRepository.left is ServerFailures ||
          loginRepository.left is AuthorizationFailures) {
        emit(DisconnectState());
        return false;
      }
      emit(ErrorState());
      return false;
    }
    return true;
  }
}
