

import 'package:get_storage/get_storage.dart';

class StorageService {
  static final _box = GetStorage();
  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_data';

  // টোকেন সেভ করা
  static Future<void> saveToken(String token) async {
    await _box.write(_tokenKey, token);
  }

  // টোকেন পড়া
  static String? getToken() {
    return _box.read(_tokenKey);
  }

  // ইউজার ডাটা সেভ করা (Login এর পর)
  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _box.write(_userKey, user);
  }

  // লগআউট (সব মুছে ফেলা)
  static Future<void> clear() async {
    await _box.erase();
  }

  // লগিন করা আছে কিনা চেক করা
  static bool get isLoggedIn => getToken() != null;
}