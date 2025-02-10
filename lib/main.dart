/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/groups/groups_bloc.dart';
import 'bloc/groups/groups_event.dart';
import 'bloc/students/students_bloc.dart';
import 'bloc/students/students_event.dart';

import 'models/group.dart';
import 'models/student.dart';
import 'services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ تهيئة Hive (لا يزال مستخدمًا لبعض البيانات المحلية)
  await Hive.initFlutter();
  Hive.registerAdapter(GroupAdapter());
  Hive.registerAdapter(StudentAdapter());
  await Hive.openBox('authBox'); // ✅ فتح صندوق المستخدم
  await Hive.openBox('groupsBox'); // ✅ فتح صندوق المجموعات
  await Hive.openBox('studentsBox'); // ✅ فتح صندوق الطلاب

  // ✅ تهيئة Dio وإنشاء ApiService
  final Dio dio = Dio();
  final ApiService apiService = ApiService(dio); // ✅ تمرير `dio` إلى `ApiService`

  runApp(MyApp(apiService: apiService)); // ✅ تمرير `apiService` عند إنشاء التطبيق
}

class MyApp extends StatelessWidget {
  final ApiService apiService;
  const MyApp({Key? key, required this.apiService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(apiService)),

        // ✅ تمرير `apiService` إلى `StudentsBloc` لاستخدام API
        BlocProvider(
          create: (context) => StudentsBloc(apiService: apiService)..add(LoadStudentsEvent()),
        ),

        // ✅ تمرير `apiService` إلى `GroupsBloc` لاستخدام API
        BlocProvider(
          create: (context) => GroupsBloc(apiService: apiService)..add(LoadGroupsEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(apiService: apiService), // ✅ إصلاح الخطأ هنا!
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'package:teacher_app/screens/add_teacher_screen.dart';
import 'package:teacher_app/screens/signup_screen.dart';

import 'AuthStorage.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/groups/groups_bloc.dart';
import 'bloc/groups/groups_event.dart';
import 'bloc/students/students_bloc.dart';
import 'bloc/students/students_event.dart';

import 'models/group.dart';
import 'models/student.dart';
import 'services/api_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ تهيئة Hive وتخزين التوكن
  await Hive.initFlutter();
  await AuthStorage.init(); // ✅ تهيئة Hive
  Hive.registerAdapter(GroupAdapter());
  Hive.registerAdapter(StudentAdapter());
  await Hive.openBox('authBox'); // ✅ فتح صندوق المستخدم
  await Hive.openBox('groupsBox'); // ✅ فتح صندوق المجموعات
  await Hive.openBox('studentsBox'); // ✅ فتح صندوق الطلاب

  // ✅ تهيئة Dio وإنشاء ApiService
  final Dio dio = Dio();
  final ApiService apiService = ApiService(dio);

  runApp(MyApp(apiService: apiService));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;
  const MyApp({Key? key, required this.apiService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(apiService)),

        // ✅ تمرير `apiService` إلى `StudentsBloc` لاستخدام API
        BlocProvider(
          create: (context) => StudentsBloc(apiService: apiService)..add(LoadStudentsEvent()),
        ),

        // ✅ تمرير `apiService` إلى `GroupsBloc` لاستخدام API
        BlocProvider(
          create: (context) => GroupsBloc(apiService: apiService)..add(LoadGroupsEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(apiService: apiService),

        //LoginScreen(apiService: apiService), // ✅ إصلاح الخطأ هنا!
      ),
    );
  }
}
