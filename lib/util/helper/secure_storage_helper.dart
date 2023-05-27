import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static const _storage = FlutterSecureStorage();

  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  static save(String key, dynamic value) async {
    await _storage.write(key: key, value: value);
  }

  static delete(String key) async {
    await _storage.delete(key: key);
  }

  static deleteAll() async {
    await _storage.deleteAll();
  }
}
