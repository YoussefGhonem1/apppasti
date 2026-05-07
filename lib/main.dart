import 'dart:io';
import 'package:device_preview/device_preview.dart' hide DeviceType;
import 'package:flutter/foundation.dart';
import 'package:pasti/providers/notification.dart';
import 'package:sizer/sizer.dart';

import 'constants/var.dart';
import 'helper_functions/small_functions.dart';
import 'helper_functions/localizer.dart';
import 'models/local_notifications.dart';
import 'providers/network.dart';
import 'providers/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'constants/theme.dart';
import 'helper_functions/shared_pref.dart';
import 'models/localizations.dart';
import 'providers/change_language.dart';
import 'screens/splash_screen/view.dart';

class GlobalVariable {
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  // Player.boot();
  await startShared();
  // startNotificationOne();
  await NotificationLocalClass.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();

  // Initialize localizer with current language
  await AppLocalizer.load(lang);

  runApp(MyApp(appLanguage: appLanguage));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.appLanguage, Key? key}) : super(key: key);
  final AppLanguage appLanguage;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppLanguage()),

        // ChangeNotifierProvider.value(
        //   value: SmsController(),
        // ),
        ChangeNotifierProvider.value(value: NotificationShowProvider()),

        ChangeNotifierProvider.value(value: NetWorkProvider()),

        ChangeNotifierProvider.value(value: NotificationProvider()),
      ],
      child: ChangeNotifierProvider<AppLanguage>(
        create: (_) => appLanguage,
        child: Consumer<AppLanguage>(
          builder: (context, lang, _) {
            return AnnotatedRegion(
              value: barColor(),
              child: Sizer(
                builder: (context, orientation, DeviceType deviceType) {
                  if (deviceType == DeviceType.tablet) {
                    isTablet = true;
                  }
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    navigatorKey: GlobalVariable.navState,
                    locale: lang.appLocal,
                    supportedLocales: const [
                      Locale('en', 'US'),
                      Locale('ar', 'EG'),
                      Locale('it', ''),
                    ],
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(
                          context,
                        ).copyWith(textScaler: TextScaler.linear(0.9)),
                        child: Container(
                          color: Colors.white,
                          child: Directionality(
                            textDirection: getDirection(),
                            child: child!,
                          ),
                        ),
                      );
                    },
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    theme: mainTheme(),
                    home: const SplashScreen(),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

SystemUiOverlayStyle barColor() {
  if (Platform.isAndroid) {
    return const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    );
  } else {
    return const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      // statusBarBrightness: Brightness.dark,
      // statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    );
  }
}
