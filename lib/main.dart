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

import 'dart:ui';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shake/shake.dart';
import 'package:teacher_app/appSetting/appSetting.dart';
import 'package:teacher_app/app_mode.dart';
import 'package:teacher_app/navigation/app_routes.dart';
import 'package:teacher_app/navigation/app_routes_screens.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:teacher_app/utils/app_localization_utils.dart';
import 'domain/models/app_locale_model.dart';
import 'domain/usecases/get_app_setting_use_case.dart';
import 'localization/app_translation.dart';


import 'services/api_service.dart';

Locale? appLocale;
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {


  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.color_161516));

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  initAppLocale();

  runApp(MyApp());
}



class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _startApiLoggerIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: getAppSettingNotifier(),
        builder: (context, AppSetting setting, _) {
          var appLocaleModel = setting.appLocaleModel;
          var langCode =( appLocaleModel?.toLocale() ?? appLocale)?.languageCode;
          return GetMaterialApp(
            navigatorKey: navigatorKey,
            textDirection: (rtlLanguages.contains(langCode)
                ? TextDirection.rtl
                : TextDirection.ltr),

            transitionDuration:
                const Duration(milliseconds: transitionDuration),
            popGesture: true,
            routingCallback: (value) {
              appLog("GetMaterialApp routingCallback value:${value?.current}");
            },
            translationsKeys: AppTranslation.translationsKeys,
            locale: appLocaleModel?.toLocale() ?? appLocale,
            supportedLocales: const [
              Locale("en", "US"),
              Locale("ar"),
            ],
            localizationsDelegates: const [
              CountryLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            fallbackLocale: const Locale("en", "US"),
            debugShowCheckedModeBanner: false,
            title: 'Assistant'.tr,
            initialRoute: AppRoutes.root,
            getPages: appRoutes(),
            theme: ThemeData(
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              }),
              bottomSheetTheme: BottomSheetThemeData(
                  dragHandleSize: Size(134, 5),
                  dragHandleColor: Colors.black.withAlpha(50)),
              brightness: Brightness.light,
              splashColor: AppColors.splashColor,
              // highlightColor: Colors.transparent,
              scaffoldBackgroundColor: AppColors.colorOffWhite,
              colorScheme: ColorScheme.fromSeed(
                  seedColor: AppColors.appMainColor,
              ),
              primaryColor: AppColors.appMainColor,
              cardColor: AppColors.white,
              secondaryHeaderColor: Colors.white,
              useMaterial3: true,
              appBarTheme: AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                backgroundColor: AppColors.appBarBackgroundColor,
                surfaceTintColor: AppColors.appBarBackgroundColor,
                foregroundColor: AppColors.appBarForegroundColor,

              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryButtonColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 1,
                    color: AppColors.color_DBD5CC,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1, color: AppColors.appMainColor),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          );
        });
  }

  _startApiLoggerIfNeeded() {
    if (AppMode.isProd) { return; }
    ShakeDetector.autoStart(
        onPhoneShake: (ShakeEvent event) {
          alice.showInspector();
        }
    );
  }
}

Future<void> initAppLocale() async {
  var getAppSettingUseCase = GetAppSettingUseCase();
  Locale deviceLocale = PlatformDispatcher.instance.locale;
  appLog("Device locale: ${deviceLocale.languageCode}-${deviceLocale.countryCode}");
  appLog("App locale Get.locale?.languageCode  :${Get.locale?.languageCode}");
  var savedAppLocale = await getAppSettingUseCase.execute();
  var lang = savedAppLocale?.language ?? ( deviceLocale.languageCode == "ar" ? deviceLocale.languageCode : "en");
  var country = savedAppLocale?.country ?? deviceLocale.countryCode;
  appLocale = Locale(lang , country);
  AppLocalizationUtils.setLocale(AppLocaleModel(language: lang, country: country));
  Get.locale = appLocale;
}


