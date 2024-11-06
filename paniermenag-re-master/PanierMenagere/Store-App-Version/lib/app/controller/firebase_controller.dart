/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vendors/app/backend/api/handler.dart';
import 'package:vendors/app/backend/parse/firebase_parse.dart';
import 'package:vendors/app/controller/login_controller.dart';
import 'package:vendors/app/helper/router.dart';
import 'package:vendors/app/util/theme.dart';
import 'package:vendors/app/util/toast.dart';

class FirebaseController extends GetxController implements GetxService {
  final FirebaseParser parser;
  String countryCode = '';
  String phoneNumber = '';
  String apiURL = '';
  bool haveClicked = false;
  FirebaseController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    apiURL = parser.apiService.appBaseUrl;
    countryCode = Get.arguments[0];
    phoneNumber = Get.arguments[1];
  }

  Future<void> onLogin(context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    loginWithPhoneToken(context);
    showDialog(
      context: context,
      barrierColor: ThemeProvider.appColor,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0.0),
          content: Padding(
            padding: const EdgeInsets.all(5),
            child: Text('Please wait'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold', fontSize: 14), textAlign: TextAlign.center),
          ),
        );
      },
    );
  }

  Future<void> loginWithPhoneToken(context) async {
    update();
    var param = {'country_code': countryCode, 'mobile': phoneNumber};
    Response response = await parser.loginWithPhoneToken(param);
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['user'] != '' && myMap['token'] != '') {
        if (myMap['user']['type'] == 'store') {
          if (myMap['user']['status'] == 1) {
            parser.saveInfo(myMap['token'].toString(), myMap['user']['id'].toString(), myMap['user']['first_name'].toString(), myMap['user']['last_name'].toString(), myMap['user']['email'].toString(),
                myMap['user']['cover'].toString(), myMap['user']['mobile'].toString());
            var param = {'id': myMap['user']['id'].toString(), 'fcm_token': parser.getFcmToken()};
            await parser.updateProfile(param);
            getStoreInfo();
            Get.delete<LoginController>(force: true);
            Get.offNamed(AppRouter.getTabsRoute());
          } else {
            showToast('Your account is blocked, please contact administrator');
          }
        } else {
          showToast('Not valid user');
        }
      } else {
        showToast('Something went wrong while signin');
      }
      update();
    } else if (response.statusCode == 401) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['error'] != '') {
        showToast(myMap['error']);
      } else {
        showToast('Something went wrong');
      }
      update();
    } else if (response.statusCode == 500) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['error'] != '') {
        showToast(myMap['error']);
      } else {
        showToast('Something went wrong');
      }
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
  }

  Future<void> getStoreInfo() async {
    Response response = await parser.getStoreInfo();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['data'] != '' && myMap['store'] != '') {
        parser.saveStoreInfo(myMap['store']['id'], myMap['store']['name'], myMap['store']['cover'], myMap['store']['cid']);
      } else {
        showToast('Something went wrong');
      }
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
  }
}
