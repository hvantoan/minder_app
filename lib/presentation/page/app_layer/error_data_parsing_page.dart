import 'package:flutter/material.dart';
import 'package:minder/debug/debug.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/presentation/widget/common/exception_widget.dart';

const String _filePath =
    "lib/presentation/page/app_layer/error_data_parsing_page.dart";

class ErrorDataParsingPage extends StatelessWidget {
  const ErrorDataParsingPage({Key? key, required this.retry}) : super(key: key);
  final VoidCallback retry;

  @override
  Widget build(BuildContext context) {
    DebugHelper.printPageBuild(
        filePath: _filePath, widget: "Error Data ParsingPage Page");
    return Scaffold(
      body: Center(
          child: ExceptionWidget(
        content: S.current.txt_data_parsing_failed,
        subContent: S.current.txt_please_try_again,
        imagePath: 'assets/images/common/error.png',
        onButtonTap: retry,
        buttonContent: S.of(context).btn_try_again,
      )),
    );
  }
}
