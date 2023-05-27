import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:minder/debug/debug.dart';
import 'package:minder/presentation/bloc/app_layer/app_layer_cubit.dart';
import 'package:minder/presentation/page/app_layer/app_disconnect_page.dart';
import 'package:minder/presentation/page/app_layer/app_loading_page.dart';
import 'package:minder/presentation/page/app_layer/error_data_parsing_page.dart';
import 'package:minder/presentation/page/app_layer/unsupported_version_page.dart';
import 'package:minder/presentation/page/authentication_layer/authentication_layer_page.dart';

const String _filePath = "lib/presentation/page/app_layer/app_layer_page.dart";

class AppLayerPage extends StatefulWidget {
  const AppLayerPage({Key? key}) : super(key: key);

  @override
  State<AppLayerPage> createState() => _AppLayerPageState();
}

class _AppLayerPageState extends State<AppLayerPage> {
  @override
  void initState() {
    GetIt.instance.get<AppLayerCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DebugHelper.printPageBuild(filePath: _filePath, widget: "App Layer Page");
    return BlocBuilder<AppLayerCubit, AppLayerState>(
      builder: (context, state) {
        if (state is AppCheckedState) {
          return const AuthenticationLayerPage();
        }
        if (state is AppDisconnectedState) {
          return AppDisconnectPage(
              retry: () => GetIt.instance.get<AppLayerCubit>().retry());
        }
        if (state is UnsupportedVersionState) {
          return UnsupportedVersionPage(
              minimumVersion: state.minimumVersion,
              appVersion: state.appVersion,
              retry: () => GetIt.instance.get<AppLayerCubit>().retry());
        }
        if (state is ErrorDataParsingState) {
          return ErrorDataParsingPage(
            retry: () => GetIt.instance.get<AppLayerCubit>().retry(),
          );
        }
        return const AppLoadingPage();
      },
    );
  }
}
