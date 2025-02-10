/*import 'package:dio/dio.dart';
import '../models/student.dart';
import '../models/group.dart';

class ApiService {
  final Dio _dio;
 //  String token=

    //  'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZWFjaGVyMSIsImlhdCI6MTczOTAyMjMxMywiZXhwIjozNTA5NTgwNjI3fQ.M7sDWLTNyp7FRvPEfKUift_55BdJ3kaBUM1gPEbC2a4';

  ApiService( this._dio  ) {
    _dio.options = BaseOptions(
      baseUrl: "https://assistant-app-2136afb92d95.herokuapp.com",
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer  ", // ✅ أضف التوكن هنا
      },
    );
  }

  // ✅ تحديث التوكن بعد تسجيل الدخول
  void updateAuthToken(String token) {
    _dio.options.headers["Authorization"] = "Bearer $token";
  }

  // ✅ جلب جميع الطلاب
  Future<List<Student>> fetchStudents() async {
    try {
      Response response = await _dio.get('/students');
      return (response.data as List).map((s) => Student.fromJson(s)).toList();
    } catch (e) {
      throw Exception("فشل في جلب بيانات الطلاب");
    }
  }

  // ✅ إضافة طالب جديد
  Future<void> createStudent(Student student) async {
    try {
      await _dio.post('/students', data: student.toJson());
    } catch (e) {
      throw Exception("فشل في إضافة الطالب");
    }
  }

  // ✅ تحديث بيانات طالب
  Future<void> updateStudent(Student student) async {
    try {
      await _dio.put('/students/${student.id}', data: student.toJson());
    } catch (e) {
      throw Exception("فشل في تحديث بيانات الطالب");
    }
  }

  // ✅ حذف طالب
  Future<void> deleteStudent(String studentId) async {
    try {
      await _dio.delete('/students/$studentId');
    } catch (e) {
      throw Exception("فشل في حذف الطالب");
    }
  }

  // ✅ حذف جميع الطلاب
  Future<void> deleteAllStudents() async {
    try {
      await _dio.delete('/students');
    } catch (e) {
      throw Exception("فشل في حذف جميع الطلاب");
    }
  }

  // ✅ جلب جميع المجموعات
  Future<List<Group>> fetchGroups() async {
    try {
      Response response = await _dio.get('/groups');
      return (response.data as List).map((g) =>
          Group.fromJson(g as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception("❌ فشل في جلب بيانات المجموعات: $e");
    }
  }

  // ✅ إضافة مجموعة جديدة
  Future<void> createGroup(Group group) async {
    try {
      await _dio.post('/groups', data: group.toJson());
    } catch (e) {
      throw Exception("فشل في إضافة المجموعة");
    }
  }

  // ✅ تحديث بيانات مجموعة
  Future<void> updateGroup(Group group) async {
    try {
      await _dio.put('/groups/${group.id}', data: group.toJson());
    } catch (e) {
      throw Exception("فشل في تحديث بيانات المجموعة");
    }
  }

  // ✅ حذف مجموعة
  Future<void> deleteGroup(String groupId) async {
    try {
      await _dio.delete('/groups/$groupId');
    } catch (e) {
      throw Exception("فشل في حذف المجموعة");
    }
  }

  // ✅ حذف جميع المجموعات
  Future<void> deleteAllGroups() async {
    try {
      await _dio.delete('/groups');
    } catch (e) {
      throw Exception("فشل في حذف جميع المجموعات");
    }
  }

  // ✅ تسجيل الدخول وجلب التوكن
  Future<String> login(String username, String password) async {
    try {
      Response response = await _dio.post('/login', data: {
        "username": username,
        "email": password,
      });

      print("📢 استجابة API عند تسجيل الدخول: ${response.data}"); // ✅ طباعة الاستجابة

      if (response.statusCode == 200) {
        return response.data['token']; // ✅ استخراج التوكن
      } else {
        throw Exception("❌ فشل تسجيل الدخول: ${response.data}");
      }
    } catch (e) {
      throw Exception("❌ فشل تسجيل الدخول: $e");
    }
  }

}
*/


import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../AuthStorage.dart';
import '../models/student.dart';
import '../models/group.dart';

class ApiService {
  final Dio _dio;
  late Box authBox;

  ApiService(this._dio) {
    _dio.options = BaseOptions(
      baseUrl: "https://assistant-app-2136afb92d95.herokuapp.com",
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      headers: {
        "Content-Type": "application/json",
      },
    );

    // ✅ تحميل بيانات التوكن من التخزين المحلي
    _loadToken();
  }

  // ✅ تحميل التوكن من Hive عند بدء التطبيق
  Future<void> _loadToken() async {
    authBox = await Hive.openBox('authBox');
    String? token = authBox.get('token');
    if (token != null) {
      _dio.options.headers["Authorization"] = "Bearer $token";
    }
  }

  // ✅ تحديث التوكن بعد تسجيل الدخول
  Future<void> updateAuthToken(String token) async {
    _dio.options.headers["Authorization"] = "Bearer $token";
    await authBox.put('token', token); // حفظ التوكن محليًا
  }


  Future<String> addTeacher(String name, String username, String password) async {
    try {
      Response response = await _dio.post(
        '/api/v1/teachers/add',
        data: {
          "name": name,
          "username": username,
          "password": password,
        },
      );

      print("📢 استجابة API: ${response.data}");

      if (response.statusCode == 200 && response.data.containsKey('accessToken')) {
        String token = response.data['accessToken'];
        updateAuthToken(token); // ✅ حفظ التوكن بعد إنشاء الحساب
        return token;
      } else {
        throw Exception("❌ استجابة غير متوقعة من السيرفر: ${response.data}");
      }
    } on DioException catch (e) {
      print("❌ خطأ في الطلب: ${e.response?.data}");
      throw Exception("❌ فشل إضافة المعلم: ${e.response?.data ?? e.toString()}");
    }
  }



// ✅ تسجيل مستخدم جديد وجلب التوكن
  Future<String> signUp(String username, String email, String password, int roleId) async {
    try {
      Response response = await _dio.post('/api/v1/users/signup', data: {
        "username": username,
        "email": email,
        "password": password,
        roleId: roleId, // تأكد أن الـ roleId صحيح
      });

      print("📢 استجابة API عند التسجيل: ${response.data}");

      if (response.statusCode == 200 && response.data.containsKey('accessToken')) {
        String token = response.data['accessToken'];
        updateAuthToken(token); // حفظ التوكن
        return token;
      } else {
        throw Exception("❌ فشل تسجيل الحساب: استجابة غير متوقعة من السيرفر");
      }
    } catch (e) {
      throw Exception("❌ فشل تسجيل الحساب: $e");
    }
  }
  // ✅ تسجيل الدخول وجلب التوكن
  Future<String?> login(String username, String password) async {
    try {
      Response response = await _dio.post(
        '/api/v1/users/signin',
        data: {
          "username": username,
          "password": password,
        },
      );

      print("📢 استجابة API عند تسجيل الدخول: ${response.data}");

      if (response.statusCode == 200 && response.data.containsKey('token')) {
        final token = response.data['token'];
        if (token != null && token is String && token.isNotEmpty) {
          await updateAuthToken(token);
          print("✅ تم استخراج وحفظ التوكن بنجاح: $token");
          return token;
        } else {
          throw Exception("❌ التوكن غير صالح!");
        }
      } else {
        throw Exception("❌ فشل تسجيل الدخول: ${response.data}");
      }
    } catch (e) {
      throw Exception("❌ فشل تسجيل الدخول: $e");
    }
  }

  // ✅ تسجيل الخروج
  void logout() {
    AuthStorage.clearToken();
    _dio.options.headers.remove("Authorization");
  }

  // ✅ جلب جميع الطلاب
  Future<List<Student>> fetchStudents() async {
    try {
      Response response = await _dio.get('/students');
      return (response.data as List).map((s) => Student.fromJson(s)).toList();
    } catch (e) {
      throw Exception("فشل في جلب بيانات الطلاب");
    }
  }

  // ✅ إضافة طالب جديد
  Future<void> createStudent(Student student) async {
    try {
      await _dio.post('/students', data: student.toJson());
    } catch (e) {
      throw Exception("فشل في إضافة الطالب");
    }
  }

  // ✅ تحديث بيانات طالب
  Future<void> updateStudent(Student student) async {
    try {
      await _dio.put('/students/${student.id}', data: student.toJson());
    } catch (e) {
      throw Exception("فشل في تحديث بيانات الطالب");
    }
  }

  // ✅ حذف طالب
  Future<void> deleteStudent(String studentId) async {
    try {
      await _dio.delete('/students/$studentId');
    } catch (e) {
      throw Exception("فشل في حذف الطالب");
    }
  }

  // ✅ حذف جميع الطلاب
  Future<void> deleteAllStudents() async {
    try {
      await _dio.delete('/students');
    } catch (e) {
      throw Exception("فشل في حذف جميع الطلاب");
    }
  }

  // ✅ جلب جميع المجموعات
  Future<List<Group>> fetchGroups() async {
    try {
      Response response = await _dio.get('/groups');
      return (response.data as List).map((g) =>
          Group.fromJson(g as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception("❌ فشل في جلب بيانات المجموعات: $e");
    }
  }

  // ✅ إضافة مجموعة جديدة
  Future<void> createGroup(Group group) async {
    try {
      await _dio.post('/groups', data: group.toJson());
    } catch (e) {
      throw Exception("فشل في إضافة المجموعة");
    }
  }

  // ✅ تحديث بيانات مجموعة
  Future<void> updateGroup(Group group) async {
    try {
      await _dio.put('/groups/${group.id}', data: group.toJson());
    } catch (e) {
      throw Exception("فشل في تحديث بيانات المجموعة");
    }
  }

  // ✅ حذف مجموعة
  Future<void> deleteGroup(String groupId) async {
    try {
      await _dio.delete('/groups/$groupId');
    } catch (e) {
      throw Exception("فشل في حذف المجموعة");
    }
  }

  // ✅ حذف جميع المجموعات
  Future<void> deleteAllGroups() async {
    try {
      await _dio.delete('/groups');
    } catch (e) {
      throw Exception("فشل في حذف جميع المجموعات");
    }
  }
}
