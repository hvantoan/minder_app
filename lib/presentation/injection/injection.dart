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
import 'package:minder/presentation/bloc/register/register_cubit.dart';
import 'package:minder/presentation/bloc/stadium/data/stadiums/stadiums_cubit.dart';
import 'package:minder/presentation/bloc/team/controller/team_controller_cubit.dart';
import 'package:minder/presentation/bloc/team/data/find_member/find_member_cubit.dart';
import 'package:minder/presentation/bloc/team/data/find_team/find_team_cubit.dart';
import 'package:minder/presentation/bloc/team/data/team/team_cubit.dart';
import 'package:minder/presentation/bloc/team/data/teams/team_cubit.dart';
import 'package:minder/presentation/bloc/user/controller/user_controller_cubit.dart';
import 'package:minder/presentation/bloc/user/user_cubit.dart';
import 'package:minder/util/controller/loading_cover_controller.dart';

Future<void> configureDependencies() async {
  /// BloC
  GetIt.instance.registerLazySingleton<BaseLayerCubit>(() => BaseLayerCubit());
  GetIt.instance.registerLazySingleton<AppLayerCubit>(() => AppLayerCubit());
  GetIt.instance.registerLazySingleton<AuthenticationLayerCubit>(
      () => AuthenticationLayerCubit());

  GetIt.instance.registerLazySingleton<LoginCubit>(() => LoginCubit());
  GetIt.instance.registerLazySingleton<RegisterCubit>(() => RegisterCubit());
  GetIt.instance.registerLazySingleton<OTPCubit>(() => OTPCubit());

  GetIt.instance.registerLazySingleton<TeamCubit>(() => TeamCubit());
  GetIt.instance.registerLazySingleton<TeamsCubit>(() => TeamsCubit());
  GetIt.instance.registerLazySingleton<FindTeamCubit>(() => FindTeamCubit());
  GetIt.instance
      .registerLazySingleton<FindMemberCubit>(() => FindMemberCubit());
  GetIt.instance
      .registerLazySingleton<TeamControllerCubit>(() => TeamControllerCubit());

  GetIt.instance.registerLazySingleton<UserCubit>(() => UserCubit());

  GetIt.instance.registerLazySingleton<GroupCubit>(() => GroupCubit());
  GetIt.instance.registerLazySingleton<MessageCubit>(() => MessageCubit());
  GetIt.instance.registerLazySingleton<NotificationLayerCubit>(
      () => NotificationLayerCubit());
  GetIt.instance
      .registerLazySingleton<FileControllerCubit>(() => FileControllerCubit());
  GetIt.instance
      .registerLazySingleton<UserControllerCubit>(() => UserControllerCubit());
  GetIt.instance.registerLazySingleton<StadiumsCubit>(() => StadiumsCubit());
  GetIt.instance.registerLazySingleton<LocationsCubit>(() => LocationsCubit());
  GetIt.instance.registerLazySingleton<MatchesCubit>(() => MatchesCubit());
  GetIt.instance.registerLazySingleton<MatchControllerCubit>(
      () => MatchControllerCubit());
  GetIt.instance.registerLazySingleton<MatchCubit>(() => MatchCubit());

  /// Controller
  GetIt.instance.registerLazySingleton<LoadingCoverController>(
      () => LoadingCoverController());
}
