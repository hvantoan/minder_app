import 'package:flutter/material.dart';
import 'package:minder/debug/debug.dart';
import 'package:minder/domain/entity/language/language.dart';
import 'package:minder/generated/l10n.dart';
import 'package:minder/util/constant/key/shared_preferences_key.dart';
import 'package:minder/util/helper/shared_preferences_helper.dart';

class LanguageHelper {
  static Future<Locale?> getCurrentLocale() async {
    String? currentLanguageKey =
        await SharedPreferencesHelper.read(SharedPreferencesKey.languageKey);
    if (currentLanguageKey != null) {
      DebugHelper.printLanguage(localLocale: Locale(currentLanguageKey));
      return Locale(currentLanguageKey);
    }
    final List<Locale> systemLocales = WidgetsBinding.instance.window.locales;
    for (var locale in systemLocales) {
      if (S.delegate.isSupported(locale)) {
        DebugHelper.printLanguage(systemLocale: locale);
        return locale;
      }
    }
    DebugHelper.printLanguage();
    return null;
  }

  static Language? getLanguageFromLocale(Locale? locale) {
    if (locale == null) return null;
    switch (locale.languageCode) {
      case "en":
        return Language(key: "en", name: "English", imageIconPath: "");
      case "vi":
        return Language(key: "vi", name: "Tiếng Việt", imageIconPath: "");
      default:
        return null;
    }
  }
}
