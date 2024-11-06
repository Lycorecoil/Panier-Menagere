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
import 'package:vendors/app/backend/api/api.dart';
import 'package:vendors/app/backend/parse/account_parse.dart';
import 'package:vendors/app/backend/parse/categories_parse.dart';
import 'package:vendors/app/backend/parse/chat_list_parse.dart';
import 'package:vendors/app/backend/parse/contact_parse.dart';
import 'package:vendors/app/backend/parse/driver_parse.dart';
import 'package:vendors/app/backend/parse/edit_profile_parse.dart';
import 'package:vendors/app/backend/parse/firebase_parse.dart';
import 'package:vendors/app/backend/parse/firebase_register_parse.dart';
import 'package:vendors/app/backend/parse/firebase_reset_parse.dart';
import 'package:vendors/app/backend/parse/inbox_parse.dart';
import 'package:vendors/app/backend/parse/intro_parser.dart';
import 'package:vendors/app/backend/parse/invoice_list_parse.dart';
import 'package:vendors/app/backend/parse/language_parse.dart';
import 'package:vendors/app/backend/parse/login_parse.dart';
import 'package:vendors/app/backend/parse/manage_product_parse.dart';
import 'package:vendors/app/backend/parse/order_details_parse.dart';
import 'package:vendors/app/backend/parse/orders_parse.dart';
import 'package:vendors/app/backend/parse/pages_parse.dart';
import 'package:vendors/app/backend/parse/products_parse.dart';
import 'package:vendors/app/backend/parse/register_parse.dart';
import 'package:vendors/app/backend/parse/reset_password_parse.dart';
import 'package:vendors/app/backend/parse/reviews_parse.dart';
import 'package:vendors/app/backend/parse/search_parse.dart';
import 'package:vendors/app/backend/parse/splash_parse.dart';
import 'package:vendors/app/backend/parse/stats_chart_parse.dart';
import 'package:vendors/app/backend/parse/stats_parse.dart';
import 'package:vendors/app/backend/parse/sub_categories_parse.dart';
import 'package:vendors/app/backend/parse/tabs_parse.dart';
import 'package:vendors/app/backend/parse/update_password_firebase_parse.dart';
import 'package:vendors/app/env.dart';
import 'package:vendors/app/helper/shared_pref.dart';

class MainBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    final sharedPref = await SharedPreferences.getInstance();

    Get.put(SharedPreferencesManager(sharedPreferences: sharedPref), permanent: true);

    Get.lazyPut(() => ApiService(appBaseUrl: Environments.apiBaseURL));

    // Parser LazyLoad

    Get.lazyPut(() => LoginParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => SplashParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => FirebaseParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => RegisterParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => FirebaseRegisterParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => AccountParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => TabsParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => ResetPasswordParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => FirebaseResetParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => UpdatePasswordFirebaseParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => OrdersParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => OrderDetailsParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => DriversParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => StoreStatsParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => StatsChartParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => InvoiceListParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => AppPagesParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => ChatListParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => InboxParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => ContactParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => ProductsParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => SearchParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => ManageProductParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => CategoriesParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => SubCategoriesParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => ReviewsParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => EditProfileParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => IntroParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => LanguagesParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);
  }
}
