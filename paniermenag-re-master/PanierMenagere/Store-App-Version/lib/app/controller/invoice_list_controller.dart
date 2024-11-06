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
import 'package:vendors/app/backend/parse/invoice_list_parse.dart';
import 'package:vendors/app/util/constant.dart';
import 'package:vendors/app/util/theme.dart';

class InvoiceListController extends GetxController implements GetxService {
  final InvoiceListParser parser;

  String openTime = '';
  String closeTime = '';
  DateTime date = DateTime.now();

  String startDate = '';
  String endDate = '';

  String todaysDate = '';

  double commission = 0.0;
  double commisionAmount = 0.0;
  double totalAmount = 0.0;
  String uid = '';
  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  String storeName = '';
  String storeAddress = '';
  String storeMobile = '';
  String storeZipcode = '';
  String storeEmail = '';

  bool haveData = false;

  List<OrdersModel> _productList = <OrdersModel>[];
  List<OrdersModel> get productList => _productList;

  InvoiceListController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    storeName = parser.storeName();
    storeAddress = parser.storeAddress();
    storeMobile = parser.getMobile();
    storeZipcode = parser.getZipcode();
    storeEmail = parser.getEmail();
    todaysDate = Jiffy.parse(date.toString()).yMMMMd.toString();
    uid = parser.getUID();
  }

  Future<void> openTimePicker() async {
    var context = Get.context as BuildContext;
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: ThemeProvider.appColor.withOpacity(0.7), onPrimary: ThemeProvider.whiteColor, onSurface: ThemeProvider.blackColor),
            textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: ThemeProvider.appColor)),
          ),
          child: child!,
        );
      },
    );
    openTime = Jiffy.parse(newDate.toString()).yMMMMd.toString();
    startDate = Jiffy.parse(newDate!.toUtc().toString()).format(pattern: 'yyyy-MM-d HH:mm').toString();
    debugPrint(startDate);
    update();
  }

  Future<void> closeTimePicker() async {
    var context = Get.context as BuildContext;
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: ThemeProvider.appColor.withOpacity(0.7), onPrimary: ThemeProvider.whiteColor, onSurface: ThemeProvider.blackColor),
            textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: ThemeProvider.appColor)),
          ),
          child: child!,
        );
      },
    );
    closeTime = Jiffy.parse(newDate.toString()).yMMMMd.toString();
    endDate = Jiffy.parse(newDate!.toUtc().toString()).format(pattern: 'yyyy-MM-d HH:mm').toString();
    debugPrint(endDate.toString());
    update();
  }

  Future<void> getResult() async {
    if (startDate != '' && endDate != '') {
      debugPrint('get Result');
      Get.dialog(
        SimpleDialog(
          children: [
            Row(
              children: [
                const SizedBox(width: 30),
                const CircularProgressIndicator(color: ThemeProvider.appColor),
                const SizedBox(width: 30),
                SizedBox(child: Text("Please wait".tr, style: const TextStyle(fontFamily: 'bold'))),
              ],
            )
          ],
        ),
        barrierDismissible: false,
      );
      _productList = [];
      Response response = await parser.getResults(startDate, endDate);
      Get.back();
      haveData = true;
      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        dynamic body = myMap["data"];
        commission = double.parse((myMap['commission']['commission']).toStringAsFixed(2));
        debugPrint('commsion$commission');
        double total = 0;
        body.forEach((data) {
          OrdersModel info = OrdersModel.fromJson(data);
          info.dateTime = Jiffy.parse(info.dateTime.toString()).yMMMMEEEEdjm;
          info.orders = info.orders!.where((element) => element.storeId.toString() == uid).toList();
          info.status = info.status!.where((element) => element.id.toString() == uid).toList();

          var currentStatus = info.status!.firstWhereOrNull((element) => element.id.toString() == uid);
          if (currentStatus!.status == 'delivered') {
            for (var element in info.orders!) {
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
          }
          _productList.add(info);
        });
        percentage(total, per) {
          return (total / 100) * per;
        }

        double totalPrice = percentage(total, commission);
        commisionAmount = double.parse((totalPrice).toStringAsFixed(2));
        totalAmount = total;
        update();
        debugPrint(commisionAmount.toString());
        debugPrint(totalAmount.toString());
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  String getCommission(total) {
    double sum = (total * commission) / 100;
    sum = double.parse((sum).toStringAsFixed(2));
    return sum.toString();
  }
}
