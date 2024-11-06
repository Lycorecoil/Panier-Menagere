/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:driver/app/backend/api/handler.dart';
import 'package:driver/app/backend/models/order_notes_model.dart';
import 'package:driver/app/backend/models/orders_model.dart';
import 'package:driver/app/backend/models/stores_model.dart';
import 'package:driver/app/backend/models/user_model.dart';
import 'package:driver/app/backend/parse/order_details_parse.dart';
import 'package:driver/app/controller/orders_controller.dart';
import 'package:driver/app/controller/tracking_controller.dart';
import 'package:driver/app/helper/router.dart';
import 'package:driver/app/util/constant.dart';
import 'package:driver/app/util/theme.dart';
import 'package:driver/app/util/toast.dart';

import 'package:url_launcher/url_launcher.dart';

class OrderDetailsController extends GetxController implements GetxService {
  final OrderDetailsParser parser;

  int orderId = 0;
  bool apiCalled = false;

  int driverAssignment = AppConstants.driverAssignment;

  OrdersModel _details = OrdersModel();
  OrdersModel get details => _details;

  UserDetailsModel _userDetails = UserDetailsModel();
  UserDetailsModel get userDetails => _userDetails;

  StoresModel _storesDetails = StoresModel();
  StoresModel get storesDetails => _storesDetails;

  int driverId = 0;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  String orderStatus = '';

  double itemTotalStore = 0.0;
  double deliveryChargeStore = 0.0;
  double splitOrderTaxStore = 0.0;
  double splitOrderDiscountStore = 0.0;
  double splitOrderWalletDiscountStore = 0.0;
  double grandTotalStore = 0.0;
  String statusText = '';
  String storeId = '';

  int savedDriverId = 0;

  int delivery = 0;

  String selectedStatusId = '';

  String smsName = AppConstants.defaultSMSGateway;
  int smsId = 1;
  String otpCode = '';
  OrderDetailsController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    orderId = Get.arguments[0] ?? 1;
    driverAssignment = parser.getDriverAssignment();
    smsName = parser.getSMSName();
    driverId = int.parse(parser.getUID().toString());
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    delivery = parser.getDelivery();
    statusText = ' by ${parser.getDriverName()}';

    update();
    getOrderDetails();
  }

  Future<void> getOrderDetails() async {
    Response response = await parser.getOrderDetails(orderId);
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic orderInfo = myMap["data"];
      _details = OrdersModel();
      OrdersModel orderInfoData = OrdersModel.fromJson(orderInfo);
      var uid = orderInfoData.assignee!.firstWhere((element) => element.driver == driverId).assignee;
      orderInfoData.orders = orderInfoData.orders!.where((element) => element.storeId == uid).toList();
      orderInfoData.dateTime = Jiffy.parse(orderInfoData.dateTime.toString()).yMMMMEEEEdjm;
      _details = orderInfoData;

      var orderStatusFromStore = orderInfoData.status!.where((element) => element.id == uid).toList();
      if (orderStatusFromStore.isNotEmpty) {
        orderStatus = orderStatusFromStore[0].status.toString();
        debugPrint(orderStatus);
      }
      List storeIds = _details.storeId!.split(',');
      storeIds = storeIds.map((e) => int.parse(e)).toList();
      double total = 0;
      for (var element in _details.orders!) {
        if (element.discount! == 0) {
          if (element.size == 1) {
            if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
              total = total + element.variations![0].items![element.variant].discount! * element.quantity;
            } else {
              total = total + element.variations![0].items![element.variant].price! * element.quantity;
            }
          } else {
            total = total + element.originalPrice! * element.quantity;
          }
        } else {
          if (element.size == 1) {
            if (element.variations!.isNotEmpty && element.variations![0].items!.isNotEmpty && element.variations![0].items![element.variant].discount! > 0) {
              total = total + element.variations![0].items![element.variant].discount! * element.quantity;
            } else {
              total = total + element.variations![0].items![element.variant].price! * element.quantity;
            }
          } else {
            total = total + element.sellPrice! * element.quantity;
          }
        }
      }
      if (details.orderTo == 'home' && details.assignee != null && details.assignee!.isNotEmpty) {
        storeId = details.assignee!.firstWhere((element) => element.assignee == uid).assignee.toString();
        update();
      }
      double discount = 0.0;
      double walletPrice = 0.0;
      if (details.discount! > 0) {
        discount = details.discount! / storeIds.length;
      }
      if (details.walletPrice! > 0) {
        walletPrice = details.walletPrice! / storeIds.length;
      }
      double deliveryChargeCount = 0.0;
      if (details.orderTo == 'home' && details.deliveryCharge! > 0) {
        var charge = details.extra!.firstWhereOrNull((element) => element.storeId == uid);
        if (charge?.shipping == 'km') {
          deliveryChargeCount = double.parse((charge?.distance)!.toStringAsFixed(2)) * double.parse((charge?.shippingPrice)!.toStringAsFixed(2));
        } else {
          deliveryChargeCount = double.parse((charge?.shippingPrice)!.toStringAsFixed(2)) / storeIds.length;
        }
      }
      var taxAmount = details.extra!.firstWhereOrNull((element) => element.storeId == uid)?.tax;
      double grandTotal = total + deliveryChargeCount + taxAmount!;
      double removeDiscount = discount + walletPrice;
      double amountToPay = grandTotal - removeDiscount;

      itemTotalStore = double.parse((total).toStringAsFixed(2));
      deliveryChargeStore = double.parse((deliveryChargeCount).toStringAsFixed(2));
      splitOrderTaxStore = double.parse((taxAmount).toStringAsFixed(2));
      splitOrderDiscountStore = double.parse((discount).toStringAsFixed(2));
      splitOrderWalletDiscountStore = double.parse((walletPrice).toStringAsFixed(2));
      grandTotalStore = double.parse((amountToPay).toStringAsFixed(2));
      dynamic userInfo = myMap["user"];
      if (userInfo != null) {
        _userDetails = UserDetailsModel();
        UserDetailsModel dataUserInfo = UserDetailsModel.fromJson(userInfo);
        _userDetails = dataUserInfo;
        debugPrint(_userDetails.firstName.toString());
      }

      getStoreInfo();
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
  }

  Future<void> getStoreInfo() async {
    Response response = await parser.getStorInfo(storeId);
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic storeInfo = myMap["data"];
      _storesDetails = StoresModel();
      StoresModel storesData = StoresModel.fromJson(storeInfo);
      _storesDetails = storesData;
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
  }

  void openActionModalStore(String name, String email, String phone, String uid) {
    var context = Get.context as BuildContext;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('${'Contact'.tr} $name'),
        actions: [
          email != ''
              ? CupertinoActionSheetAction(
                  child: Text('Email'.tr),
                  onPressed: () {
                    Navigator.pop(context);
                    composeEmail(email);
                  },
                )
              : const SizedBox(),
          CupertinoActionSheetAction(
            child: Text('Call'.tr),
            onPressed: () {
              Navigator.pop(context);
              makePhoneCall(phone);
            },
          ),
          CupertinoActionSheetAction(child: Text('Cancel'.tr, style: const TextStyle(fontFamily: 'bold', color: Colors.red)), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  Future<void> composeEmail(String email) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: email);
    await launchUrl(launchUri);
  }

  bottomBorder() {
    return BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: ThemeProvider.greyColor.shade300)));
  }

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  void openStatusModal() {
    var context = Get.context as BuildContext;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Text('Choose status'.tr, style: const TextStyle(fontSize: 14, fontFamily: 'bold'), textAlign: TextAlign.center),
          content: Column(
            children: [
              SizedBox(
                height: 200.0, // Change as per your requirement
                width: 300.0, // Change as per your requirement
                child: Scrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: AppConstants.updateStatus.length,
                    itemBuilder: (BuildContext context, int index) {
                      Color getColor(Set<WidgetState> states) {
                        return ThemeProvider.appColor;
                      }

                      return ListTile(
                        textColor: ThemeProvider.appColor,
                        iconColor: ThemeProvider.appColor,
                        title: Text(AppConstants.updateStatus[index].name.toString()),
                        leading: Radio(
                          fillColor: WidgetStateProperty.resolveWith(getColor),
                          value: AppConstants.updateStatus[index].id.toString(),
                          groupValue: selectedStatusId,
                          onChanged: (e) {
                            selectedStatusId = e.toString();
                            debugPrint(selectedStatusId);
                            Navigator.pop(context);
                            update();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> changeOrderStatusOption() async {
    debugPrint(selectedStatusId);
    if (selectedStatusId != '') {
      debugPrint('call API');
      if (selectedStatusId == 'ongoing' && details.orderTo == 'home') {
        debugPrint('deliver, cancelled,rejected');
        var status = selectedStatusId;
        var orderNotesParam = {'status': 1, 'value': 'Order $status$statusText', 'time': Jiffy.now().format(pattern: 'MMMM do yyyy, h:mm:ss a')};
        OrderNotesModel orderNotesParse = OrderNotesModel.fromJson(orderNotesParam);
        _details.notes!.add(orderNotesParse);
        for (var item in _details.status!) {
          if (item.id.toString() == storeId) {
            item.status = status;
          }
        }
        Get.dialog(
          SimpleDialog(
            children: [
              Row(
                children: [
                  const SizedBox(width: 30),
                  const CircularProgressIndicator(color: ThemeProvider.appColor),
                  const SizedBox(width: 30),
                  SizedBox(child: Text("Updating Order".tr, style: const TextStyle(fontFamily: 'bold'))),
                ],
              )
            ],
          ),
          barrierDismissible: false,
        );

        var param = {'id': orderId, 'notes': jsonEncode(details.notes), 'status': jsonEncode(details.status), 'order_status': status};
        debugPrint(jsonEncode(param));
        Response response = await parser.updateOrderStatus(param);
        Get.back();
        if (response.statusCode == 200) {
          Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
          dynamic body = myMap["data"];
          if (body == true) {
            showToast('Status Updated');
            if (userDetails.fcmToken != null) {
              var notificationParam = {'title': 'Order $status', 'message': 'Your order #$orderId $status', 'id': userDetails.fcmToken.toString()};
              await parser.sendNotification(notificationParam);
            }
            Get.find<OrdersController>().getOrders();
            onBack();
          }
        } else {
          ApiChecker.checkApi(response);
        }
        update();
      } else {
        if (delivery == 0) {
          deliverOrder();
        } else {
          debugPrint('delivery with OTP');
          sendOtpOnDelivery();
        }
      }
    }
  }

  Future<void> deliverOrder() async {
    debugPrint('deliver this');

    var status = selectedStatusId;
    var orderNotesParam = {'status': 1, 'value': 'Order $status$statusText', 'time': Jiffy.now().format(pattern: 'MMMM do yyyy, h:mm:ss a')};
    OrderNotesModel orderNotesParse = OrderNotesModel.fromJson(orderNotesParam);
    _details.notes!.add(orderNotesParse);
    for (var item in _details.status!) {
      if (item.id.toString() == storeId) {
        item.status = status;
      }
    }
    Get.dialog(
      SimpleDialog(
        children: [
          Row(
            children: [
              const SizedBox(width: 30),
              const CircularProgressIndicator(color: ThemeProvider.appColor),
              const SizedBox(width: 30),
              SizedBox(child: Text("Updating Order".tr, style: const TextStyle(fontFamily: 'bold'))),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );

    var param = {'id': orderId, 'notes': jsonEncode(details.notes), 'status': jsonEncode(details.status), 'order_status': status};
    debugPrint(jsonEncode(param));
    Response response = await parser.updateOrderStatus(param);
    Get.back();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      if (body == true) {
        showToast('Status Updated');
        if (userDetails.fcmToken != null) {
          var notificationParam = {'title': 'Order $status', 'message': 'Your order #$orderId $status', 'id': userDetails.fcmToken.toString()};
          await parser.sendNotification(notificationParam);
        }
        var updateDriverParam = {'id': driverId.toString(), 'current': 'active'};
        await parser.updateDriver(updateDriverParam);
        Get.find<OrdersController>().getOrders();
        onBack();
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onSuccessFirebase() {
    deliverOrder();
  }

  Future<void> sendOtpOnDelivery() async {
    if (smsName == '2') {
      debugPrint('otp on firebase');
      Get.dialog(
        SimpleDialog(
          children: [
            Row(
              children: [
                const SizedBox(width: 30),
                const CircularProgressIndicator(color: ThemeProvider.appColor),
                const SizedBox(width: 30),
                SizedBox(child: Text("Sending OTP".tr, style: const TextStyle(fontFamily: 'bold'))),
              ],
            )
          ],
        ),
        barrierDismissible: false,
      );

      var param = {'country_code': userDetails.countryCode, 'mobile': userDetails.mobile};
      Response response = await parser.verifyPhoneWithFirebase(param);
      Get.back();
      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        if (myMap['data'] != '' && myMap['data'] == true) {
          FocusManager.instance.primaryFocus?.unfocus();
          Get.toNamed(AppRouter.getFirebaseDeliveryRoutes(), arguments: [userDetails.countryCode, userDetails.mobile]);
        } else {
          showToast('Something went wrong');
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
      update();
    } else {
      debugPrint('other otp');
      Get.dialog(
        SimpleDialog(
          children: [
            Row(
              children: [
                const SizedBox(width: 30),
                const CircularProgressIndicator(color: ThemeProvider.appColor),
                const SizedBox(width: 30),
                SizedBox(child: Text("Sending OTP".tr, style: const TextStyle(fontFamily: 'bold'))),
              ],
            )
          ],
        ),
        barrierDismissible: false,
      );
      var param = {'country_code': userDetails.countryCode, 'mobile': userDetails.mobile};
      Response response = await parser.verifyPhone(param);
      Get.back();
      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        if (myMap['data'] != '' && myMap['data'] == true) {
          smsId = myMap['otp_id'];
          FocusManager.instance.primaryFocus?.unfocus();

          openOTPModal(userDetails.countryCode.toString() + userDetails.mobile.toString());
        } else {
          showToast('Something went wrong');
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
      update();
    }
  }

  void openOTPModal(String text) {
    var context = Get.context as BuildContext;
    showDialog(
      context: context,
      barrierColor: ThemeProvider.appColor,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0.0),
          title: Text("Verification".tr, textAlign: TextAlign.center),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                children: [
                  Text('We have sent verification code on'.tr, style: const TextStyle(fontSize: 12, fontFamily: 'medium')),
                  Text(text, style: const TextStyle(fontSize: 12, fontFamily: 'medium')),
                  const SizedBox(height: 10),
                  OtpTextField(
                    numberOfFields: 6,
                    borderColor: ThemeProvider.greyColor,
                    keyboardType: TextInputType.number,
                    focusedBorderColor: ThemeProvider.appColor,
                    showFieldAsBox: true,
                    onCodeChanged: (String code) {},
                    onSubmit: (String verificationCode) {
                      otpCode = verificationCode;
                      onOtpSubmit(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Container(
              height: 45,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white),
              child: ElevatedButton(
                onPressed: () async {
                  if (otpCode != '' && otpCode.length >= 6) {
                    onOtpSubmit(context);
                  }
                },
                style: ElevatedButton.styleFrom(foregroundColor: ThemeProvider.whiteColor, backgroundColor: ThemeProvider.appColor, elevation: 0),
                child: Text('Verify'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 16)),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> onOtpSubmit(context) async {
    Get.dialog(
      SimpleDialog(
        children: [
          Row(
            children: [
              const SizedBox(width: 30),
              const CircularProgressIndicator(color: ThemeProvider.appColor),
              const SizedBox(width: 30),
              SizedBox(child: Text("Verifying OTP".tr, style: const TextStyle(fontFamily: 'bold'))),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );
    var param = {'id': smsId, 'otp': otpCode};
    Response response = await parser.verifyOTP(param);
    Get.back();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['data'] != '' && myMap['success'] == true) {
        Navigator.of(context).pop(true);
        deliverOrder();
      } else {
        showToast('Something went wrong');
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

  void openTrackingFromUser() {
    debugPrint('open user tracking');
    Get.delete<TrackingController>(force: true);
    Get.toNamed(AppRouter.getTrackingRoutes(), arguments: [
      'user', // 0
      details.address!.lat.toString(), // 1
      details.address!.lng.toString(), // 2
      userDetails.cover, // 3
      '${userDetails.firstName} ${userDetails.lastName}', // 4
      userDetails.mobile, // 5
      '${details.address!.landmark} ${details.address!.house} ${details.address!.address} ${details.address!.pincode}', // 6
      grandTotalStore.toString(), // 7
      details.paidMethod // 8
    ]);
  }

  void openTrackingFromStore() {
    debugPrint('open store tracking');
    Get.delete<TrackingController>(force: true);
    Get.toNamed(AppRouter.getTrackingRoutes(), arguments: [
      'store', // 0
      storesDetails.lat.toString(), // 1
      storesDetails.lng.toString(), // 2
      storesDetails.cover, // 3
      storesDetails.name, // 4
      storesDetails.mobile, // 5
      storesDetails.address, // 6
      grandTotalStore.toString(), // 7
      details.paidMethod // 8
    ]);
  }
}
