import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:minder/debug/debug.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/bloc/base_layer/base_layer_cubit.dart';
import 'package:minder/presentation/page/app_layer/app_layer_page.dart';
import 'package:minder/presentation/page/app_layer/app_loading_page.dart';
import 'package:minder/util/style/base_style.dart';

const String _filePath =
    "lib/presentation/page/base_layer/base_layer_page.dart";

class BaseLayerPage extends StatelessWidget {
  const BaseLayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DebugHelper.printPageBuild(filePath: _filePath, widget: "Base Layer Page");
    return BlocBuilder<BaseLayerCubit, BaseLayerState>(
      builder: (context, state) {
        if (state is LanguageState) {
          return MaterialApp(
            theme: baseTheme(),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: state.locale,
            home: const AppLayerPage(),
          );
        }
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AppLoadingPage(),
        );
      },
    );
  }
}
