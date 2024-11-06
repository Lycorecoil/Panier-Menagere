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
import 'package:vendors/app/backend/api/handler.dart';
import 'package:vendors/app/backend/models/products_model.dart';
import 'package:vendors/app/backend/parse/products_parse.dart';
import 'package:vendors/app/util/constant.dart';

class ProductsController extends GetxController implements GetxService {
  final ProductsParser parser;
  bool loadMore = false;
  bool apiCalled = false;
  RxInt lastLimit = 1.obs;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  List<ProductsModel> _productsList = <ProductsModel>[];
  List<ProductsModel> get productsList => _productsList;

  ProductsController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    getProducts();
  }

  Future<void> getProducts() async {
    debugPrint('Get products');
    Response response = await parser.getProducts(lastLimit.value);
    apiCalled = true;
    loadMore = false;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _productsList = [];
      body.forEach((data) {
        ProductsModel datas = ProductsModel.fromJson(data);
        _productsList.add(datas);
      });
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
    update();
  }

  void increment() {
    debugPrint('load more');
    loadMore = true;
    lastLimit = lastLimit++;
    update();
    getProducts();
  }

  Future<void> hardRefresh() async {
    debugPrint('hard refresh');
    lastLimit = 1.obs;
    apiCalled = false;
    update();
    await getProducts();
  }
}
