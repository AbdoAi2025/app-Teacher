import 'dart:ui';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:teacher_app/appSetting/appSetting.dart';
import 'package:teacher_app/navigation/app_routes.dart';
import 'package:teacher_app/navigation/app_routes_screens.dart';
import 'package:teacher_app/themes/app_colors.dart';
import 'package:teacher_app/utils/LogUtils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:teacher_app/utils/app_localization_utils.dart';
import 'domain/models/app_locale_model.dart';
import 'domain/usecases/get_app_setting_use_case.dart';
import 'localization/app_translation.dart';
import 'services/firebase_service.dart';


import 'navigation/my_route_observer.dart';
import 'services/api_service.dart';
import 'services/environment_service.dart';

Locale? appLocale;
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await initializeFirebase();

  _initSystemUi();
  initAppLocale();
  await initAppEnvironment();
  await AppSetting.initAppVersion();
  ApiService.startApiLoggerIfNeeded();
  runApp(MyApp());
}

Future<void> _initSystemUi() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.color_161516));

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

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
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: getAppSettingNotifier(),
        builder: (context, AppSetting setting, _) {
          var appLocaleModel = setting.appLocaleModel;
          var langCode =( appLocaleModel?.toLocale() ?? appLocale)?.languageCode;
          return OverlaySupport.global(
            child: GetMaterialApp(
            navigatorObservers: [
              MyRouteObserver(),
              routeObserver,
              _getFirebaseObserver(),
            ], // attach observer
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
          ));
        });
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

  // Log language change to Firebase
  try {
    await FirebaseService.instance.logLanguageChanged(language: lang);
  } catch (e) {
    appLog("Error logging language change: $e");
  }
}

Future<void> initializeFirebase() async {
  try {
    appLog("Starting Firebase initialization...");
    await Firebase.initializeApp();
    appLog("Firebase core initialized successfully");

    // Initialize Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Pass all uncaught asynchronous errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    appLog("Crashlytics configured successfully");

    // Initialize Firebase services
    await FirebaseService.instance.initializeServices();
    appLog("Firebase services initialized successfully");

    // Log app open event
    await FirebaseService.instance.logAppOpen();
    appLog("Firebase app open event logged");

    appLog("Firebase initialized successfully");
  } catch (e) {
    appLog("Error initializing Firebase: $e");
    // Still try to record the error even if initialization failed
    try {
      await FirebaseCrashlytics.instance.recordError(e, StackTrace.current, reason: 'Firebase initialization failed');
    } catch (_) {
      // If crashlytics also fails, just log it
      appLog("Failed to record Firebase initialization error to Crashlytics");
    }
  }
}

Future<void> initAppEnvironment() async {
  try {
    final savedEnvironment = await EnvironmentService.getEnvironment();
    AppMode.mode = savedEnvironment;
    await EnvironmentService.loadCustomLocalUrl();
    appLog("App environment initialized: ${EnvironmentService.getEnvironmentName(savedEnvironment)}");
    appLog("Custom local URL: ${EnvironmentService.currentCustomLocalUrl}");
  } catch (e) {
    appLog("Error initializing app environment: $e");
    AppMode.mode = AppMode.defaultMode; // Default fallback
  }
}

NavigatorObserver _getFirebaseObserver() {
  try {
    // Check if Firebase is initialized before accessing analytics
    return FirebaseService.instance.analytics.observer;
  } catch (e) {
    appLog("Firebase observer not available yet: $e");
    // Return a no-op observer if Firebase is not ready
    return NavigatorObserver();
  }
}

