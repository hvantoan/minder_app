import 'package:minder/data/repository/implement/language_repository_impl.dart';
import 'package:minder/domain/usecase/interface/i_language_usecase.dart';

class LanguageUseCase extends LanguageUseCaseInterface {
  LanguageRepository languageRepository = LanguageRepository();

  @override
  changeLanguage({String? languageKey}) async {
    languageRepository.changeLanguage(languageKey: languageKey);
  }

  @override
  Future<String?> getLanguageKey() async {
    return await languageRepository.getLanguageKey();
  }
}
