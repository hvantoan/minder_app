import 'package:minder/data/repository/interface/i_language_repository.dart';
import 'package:minder/data/service/language/language_local_datasource.dart';

class LanguageRepository extends LanguageRepositoryInterface {
  LanguageLocalDatasource languageLocalDatasource = LanguageLocalDatasource();

  @override
  changeLanguage({String? languageKey}) async {
    if (languageKey != null) {
      languageLocalDatasource.saveLanguageKey(languageKey);
    } else {
      languageLocalDatasource.removeLanguageKey();
    }
  }

  @override
  Future<String?> getLanguageKey() async {
    return await languageLocalDatasource.getLanguageKey();
  }
}
