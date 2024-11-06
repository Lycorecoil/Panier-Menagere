/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/app/helper/init.dart';
import 'package:driver/app/helper/router.dart';
import 'package:driver/app/util/constant.dart';
import 'package:driver/app/util/theme.dart';
import 'package:driver/app/util/translator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
  await MainBinding().dependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      color: ThemeProvider.appColor,
      debugShowCheckedModeBanner: false,
      navigatorKey: Get.key,
      initialRoute: AppRouter.splashRoutes,
      getPages: AppRouter.routes,
      defaultTransition: Transition.native,
      translations: LocaleString(),
      locale: const Locale('en', 'US'),
      theme: ThemeData(appBarTheme: const AppBarTheme(elevation: 0, centerTitle: false, color: Colors.white, iconTheme: IconThemeData(color: Colors.white))),
    );
  }
}
