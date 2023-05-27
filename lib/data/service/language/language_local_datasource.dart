import 'package:minder/core/service/local_service_client.dart';
import 'package:minder/util/constant/key/shared_preferences_key.dart';

abstract class LanguageLocalDatasourceInterface {
  saveLanguageKey(String? languageKey);

  Future<String?> getLanguageKey();

  removeLanguageKey();
}

class LanguageLocalDatasource implements LanguageLocalDatasourceInterface {
  @override
  saveLanguageKey(String? languageKey) async {
    await LocalServiceClient.save(
        key: SharedPreferencesKey.languageKey, value: languageKey);
  }

  @override
  Future<String?> getLanguageKey() async {
    final data = await LocalServiceClient.get(SharedPreferencesKey.languageKey);
    return data;
  }

  @override
  removeLanguageKey() async {
    await LocalServiceClient.remove(SharedPreferencesKey.languageKey);
  }
}
