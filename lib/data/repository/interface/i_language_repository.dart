abstract class LanguageRepositoryInterface {
  changeLanguage({String? languageKey});

  Future<String?> getLanguageKey();
}
