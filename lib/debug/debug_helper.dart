import 'package:flutter/material.dart';
import 'package:minder/util/helper/language_helper.dart';

import 'debug.dart';

class DebugHelper {
  ///Print
  static printPageBuild({required String filePath, required String widget}) {
    if (DebugConfig.mode == Mode.release) return;
    if (DebugConfig.printPageBuild) {
      debugPrint("[PageBuild] Build $widget ($filePath.dart)");
    }
  }

  static printException({required String exception}) {
    if (DebugConfig.mode == Mode.release || !DebugConfig.printException) return;
    try {
      debugPrint("[Exception] $exception");
    } catch (e) {
      return;
    }
  }

  static printLanguage({Locale? localLocale, Locale? systemLocale}) {
    if (DebugConfig.mode == Mode.release) return;
    try {
      if (localLocale != null) {
        debugPrint(
            "[Language] ${LanguageHelper.getLanguageFromLocale(localLocale)!.name}");
        return;
      }
      if (systemLocale != null) {
        debugPrint(
            "[Language] System Language (${LanguageHelper.getLanguageFromLocale(systemLocale)!.name})");
        return;
      }
      debugPrint("[Language] Default Language");
    } catch (e) {
      return;
    }
  }
}
