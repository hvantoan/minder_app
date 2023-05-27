import 'package:flutter/material.dart';
import 'package:minder/debug/debug.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/widget/common/exception_widget.dart';
import 'package:minder/util/style/base_style.dart';

const String _filePath =
    "lib/presentation/page/app_layer/unsupported_version_page.dart";

class UnsupportedVersionPage extends StatelessWidget {
  const UnsupportedVersionPage(
      {Key? key,
      required this.minimumVersion,
      required this.appVersion,
      required this.retry})
      : super(key: key);
  final String minimumVersion;
  final String appVersion;
  final VoidCallback retry;

  @override
  Widget build(BuildContext context) {
    DebugHelper.printPageBuild(
        filePath: _filePath, widget: "Unsupported Version Page");
    return Scaffold(
        body: Center(
            child: ExceptionWidget(
      contentWidget: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: "${S.current.txt_version} ",
              style: BaseTextStyle.subtitle2(),
              children: [
                TextSpan(
                    text: appVersion,
                    style: const TextStyle(color: BaseColor.blue500)),
                TextSpan(text: " ${S.current.txt_version_not_supported}")
              ])),
      subContent: '${S.current.txt_please_update_app} ',
      imagePath: 'assets/images/common/unsupported_version.png',
      onButtonTap: () => updateVersion(),
      buttonContent: S.of(context).btn_update,
    )));
  }

  void updateVersion() {
    ///TODO: GO TO STORE
  }
}
