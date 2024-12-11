import 'package:flutter/material.dart'; //
import 'package:firebase_core/firebase_core.dart';
import 'package:postalhub_admin_cms/login_services/auth_services.dart';
import 'firebase_options.dart';
import 'package:postalhub_admin_cms/src/postalhub_ui.dart';
import 'package:dynamic_color/dynamic_color.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
            fontFamily: 'GoogleSans',
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            fontFamily: 'GoogleSans',
          ),
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          home: const AuthPage());
    });
  }
}
