import 'package:shared_preferences/shared_preferences.dart';

class LocalServiceClient {
  static save({required String key, required dynamic value}) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    switch (value.runtimeType) {
      case double:
        instance.setDouble(key, value);
        break;
      case int:
        instance.setInt(key, value);
        break;
      case bool:
        instance.setBool(key, value);
        break;
      case List<String>:
        instance.setStringList(key, value);
        break;
      default:
        instance.setString(key, value.toString());
    }
  }

  static Future<dynamic> get(String key) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.get(key);
  }

  static remove(String key) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.remove(key);
  }
}
