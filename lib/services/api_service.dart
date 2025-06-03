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
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:teacher_app/appSetting/appSetting.dart';
import 'package:teacher_app/main.dart';
import '../models/group_item_model.dart';
import '../models/student.dart';

const String prodBaseUrl = "https://assistant-app-2136afb92d95.herokuapp.com";
const String devBaseUrl = "https://assistant-app-2136afb92d95.herokuapp.com";
const String localBaseUrl = "http://192.168.2.117:8080";
var baseUrl = isDev ? localBaseUrl : prodBaseUrl;

class ApiService {
  static Dio? _dio;
  static Box? authBox;


  static Dio getInstance() {
    // var instance = _dio;
    // if(instance == null){
    //   instance = Dio();
    //   _dio = instance;
    //   _init(instance);
    // }

    var instance = Dio();
    _dio = instance;
    _init(instance);
    return instance;
  }

  static _init(Dio dio) async {
    dio.interceptors.add
      (
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: !kReleaseMode,
          printResponseHeaders: !kReleaseMode,
          printResponseMessage: !kReleaseMode,
        ),
      ),
    );

    var token = getAppSetting().accessToken;

    dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
  }

  // static Future<void> _loadToken() async {
  //   authBox = await Hive.openBox('authBox');
  //   String? token = authBox?.get('token') ?? "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZWFjaGVyMSIsImlhdCI6MTczOTU3NzI2MywiZXhwIjozNTEwNjkwNTI3fQ.rDBPiBxoBn-yjnrTEow_ZhImL70MQ9z0VRDYl3Zm3hc";
  //   if (token != null) {
  //     dio.options.headers["Authorization"] = "Bearer $token";
  //   }
  // }

  // ✅ تحديث التوكن بعد تسجيل الدخول
  // Future<void> updateAuthToken(String token) async {
  //   dio.options.headers["Authorization"] = "Bearer $token";
  //   await authBox?.put('token', token); // حفظ التوكن محليًا
  // }



  // ✅ تسجيل الدخول وجلب التوكن
  Future<String?> login(String username, String password) async {
    // try {
    //   Response response = await dio.post(
    //     '/api/v1/users/signin',
    //     data: {
    //       "username": username,
    //       "password": password,
    //     },
    //   );
    //
    //   print("statusCode:${response.statusCode}");
    //   print("📢 استجابة API عند تسجيل الدخول: ${response.data}");
    //
    //   if(response.statusCode == 200){
    //     LoginResponse responseResult = LoginResponse.fromJson(response.data);
    //     print("responseResult.username :${responseResult.username}");
    //     print("responseResult.accessToken :${responseResult.accessToken}");
    //
    //     return responseResult.accessToken;
    //
    //   }
    //
    //   // if (response.statusCode == 200 && response.data.containsKey('token')) {
    //   //   final token = response.data['token'];
    //   //   if (token != null && token is String && token.isNotEmpty) {
    //   //     await updateAuthToken(token);
    //   //     print("✅ تم استخراج وحفظ التوكن بنجاح: $token");
    //   //     return token;
    //   //   } else {
    //   //     throw Exception("❌ التوكن غير صالح!");
    //   //   }
    //   // } else {
    //   //   throw Exception("❌ فشل تسجيل الدخول: ${response.data}");
    //   // }
    // } catch (e) {
    //   throw Exception("❌ فشل تسجيل الدخول: $e");
    // }
  }

  // ✅ تسجيل الخروج
  void logout() {
    // AuthStorage.clearToken();
    // dio.options.headers.remove("Authorization");
  }

  // ✅ جلب جميع الطلاب
  Future<List<Student>> fetchStudents() async {

    return [];

    // try {
    //   Response response = await dio.get('/api/v1/students/myStudents');
    //   return (response.data as List).map((s) => Student.fromJson(s)).toList();
    // } catch (e) {
    //   throw Exception("فشل في جلب بيانات الطلاب");
    // }
  }

  // ✅ إضافة طالب جديد
  Future<void> createStudent(Student student) async {
    // try {
    //   await dio.post('/api/v1/students/add', data: student.toJson());
    // } catch (e) {
    //   throw Exception("فشل في إضافة الطالب");
    // }
  }

  // ✅ تحديث بيانات طالب
  Future<void> updateStudent(Student student) async {
    // try {
    //   await dio.put('/api/v1/students/update/${student.id}', data: student.toJson());
    // } catch (e) {
    //   throw Exception("فشل في تحديث بيانات الطالب");
    // }
  }

  // ✅ حذف طالب
  Future<void> deleteStudent(String studentId) async {
    // try {
    //   await dio.delete('/students/$studentId');
    // } catch (e) {
    //   throw Exception("فشل في حذف الطالب");
    // }
  }

  // ✅ حذف جميع الطلاب
  Future<void> deleteAllStudents() async {
    // try {
    //   await dio.delete('/students');
    // } catch (e) {
    //   throw Exception("فشل في حذف جميع الطلاب");
    // }
  }



  // ✅ إضافة مجموعة جديدة
  Future<void> createGroup(GroupItemModel group) async {
    // try {
    //   await dio.post('/api/v1/groups/add', data: group.toJson());
    // } catch (e) {
    //   throw Exception("فشل في إضافة المجموعة");
    // }
  }

  // ✅ تحديث بيانات مجموعة
  Future<void> updateGroup(GroupItemModel group) async {
    // try {
    //   await dio.put('/api/v1/groups/update/${group.id}', data: group.toJson());
    // } catch (e) {
    //   throw Exception("فشل في تحديث بيانات المجموعة");
    // }
  }

  // ✅ حذف مجموعة
  Future<void> deleteGroup(String groupId) async {
    // try {
    //   await dio.delete('/groups/$groupId');
    // } catch (e) {
    //   throw Exception("فشل في حذف المجموعة");
    // }
  }

  // ✅ حذف جميع المجموعات
  Future<void> deleteAllGroups() async {
    // try {
    //   await dio.delete('/groups');
    // } catch (e) {
    //   throw Exception("فشل في حذف جميع المجموعات");
    // }
  }
}
