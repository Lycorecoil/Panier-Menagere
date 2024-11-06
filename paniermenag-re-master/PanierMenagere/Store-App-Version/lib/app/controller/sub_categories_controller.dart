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
import 'package:vendors/app/backend/models/sub_category_model.dart';
import 'package:vendors/app/backend/parse/sub_categories_parse.dart';
import 'package:vendors/app/controller/manage_product_controller.dart';

class SubCategoriesController extends GetxController implements GetxService {
  final SubCategoriesParser parser;

  var cateId = '';
  var subCateId = '';

  var cateName = '';
  var subCateName = '';

  bool apiCalled = false;

  List<SubCategoryModel> _categoriesList = <SubCategoryModel>[];
  List<SubCategoryModel> get categoriesList => _categoriesList;
  SubCategoriesController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    cateId = Get.arguments[0];
    getCatagories();
    bool haveSubCategory = Get.arguments[1];
    if (haveSubCategory == true) {
      subCateId = Get.arguments[2];
      update();
    }
  }

  Future<void> getCatagories() async {
    Response response = await parser.getCategory(cateId);
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _categoriesList = [];
      body.forEach((data) {
        SubCategoryModel datas = SubCategoryModel.fromJson(data);
        _categoriesList.add(datas);
      });
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
    update();
  }

  void onCategoriesId() {
    Get.find<ManageProductController>().onSubCategorySelected(subCateId, cateName);
    var context = Get.context as BuildContext;
    Navigator.of(context).pop();
  }

  void onCategorieSave(String id) {
    subCateId = id;
    cateName = _categoriesList.firstWhere((element) => element.id.toString() == subCateId).name!;
    debugPrint(cateName);
    update();
  }
}
