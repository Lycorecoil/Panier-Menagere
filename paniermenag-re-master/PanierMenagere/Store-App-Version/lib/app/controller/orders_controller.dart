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
import 'package:jiffy/jiffy.dart';
import 'package:vendors/app/backend/api/handler.dart';
import 'package:vendors/app/backend/models/orders_model.dart';
import 'package:vendors/app/backend/parse/orders_parse.dart';
import 'package:vendors/app/util/constant.dart';

class OrdersController extends GetxController implements GetxService {
  final OrdersParser parser;
  bool loadMore = false;
  bool apiCalled = false;
  RxInt lastLimit = 1.obs;
  String uid = '';
  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  List<OrdersModel> _newOrderList = <OrdersModel>[];
  List<OrdersModel> get newOrderList => _newOrderList;

  List<OrdersModel> _onGoingOrderList = <OrdersModel>[];
  List<OrdersModel> get onGoingOrderList => _onGoingOrderList;

  List<OrdersModel> _olderOrderList = <OrdersModel>[];
  List<OrdersModel> get olderOrderList => _olderOrderList;

  OrdersController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    uid = parser.getUID();
    getOrders();
  }

  Future<void> getOrders() async {
    debugPrint('Get Orders');
    if (parser.haveLoggedIn() == true) {
      Response response = await parser.getOrder(lastLimit.value);
      apiCalled = true;
      loadMore = false;
      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        dynamic body = myMap["data"];
        _newOrderList = [];
        _onGoingOrderList = [];
        _olderOrderList = [];
        body.forEach((data) {
          OrdersModel datas = OrdersModel.fromJson(data);
          if (datas.orders!.isNotEmpty) {
            datas.dateTime = Jiffy.parse(datas.dateTime.toString()).yMMMMEEEEdjm;
            datas.orders = datas.orders!.where((element) => element.storeId.toString() == uid).toList();
            datas.status = datas.status!.where((element) => element.id.toString() == uid).toList();
            var currentStatus = datas.status!.firstWhereOrNull((element) => element.id.toString() == uid);
            if (currentStatus != null) {
              if (currentStatus.status == 'created') {
                _newOrderList.add(datas);
              } else if (currentStatus.status == 'accepted' || currentStatus.status == 'picked' || currentStatus.status == 'ongoing') {
                _onGoingOrderList.add(datas);
              } else if (currentStatus.status == 'rejected' || currentStatus.status == 'cancelled' || currentStatus.status == 'delivered' || currentStatus.status == 'refund') {
                _olderOrderList.add(datas);
              }
            }
          }
        });
        update();
      } else {
        ApiChecker.checkApi(response);
        update();
      }
      update();
    }
  }

  void increment() {
    debugPrint('load more');
    loadMore = true;
    lastLimit = lastLimit++;
    update();
    getOrders();
  }

  Future<void> hardRefresh() async {
    debugPrint('hard refresh');
    lastLimit = 1.obs;
    apiCalled = false;
    update();
    await getOrders();
  }
}
