abstract class LanguageUseCaseInterface {
  changeLanguage({String? languageKey});

  Future<String?> getLanguageKey();
}
