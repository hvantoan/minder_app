import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/presentation/bloc/app_layer/app_layer_cubit.dart';
import 'package:minder/presentation/bloc/authentication_layer/authentication_layer_cubit.dart';
import 'package:minder/presentation/bloc/base_layer/base_layer_cubit.dart';
import 'package:minder/presentation/bloc/file/controller/file_controller_cubit.dart';
import 'package:minder/presentation/bloc/group/group_cubit.dart';
import 'package:minder/presentation/bloc/location/data/locations/locations_cubit.dart';
import 'package:minder/presentation/bloc/login/login_cubit.dart';
import 'package:minder/presentation/bloc/match/controller/match_controller_cubit.dart';
import 'package:minder/presentation/bloc/match/data/match/match_cubit.dart';
import 'package:minder/presentation/bloc/match/data/matches/matches_cubit.dart';
import 'package:minder/presentation/bloc/message/message_cubit.dart';
import 'package:minder/presentation/bloc/notification_layer/notification_layer_cubit.dart';
import 'package:minder/presentation/bloc/otp/otp_cubit.dart';
import 'package:minder/presentation/bloc/stadium/data/stadiums/stadiums_cubit.dart';
import 'package:minder/presentation/bloc/team/controller/team_controller_cubit.dart';
import 'package:minder/presentation/bloc/team/data/find_member/find_member_cubit.dart';
import 'package:minder/presentation/bloc/team/data/find_team/find_team_cubit.dart';
import 'package:minder/presentation/bloc/team/data/team/team_cubit.dart';
import 'package:minder/presentation/bloc/team/data/teams/team_cubit.dart';
import 'package:minder/presentation/bloc/user/controller/user_controller_cubit.dart';
import 'package:minder/presentation/bloc/user/user_cubit.dart';
import 'package:minder/presentation/injection/injection.dart';
import 'package:minder/presentation/page/base_layer/base_layer_page.dart';

import 'debug/debug.dart';

const String _filePath = "lib/main.dart";

Future<void> main() async {
  setOrientations();
  await configureDependencies();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

void setOrientations() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DebugHelper.printPageBuild(filePath: _filePath, widget: "MyApp");
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: GetIt.instance.get<BaseLayerCubit>()),
        BlocProvider.value(value: GetIt.instance.get<AppLayerCubit>()),
        BlocProvider.value(
            value: GetIt.instance.get<AuthenticationLayerCubit>()),
        BlocProvider.value(value: GetIt.instance.get<LoginCubit>()),
        BlocProvider.value(value: GetIt.instance.get<OTPCubit>()),
        BlocProvider.value(value: GetIt.instance.get<TeamCubit>()),
        BlocProvider.value(value: GetIt.instance.get<TeamControllerCubit>()),
        BlocProvider.value(value: GetIt.instance.get<UserCubit>()),
        BlocProvider.value(value: GetIt.instance.get<MessageCubit>()),
        BlocProvider.value(value: GetIt.instance.get<GroupCubit>()),
        BlocProvider.value(value: GetIt.instance.get<NotificationLayerCubit>()),
        BlocProvider.value(value: GetIt.instance.get<UserControllerCubit>()),
        BlocProvider.value(value: GetIt.instance.get<FindTeamCubit>()),
        BlocProvider.value(value: GetIt.instance.get<FindMemberCubit>()),
        BlocProvider.value(value: GetIt.instance.get<FileControllerCubit>()),
        BlocProvider.value(value: GetIt.instance.get<StadiumsCubit>()),
        BlocProvider.value(value: GetIt.instance.get<TeamsCubit>()),
        BlocProvider.value(value: GetIt.instance.get<LocationsCubit>()),
        BlocProvider.value(value: GetIt.instance.get<MatchesCubit>()),
        BlocProvider.value(value: GetIt.instance.get<MatchControllerCubit>()),
        BlocProvider.value(value: GetIt.instance.get<MatchCubit>()),
      ],
      child: buildSystemUiOverlay(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Widget buildSystemUiOverlay() {
  DebugHelper.printPageBuild(filePath: _filePath, widget: "System UI Overlay");
  return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark, child: BaseLayerPage());
}
