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
import 'package:vendors/app/backend/models/categories_model.dart';
import 'package:vendors/app/backend/parse/categories_parse.dart';
import 'package:vendors/app/controller/manage_product_controller.dart';

class CategoriesController extends GetxController implements GetxService {
  final CategoriesParser parser;

  String cateId = '';
  String cateName = '';

  bool apiCalled = false;

  List<CategoriesModel> _categoriesList = <CategoriesModel>[];
  List<CategoriesModel> get categoriesList => _categoriesList;
  CategoriesController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    getCatagories();
    var haveCate = Get.arguments[0];
    if (haveCate == true) {
      cateId = Get.arguments[1];
      update();
    }
  }

  void onCategoriesId() {
    Get.find<ManageProductController>().onCategorySelected(cateId, cateName);
    var context = Get.context as BuildContext;
    Navigator.of(context).pop();
  }

  void onCategorieSave(String id) {
    cateId = id;
    cateName = _categoriesList.firstWhere((element) => element.id.toString() == cateId).name!;
    debugPrint(cateName);
    update();
  }

  Future<void> getCatagories() async {
    Response response = await parser.getActiveCategory();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _categoriesList = [];
      body.forEach((data) {
        CategoriesModel datas = CategoriesModel.fromJson(data);
        _categoriesList.add(datas);
      });
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
    update();
  }
}
