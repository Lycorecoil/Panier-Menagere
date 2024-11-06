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
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:vendors/app/backend/api/handler.dart';
import 'package:vendors/app/backend/models/driver_assignment_model.dart';
import 'package:vendors/app/backend/models/order_notes_model.dart';
import 'package:vendors/app/backend/models/orders_model.dart';
import 'package:vendors/app/backend/models/user_model.dart';
import 'package:vendors/app/backend/parse/order_details_parse.dart';
import 'package:vendors/app/controller/drivers_controller.dart';
import 'package:vendors/app/controller/inbox_controller.dart';
import 'package:vendors/app/controller/orders_controller.dart';
import 'package:vendors/app/helper/router.dart';
import 'package:vendors/app/util/constant.dart';
import 'package:vendors/app/util/theme.dart';
import 'package:vendors/app/util/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class OrderDetailsController extends GetxController implements GetxService {
  final OrderDetailsParser parser;

  int orderId = 0;
  bool apiCalled = false;

  int driverAssignment = AppConstants.driverAssignment;

  OrdersModel _details = OrdersModel();
  OrdersModel get details => _details;

  UserDetailsModel _userDetails = UserDetailsModel();
  UserDetailsModel get userDetails => _userDetails;

  UserDetailsModel _driverDetails = UserDetailsModel();
  UserDetailsModel get driverDetails => _driverDetails;

  List<UserDetailsModel> _driversList = <UserDetailsModel>[];
  List<UserDetailsModel> get driversList => _driversList;

  String uid = '';

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  String invoiceURL = '';

  String orderStatus = '';

  double itemTotalStore = 0.0;
  double deliveryChargeStore = 0.0;
  double splitOrderTaxStore = 0.0;
  double splitOrderDiscountStore = 0.0;
  double splitOrderWalletDiscountStore = 0.0;
  double grandTotalStore = 0.0;
  String statusText = '';
  String myDriverId = '';

  int savedDriverId = 0;

  String selectedStatusId = '';

  OrderDetailsController({required this.parser});

  @override
  void onInit() async {
    super.onInit();
    orderId = Get.arguments[0] ?? 1;
    driverAssignment = parser.getDriverAssignment();
    uid = parser.getUID();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    statusText = ' by ${parser.getStoreName()}';
    invoiceURL = '${parser.apiService.appBaseUrl}${AppConstants.storeOrderInvoice}$orderId&token=${parser.getToken()}&storeId=$uid';
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
      orderInfoData.orders = orderInfoData.orders!.where((element) => element.storeId.toString() == uid).toList();
      orderInfoData.dateTime = Jiffy.parse(orderInfoData.dateTime.toString()).yMMMMEEEEdjm;
      _details = orderInfoData;

      var orderStatusFromStore = orderInfoData.status!.where((element) => element.id.toString() == uid).toList();
      if (orderStatusFromStore.isNotEmpty) {
        orderStatus = orderStatusFromStore[0].status.toString();
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
        myDriverId = details.assignee!.firstWhere((element) => element.assignee.toString() == uid).driver.toString();
        update();
        if (myDriverId != '' && myDriverId.isNotEmpty) {
          Response driverResponse = await parser.getDriverInfo(myDriverId);
          if (driverResponse.statusCode == 200) {
            Map<String, dynamic> myMap = Map<String, dynamic>.from(driverResponse.body);
            dynamic driverInfo = myMap["data"];
            _driverDetails = UserDetailsModel();
            UserDetailsModel dataUserInfo = UserDetailsModel.fromJson(driverInfo);
            _driverDetails = dataUserInfo;
            debugPrint(_driverDetails.firstName);
          }
        }
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
        var charge = details.extra!.firstWhereOrNull((element) => element.storeId.toString() == uid);
        if (charge?.shipping == 'km') {
          deliveryChargeCount = double.parse((charge?.distance)!.toStringAsFixed(2)) * double.parse((charge?.shippingPrice)!.toStringAsFixed(2));
        } else {
          deliveryChargeCount = double.parse((charge?.shippingPrice)!.toStringAsFixed(2)) / storeIds.length;
        }
      }

      var taxAmount = details.extra!.firstWhereOrNull((element) => element.storeId.toString() == uid)?.tax ?? 0;

      double grandTotal = total + deliveryChargeCount + taxAmount;
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

      if (details.orderTo == 'home') {
        getDriver();
      }
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
  }

  Future<void> launchInBrowser() async {
    var url = Uri.parse(invoiceURL);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void openActionModalStore(String name, String email, String phone, String uid, bool canChat, String type) {
    var context = Get.context as BuildContext;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('${'Contact'.tr} $name'),
        actions: [
          CupertinoActionSheetAction(
            child: Text('Email'.tr),
            onPressed: () {
              Navigator.pop(context);
              composeEmail(email);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Call'.tr),
            onPressed: () {
              Navigator.pop(context);
              makePhoneCall(phone);
            },
          ),
          type == 'user'
              ? CupertinoActionSheetAction(
                  child: Text('Chat'.tr),
                  onPressed: () {
                    Navigator.pop(context);
                    onChat();
                  },
                )
              : const SizedBox(),
          CupertinoActionSheetAction(
            child: Text('Cancel'.tr, style: const TextStyle(fontFamily: 'bold', color: Colors.red)),
            onPressed: () => Navigator.pop(context),
          ),
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

  void onChat() {
    Get.delete<InboxController>(force: true);
    Get.toNamed(AppRouter.getInboxRoutes(), arguments: [userDetails.id, '${userDetails.firstName} ${userDetails.lastName}']);
  }

  bottomBorder() {
    return BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: ThemeProvider.greyColor.shade300)));
  }

  void onAcceptOrder() {
    debugPrint(driverAssignment.toString());
    debugPrint(details.orderTo.toString());
    if (details.orderTo == 'home') {
      if (driverAssignment == 0) {
        debugPrint('open modal');
        Get.delete<DriversController>(force: true);
        Get.toNamed(AppRouter.getDrivers());
      } else {
        debugPrint('auto assign');
        Get.generalDialog(
          pageBuilder: (context, __, ___) => AlertDialog(
            title: Text('Are you sure?'.tr),
            content: Text("to Accept this order?".tr),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontFamily: 'medium'))),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  autoAcceptOrder();
                },
                child: Text('Yes, Accept Order'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold')),
              )
            ],
          ),
        );
      }
    } else {
      changeOrderStatus('Accept', 'accepted');
    }
  }

  Future<void> onDriverSave(int id) async {
    savedDriverId = id;
    debugPrint(savedDriverId.toString());
    var status = 'accepted';
    var orderNotesParam = {'status': 1, 'value': 'Order $status$statusText', 'time': Jiffy.now().format(pattern: 'MMMM do yyyy, h:mm:ss a')};
    OrderNotesModel orderNotesParse = OrderNotesModel.fromJson(orderNotesParam);
    _details.notes!.add(orderNotesParse);
    for (var item in _details.status!) {
      if (item.id.toString() == uid) {
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
    var assignee = {'driver': savedDriverId.toString(), 'assignee': uid};
    DriverAssignmentModel assignments = DriverAssignmentModel.fromJson(assignee);
    details.assignee!.add(assignments);
    debugPrint(jsonEncode(details).toString());
    List<int>? driverIds = [];
    if (details.driverId != null) {
      var ids = details.driverId!.split(',');
      for (var item in ids) {
        driverIds.add(int.parse(item));
      }
    }
    driverIds.add(savedDriverId);
    var param = {'id': orderId, 'notes': jsonEncode(details.notes), 'status': jsonEncode(details.status), 'assignee': jsonEncode(details.assignee), 'order_status': status, 'driver_id': driverIds.join(',')};
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
        if (userDetails.fcmToken != null) {
          var notificationParam = {'title': 'New Order Received', 'message': '${parser.getStoreName()} assigned you new order', 'id': driverDetails.fcmToken.toString()};
          await parser.sendNotification(notificationParam);
        }
        var updateDriverParam = {'id': driversList[0].id.toString(), 'current': 'busy'};
        await parser.updateDriver(updateDriverParam);
        Get.find<OrdersController>().getOrders();
        onBack();
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  Future<void> autoAcceptOrder() async {
    var status = 'accepted';
    var orderNotesParam = {'status': 1, 'value': 'Order $status$statusText', 'time': Jiffy.now().format(pattern: 'MMMM do yyyy, h:mm:ss a')};
    OrderNotesModel orderNotesParse = OrderNotesModel.fromJson(orderNotesParam);
    _details.notes!.add(orderNotesParse);
    for (var item in _details.status!) {
      if (item.id.toString() == uid) {
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
    var assignee = {'driver': driversList[0].id.toString(), 'assignee': uid};
    DriverAssignmentModel assignments = DriverAssignmentModel.fromJson(assignee);
    details.assignee!.add(assignments);
    debugPrint(jsonEncode(details).toString());
    List<int>? driverIds = [];
    if (details.driverId != null) {
      var ids = details.driverId!.split(',');
      for (var item in ids) {
        driverIds.add(int.parse(item));
      }
    }
    driverIds.add(driversList[0].id as int);
    var param = {'id': orderId, 'notes': jsonEncode(details.notes), 'status': jsonEncode(details.status), 'assignee': jsonEncode(details.assignee), 'order_status': status, 'driver_id': driverIds.join(',')};
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
        var updateDriverParam = {'id': driversList[0].id.toString(), 'current': 'busy'};
        await parser.updateDriver(updateDriverParam);
        Get.find<OrdersController>().getOrders();
        onBack();
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getDriver() async {
    Response response = await parser.getDrivers();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _driversList = [];
      body.forEach((data) {
        UserDetailsModel dataInfo = UserDetailsModel.fromJson(data);
        _driversList.add(dataInfo);
        double driverDistance = 0.0;
        driverDistance = Geolocator.distanceBetween(
          double.tryParse(dataInfo.lat.toString()) ?? 0.0,
          double.tryParse(dataInfo.lng.toString()) ?? 0.0,
          double.tryParse(details.address!.lat.toString()) ?? 0.0,
          double.tryParse(details.address!.lng.toString()) ?? 0.0,
        );
        double distance = double.parse((driverDistance / 1000).toStringAsFixed(2));
        dataInfo.distance = distance;
      });
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void changeOrderStatus(String name, String status) {
    Get.generalDialog(
      pageBuilder: (context, __, ___) => AlertDialog(
        title: Text('Are you sure?'.tr),
        content: Text('${'to'.tr} $name ${'this order?'.tr}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel'.tr, style: const TextStyle(color: ThemeProvider.blackColor, fontFamily: 'medium'))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              updateOrderStatus(status);
            },
            child: Text('${'Yes'.tr} $name ${'Order'.tr}', style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold')),
          )
        ],
      ),
    );
  }

  Future<void> updateOrderStatus(String status) async {
    var orderNotesParam = {'status': 1, 'value': 'Order $status$statusText', 'time': Jiffy.now().format(pattern: 'MMMM do yyyy, h:mm:ss a')};
    OrderNotesModel orderNotesParse = OrderNotesModel.fromJson(orderNotesParam);
    _details.notes!.add(orderNotesParse);
    for (var item in _details.status!) {
      if (item.id.toString() == uid) {
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
      if (selectedStatusId != 'ongoing' && details.orderTo == 'home') {
        debugPrint('deliver, cancelled,rejected');
        var status = selectedStatusId;
        var orderNotesParam = {'status': 1, 'value': 'Order $status$statusText', 'time': Jiffy.now().format(pattern: 'MMMM do yyyy, h:mm:ss a')};
        OrderNotesModel orderNotesParse = OrderNotesModel.fromJson(orderNotesParam);
        _details.notes!.add(orderNotesParse);
        for (var item in _details.status!) {
          if (item.id.toString() == uid) {
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
            var updateDriverParam = {'id': myDriverId.toString(), 'current': 'active'};
            await parser.updateDriver(updateDriverParam);
            Get.find<OrdersController>().getOrders();
            onBack();
          }
        } else {
          ApiChecker.checkApi(response);
        }
        update();
      } else {
        debugPrint('ongoing');
        changeOrderStatus(selectedStatusId.toUpperCase(), selectedStatusId);
      }
    }
  }
}
