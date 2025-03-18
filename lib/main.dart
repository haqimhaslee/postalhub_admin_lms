import 'package:flutter/material.dart'; //
import 'package:firebase_core/firebase_core.dart';
import 'package:postalhub_admin_cms/login_services/auth_services.dart';
import 'firebase_options.dart';
import 'package:postalhub_admin_cms/src/postalhub_ui.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/services.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    //webProvider: ReCaptchaV3Provider('key-here'),
    androidProvider: AndroidProvider.playIntegrity,
    //appleProvider: AppleProvider.appAttest,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark, // Or Brightness.light
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
      return MaterialApp(
          theme: ThemeData(
            colorScheme: lightColorScheme,
            //fontFamily: 'GoogleSans',
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
              },
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            //fontFamily: 'GoogleSans',
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
              },
            ),
          ),
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          home: const AuthPage());
    });
  }
}
