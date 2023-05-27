import 'package:flutter/material.dart';
import 'package:minder/debug/debug.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/widget/common/exception_widget.dart';

const String _filePath =
    "lib/presentation/page/app_layer/app_disconnect_page.dart";

class AppDisconnectPage extends StatelessWidget {
  const AppDisconnectPage({Key? key, required this.retry}) : super(key: key);
  final VoidCallback retry;

  @override
  Widget build(BuildContext context) {
    DebugHelper.printPageBuild(
        filePath: _filePath, widget: "App Disconnect Page");
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ExceptionWidget(
          content: "${S.current.txt_can_not_connect_server}!",
          subContent: '${S.current.txt_please_try_again}.',
          imagePath: 'assets/images/common/disconnect.png',
          onButtonTap: retry,
          buttonContent: S.of(context).btn_try_again,
        ),
      ),
    );
  }
}
