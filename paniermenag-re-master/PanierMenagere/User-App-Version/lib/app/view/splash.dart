/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:user/app/controller/splash_controller.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/util/constant.dart';
import 'package:user/app/util/theme.dart';
import 'package:get/get.dart';
import 'package:user/app/util/toast.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    initConnectivity();

    Get.find<SplashController>().initSharedData();
    _routing();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _routing() {
    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if (isSuccess) {
        if (Get.find<SplashController>().getLanguageCode() != '') {
          var locale = Get.find<SplashController>().getLanguageCode();
          Get.updateLocale(Locale(locale));
        } else {
          var locale = Get.find<SplashController>().defaultLanguage.languageCode != '' && Get.find<SplashController>().defaultLanguage.languageCode != ''
              ? Locale(Get.find<SplashController>().defaultLanguage.languageCode.toString())
              : const Locale('en');
          Get.updateLocale(locale);
        }

        if (Get.find<SplashController>().showIntro() == false) {
          Get.find<SplashController>().setIntro(true);
          Get.offNamed(AppRouter.getInitialRoute());
        } else {
          Get.find<SplashController>().setIntro(true);
          Get.offNamed(AppRouter.getLocationRoute());
        }
      } else {
        Get.toNamed(AppRouter.getErrorRoute());
      }
    });
  }

  Future<void> initConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasInternet = (connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi));
    if (!hasInternet) {
      showToast('No Internet Connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: ThemeProvider.whiteColor,
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/splash.gif', height: 200, width: 200),
                const CircularProgressIndicator(color: ThemeProvider.appColor),
                const SizedBox(height: 30),
                const Text('Powered By ${AppConstants.companyName}', style: TextStyle(fontFamily: 'bold'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
