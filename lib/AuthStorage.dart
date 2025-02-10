

import 'package:hive/hive.dart';

class AuthStorage {
 // static final _authBox = Hive.box('authBox');

  static late Box _authBox;

  // ✅ تهيئة Hive وفتح الصندوق عند بدء التطبيق
  static Future<void> init() async {
    _authBox = await Hive.openBox('authBox');
  }


  // ✅ حفظ التوكن
  static Future<void> saveToken(String token) async {
    await _authBox.put('auth_token', token);
  }

  // ✅ جلب التوكن المخزن
  static String? getToken() {
    return _authBox.get('auth_token', defaultValue: "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZWFjaGVyMSIsImlhdCI6MTczOTAyMjMxMywiZXhwIjozNTA5NTgwNjI3fQ.M7sDWLTNyp7FRvPEfKUift_55BdJ3kaBUM1gPEbC2a4");
  }

  // ✅ حذف التوكن عند تسجيل الخروج
  static Future<void> clearToken() async {
    await _authBox.delete('auth_token');
  }
}
