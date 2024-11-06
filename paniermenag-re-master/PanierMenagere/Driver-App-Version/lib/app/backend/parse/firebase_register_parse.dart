/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:driver/app/backend/api/api.dart';
import 'package:driver/app/helper/shared_pref.dart';

class FirebaseRegisterParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  FirebaseRegisterParser({required this.sharedPreferencesManager, required this.apiService});
}
