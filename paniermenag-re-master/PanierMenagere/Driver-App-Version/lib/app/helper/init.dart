/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:driver/app/backend/api/api.dart';
import 'package:driver/app/backend/parse/account_parse.dart';
import 'package:driver/app/backend/parse/contacts_parse.dart';
import 'package:driver/app/backend/parse/edit_profile_parse.dart';
import 'package:driver/app/backend/parse/firebase_delivery_parse.dart';
import 'package:driver/app/backend/parse/firebase_parse.dart';
import 'package:driver/app/backend/parse/firebase_register_parse.dart';
import 'package:driver/app/backend/parse/firebase_reset_parse.dart';
import 'package:driver/app/backend/parse/intro_parse.dart';
import 'package:driver/app/backend/parse/languages_parse.dart';
import 'package:driver/app/backend/parse/login_parse.dart';
import 'package:driver/app/backend/parse/order_details_parse.dart';
import 'package:driver/app/backend/parse/orders_parse.dart';
import 'package:driver/app/backend/parse/pages_parse.dart';
import 'package:driver/app/backend/parse/register_parse.dart';
import 'package:driver/app/backend/parse/reset_password_parse.dart';
import 'package:driver/app/backend/parse/reviews_parse.dart';
import 'package:driver/app/backend/parse/splash_parse.dart';
import 'package:driver/app/backend/parse/tabs_parse.dart';
import 'package:driver/app/backend/parse/tracking_parse.dart';
import 'package:driver/app/backend/parse/update_password_firebase_parse.dart';
import 'package:driver/app/controller/login_controller.dart';
import 'package:driver/app/env.dart';
import 'package:driver/app/helper/shared_pref.dart';

class MainBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    final sharedPref = await SharedPreferences.getInstance();

    Get.put(SharedPreferencesManager(sharedPreferences: sharedPref), permanent: true);

    Get.lazyPut(() => ApiService(appBaseUrl: Environments.apiBaseURL));
    // Parser LazyLoad

    Get.lazyPut(() => SplashParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => LoginParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => RegisterParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => ResetPasswordParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => FirebaseParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => FirebaseResetParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => UpdatePasswordFirebaseParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => FirebaseRegisterParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => TabsParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => OrdersParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => AccountParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => AppPagesParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => ContactParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => ReviewsParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => OrderDetailsParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => FirebaseDeliveryParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => TrackingParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => EditProfileParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => LanguagesParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => IntroParser(sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => LoginController(parser: Get.find()));
  }
}
