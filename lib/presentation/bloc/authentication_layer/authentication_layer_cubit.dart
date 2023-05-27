import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minder/util/helper/token_helper.dart';

part 'authentication_layer_state.dart';

class AuthenticationLayerCubit extends Cubit<AuthenticationLayerState> {
  /// This is the third cubit of project.
  /// It handle authentication state, account role, token storage.
  AuthenticationLayerCubit() : super(AuthenticationLayerInitialState());

  Future<void> init() async {
    authenticate();
  }

  Future<void> authenticate([State? state]) async {
    TokenHelper.checkToken().then((value) {
      if (value) {
        emit(AuthenticatedState());
      } else {
        emit(UnauthenticatedState());
      }
    });
  }

  void logout(BuildContext? context) {
    emit(UnauthenticatedState());
    clearAuthenticationData();
  }

  Future<void> clearAuthenticationData() async {
    // TODO: Clear all
    TokenHelper.removeToken();
  }
}
