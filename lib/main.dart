import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jiffy/jiffy.dart';
import 'package:testpro/color_schemes.g.dart';
import 'package:testpro/home_view.dart';
import 'package:testpro/login/home_controller.dart';
import 'package:testpro/login/login_controller.dart';
import 'package:testpro/login/login_view.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = GetStorage();

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          fontFamily: 'Aggro',
          useMaterial3: true,
          colorScheme: lightColorScheme),
      darkTheme: ThemeData(
        fontFamily: 'Aggro',
        useMaterial3: true,
        colorScheme: darkColorScheme,
      ),
      themeMode: ThemeMode.system,
      home: box.read('auto_login_email') == null ? LoginView() : HomeView(),
    );
  }

  @override
  void initState() {
    super.initState();
    Jiffy.locale('ko');
    Get.put(LoginController());
    Get.lazyPut(() => HomeController());
    var dataToHash = 'toricode';

    var bytesToHash = utf8.encode(dataToHash);
    var sha256Digest = sha256.convert(bytesToHash);
    var digest = sha1.convert(bytesToHash);
    print('Data to hash: $dataToHash');
    print('SHA-256: $sha256Digest');
    print('sha1 : $digest');
  }
}
