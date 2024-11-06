/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:driver/app/backend/api/handler.dart';
import 'package:driver/app/backend/models/orders_model.dart';
import 'package:driver/app/backend/parse/orders_parse.dart';
import 'package:driver/app/util/constant.dart';

class OrdersController extends GetxController implements GetxService {
  final OrdersParser parser;
  bool loadMore = false;
  bool apiCalled = false;
  RxInt lastLimit = 1.obs;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  int driverId = 0;

  List<OrdersModel> _newOrderList = <OrdersModel>[];
  List<OrdersModel> get newOrderList => _newOrderList;

  List<OrdersModel> _olderOrderList = <OrdersModel>[];
  List<OrdersModel> get olderOrderList => _olderOrderList;

  OrdersController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    driverId = int.parse(parser.getUID().toString());
    getOrders();
  }

  Future<void> getOrders() async {
    if (parser.haveLoggedIn() == true) {
      Response response = await parser.getOrder(lastLimit.value);
      apiCalled = true;
      loadMore = false;
      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        dynamic body = myMap["data"];
        _newOrderList = [];
        _olderOrderList = [];
        body.forEach((data) {
          OrdersModel datas = OrdersModel.fromJson(data);
          datas.dateTime = Jiffy.parse(datas.dateTime.toString()).yMMMMEEEEdjm;
          var uid = datas.assignee!.firstWhere((element) => element.driver == driverId).assignee;

          datas.orders = datas.orders!.where((element) => element.storeId == uid).toList();
          datas.status = datas.status!.where((element) => element.id == uid).toList();

          var currentStatus = datas.status!.firstWhereOrNull((element) => element.id == uid);
          if (currentStatus != null) {
            if (currentStatus.status == 'rejected' || currentStatus.status == 'cancelled' || currentStatus.status == 'delivered' || currentStatus.status == 'refund') {
              _olderOrderList.add(datas);
            } else {
              _newOrderList.add(datas);
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
    loadMore = true;
    lastLimit = lastLimit++;
    update();
    getOrders();
  }

  Future<void> hardRefresh() async {
    lastLimit = 1.obs;
    apiCalled = false;
    update();
    await getOrders();
  }
}
