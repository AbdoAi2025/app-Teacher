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

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:teacher_app/appSetting/appSetting.dart';
import 'package:teacher_app/app_mode.dart';
import 'package:teacher_app/navigation/app_navigator.dart';
import 'package:teacher_app/utils/LogUtils.dart';

const String prodBaseUrl = "https://assistant-app-2136afb92d95.herokuapp.com";
const String devBaseUrl = "https://assistant-app-2136afb92d95.herokuapp.com";
const String localBaseUrlOrange = "http://192.168.2.117:8080";
const String localBaseUrlTpLink = "http://192.168.1.105:8080";
const String localBaseUrlOnePlusLink = "http://10.19.38.129:8080";
const String localBaseUrlVodafone = "http://192.168.8.176:8080";
// const String localBaseUrlOnPlus = "http://192.168.212.129:8080";
// const String localBaseUrl = "http://192.168.100.70:8080";

// const String localBaseUrl = localBaseUrlVodafone;
const String localBaseUrl = localBaseUrlOrange;
// const String localBaseUrl = localBaseUrlTpLink;
// const String localBaseUrl = localBaseUrlOnePlusLink;

var baseUrl = switch (AppMode.mode) {
  AppMode.dev => devBaseUrl,
  AppMode.local => localBaseUrl,
  _ => prodBaseUrl
};

// Create Alice with the navigator key
// final alice = Alice(navigatorKey: navigatorKey);

class ApiService {
  static Dio? _dio;

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

    dio.interceptors.add(
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: !kReleaseMode,
          printResponseHeaders: !kReleaseMode,
          printResponseMessage: !kReleaseMode,
        ),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // 🔑 Handle 401 Unauthorized here
            // Clear auth token or redirect to login page
            AppNavigator.navigateToLogin();
          }
          return handler.next(e);
        },
      ),
    );


    appLog("setting header");

    dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
        "platform": Platform.isAndroid ? "Android" : "IOS",
        "appVersion" : appVersion,
        "Accept-Language" : currentLanguage,
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST,OPTIONS',
        "Access-Control-Allow-Headers": "Content-Type, Authorization"
      },
    );
  }


  static String get token => AppSetting.getAppSetting().accessToken;
  static String get currentLanguage =>  Get.locale?.languageCode ?? "en";
  static double? get appVersion =>  AppSetting.getAppSetting().appVersion;


}
