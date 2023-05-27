import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minder/core/failures/authentication_failures.dart';
import 'package:minder/core/failures/failures.dart';
import 'package:minder/data/model/authentication/register_model.dart';
import 'package:minder/domain/usecase/Implement/authentication_usecase_impl.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterDefaultState());

  Future<bool> register({
    required BuildContext context,
    required String name,
    required String username,
    required String password,
    required String phone,
  }) async {
    Either<Failures, void> registerRepository = await AuthenticationUseCase()
        .register(RegisterModel(name, username, password, phone));
    if (registerRepository.isLeft) {
      if (registerRepository.left is EmptyNameFailures) {
        emit(RegisteredUsernameState());
        return false;
      }
      if (registerRepository.left is RegisteredUsernameFailures) {
        emit(RegisteredUsernameState());
        return false;
      }

      if (registerRepository.left is ServerFailures ||
          registerRepository.left is AuthorizationFailures) {
        emit(DisconnectState());
        return false;
      }
      emit(ErrorState());
      return false;
    }
    return true;
  }
}
