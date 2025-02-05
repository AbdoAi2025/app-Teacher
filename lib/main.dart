import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:teacher_app/screens/groups_screen.dart';
import 'package:teacher_app/screens/home_screen.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/groups/groups_bloc.dart';
import 'bloc/groups/groups_event.dart';
import 'bloc/students/students_bloc.dart';
import 'bloc/students/students_event.dart';
import 'models/group.dart';
import 'models/student.dart';
import 'screens/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(GroupAdapter()); // ✅ تسجيل الموديل في Hive
  Hive.registerAdapter(StudentAdapter());
  await Hive.openBox('authBox'); // ✅ فتح صندوق المستخدم
  await Hive.openBox('groupsBox'); // ✅ فتح صندوق المجموعا
  await Hive.openBox('studentsBox'); // ✅ فتح صندوق تخزين الطلا
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc()),
          BlocProvider(create: (context) => StudentsBloc()..add(LoadStudentsEvent())), // ✅ تسجيل `StudentsBloc`

          BlocProvider(create: (context) => GroupsBloc()..add(LoadGroupsEvent())), // ✅ تحميل البيانات عند بدء التطبيق
        ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: HomeScreen(), // ✅ إذا لم يكن مسجلًا، انتقل إلى `LoginScreen`

      ),
    );
  }
}
