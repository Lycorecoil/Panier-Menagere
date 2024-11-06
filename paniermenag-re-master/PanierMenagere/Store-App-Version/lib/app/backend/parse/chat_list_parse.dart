/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:vendors/app/backend/api/api.dart';
import 'package:vendors/app/helper/shared_pref.dart';
import 'package:vendors/app/util/constant.dart';

class ChatListParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ChatListParser({required this.apiService, required this.sharedPreferencesManager});

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  Future<Response> getChatConversion(var uid) async {
    return await apiService.postPrivate(AppConstants.getChatConversionList, {'id': uid}, sharedPreferencesManager.getString('token') ?? '');
  }
}
