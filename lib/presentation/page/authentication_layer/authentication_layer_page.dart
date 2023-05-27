import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/debug/debug.dart';
import 'package:minder/presentation/bloc/authentication_layer/authentication_layer_cubit.dart';
import 'package:minder/presentation/bloc/user/user_cubit.dart';
import 'package:minder/presentation/page/app_layer/app_loading_page.dart';
import 'package:minder/presentation/page/authentication_layer/login_page.dart';
import 'package:minder/presentation/page/authentication_layer/notification_layer_page.dart';

const String _filePath =
    "lib/presentation/page/authentication_layer/authentication_layer_page.dart";

class AuthenticationLayerPage extends StatefulWidget {
  const AuthenticationLayerPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationLayerPage> createState() =>
      _AuthenticationLayerPageState();
}

class _AuthenticationLayerPageState extends State<AuthenticationLayerPage> {
  @override
  void initState() {
    GetIt.instance.get<AuthenticationLayerCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DebugHelper.printPageBuild(
        filePath: _filePath, widget: "Authentication Layer Page");
    return BlocConsumer<AuthenticationLayerCubit, AuthenticationLayerState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is UnauthenticatedState) {
          return const LoginPage();
        }
        if (state is AuthenticatedState) {
          GetIt.instance.get<UserCubit>().getMe();
          return const NotificationLayerPage();
        }
        return const AppLoadingPage();
      },
    );
  }
}
