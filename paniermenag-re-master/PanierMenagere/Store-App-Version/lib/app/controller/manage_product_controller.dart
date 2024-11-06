/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:vendors/app/backend/api/handler.dart';
import 'package:vendors/app/backend/models/products_model.dart';
import 'package:vendors/app/backend/models/variations_model.dart';
import 'package:vendors/app/backend/parse/manage_product_parse.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendors/app/controller/categories_controller.dart';
import 'package:vendors/app/controller/products_controller.dart';
import 'package:vendors/app/controller/sub_categories_controller.dart';
import 'package:vendors/app/helper/router.dart';
import 'package:vendors/app/util/constant.dart';
import 'package:vendors/app/util/theme.dart';
import 'package:vendors/app/util/toast.dart';

class ManageProductController extends GetxController implements GetxService {
  final ManageProductParser parser;
  int productId = 0;
  String kind = 'create';
  RxBool isLogin = false.obs;

  String categoryName = '';
  String cateId = '';

  String subCateName = '';
  String subCateId = '';

  int status = 1;
  String statusText = 'Available';

  int inStock = 1;
  String inStockText = 'In Stock';

  bool haveVeg = false;
  bool isSingle = false;
  bool inOffer = false;

  bool inGram = false;
  final gramValue = TextEditingController();
  bool inKG = false;
  final kgValue = TextEditingController();
  bool inLiter = false;
  final literValue = TextEditingController();
  bool inPcs = false;
  final pcsValue = TextEditingController();
  bool inML = false;
  final mlValue = TextEditingController();

  bool sizeOfProduct = false;

  String productCover = '';

  XFile? _selectedImage;
  List<String> galleryImage = ['', '', '', '', '', ''];

  final title = TextEditingController();
  final originalPrice = TextEditingController();
  final discountPrice = TextEditingController();
  final sellPrice = TextEditingController();
  final description = TextEditingController();
  final keyfeature = TextEditingController();
  final disclaimer = TextEditingController();

  final variationTitle = TextEditingController();
  final variationPrice = TextEditingController();
  final variationDiscount = TextEditingController();

  String expireDate = '';

  DateTime date = DateTime.now();

  List<VariationsModel> _variationsList = <VariationsModel>[];
  List<VariationsModel> get variationsList => _variationsList;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  ProductsModel _details = ProductsModel();
  ProductsModel get details => _details;

  String uid = '';

  bool editAddons = false;
  int addonsId = 0;

  bool apiCalled = false;
  ManageProductController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    uid = parser.getUID();
    kind = Get.arguments[0];
    if (kind == 'update') {
      productId = Get.arguments[1];
      debugPrint('productId$productId');
      getProductById();
    }
    debugPrint(kind);
  }

  Future<void> getProductById() async {
    Response response = await parser.getProductInfo(productId);
    apiCalled = true;
    update();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic productInfo = myMap["data"];
      _details = ProductsModel();
      ProductsModel info = ProductsModel.fromJson(productInfo);
      _details = info;
      title.text = info.name.toString();
      productCover = info.cover.toString();
      description.text = info.descriptions.toString();
      disclaimer.text = info.disclaimer.toString();
      discountPrice.text = info.discount.toString();
      expireDate = expireDate = Jiffy.parse(info.expDate.toString()).format(pattern: 'd/MM/yyyy').toString();
      gramValue.text = info.gram.toString();
      inGram = info.haveGram == 1 ? true : false;
      inKG = info.haveKg == 1 ? true : false;
      inLiter = info.haveLiter == 1 ? true : false;
      inML = info.haveMl == 1 ? true : false;
      inPcs = info.havePcs == 1 ? true : false;

      inOffer = info.inOffer == 1 ? true : false;
      inStock = info.inStoke as int;
      isSingle = info.isSingle == 1 ? true : false;
      keyfeature.text = info.keyFeatures.toString();
      kgValue.text = info.kg.toString();
      haveVeg = info.kind == 1 ? true : false;
      literValue.text = info.liter.toString();
      mlValue.text = info.ml.toString();
      originalPrice.text = info.originalPrice.toString();
      pcsValue.text = info.pcs.toString();
      sellPrice.text = info.sellPrice.toString();
      sizeOfProduct = info.size == 1 ? true : false;
      status = info.status as int;
      statusText = info.status == 1 ? 'Available'.tr : 'Hide'.tr;
      subCateId = info.subCateId.toString();
      cateId = info.cateId.toString();

      List<dynamic> images = jsonDecode(info.images.toString());
      images.asMap().forEach((index, value) {
        galleryImage[index] = value;
      });
      dynamic cateInfo = myMap["category"];
      dynamic subCateInfo = myMap["subCategory"];
      categoryName = cateInfo['name'];
      subCateName = subCateInfo['name'];
      if (info.size == 1 && info.variations!.isNotEmpty && info.variations![0].items!.isNotEmpty) {
        for (var element in info.variations![0].items!) {
          VariationsModel vari = VariationsModel.fromJson(element.toJson());
          _variationsList.add(vari);
        }
      }
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
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
    expireDate = Jiffy.parse(newDate.toString()).format(pattern: 'd/MM/yyyy').toString();
    debugPrint(expireDate);
    update();
  }

  void updateSizeOfProduct(bool value) {
    sizeOfProduct = value;
    if (value == false) {
      _variationsList = [];
    }
    update();
  }

  void removeSizeOfProduct() {
    sizeOfProduct = false;
    _variationsList = [];
    update();
  }

  void updatePcsValue(bool value) {
    inPcs = value;
    update();
  }

  void updateMLValue(bool value) {
    inML = value;
    update();
  }

  void updateGramValue(bool value) {
    inGram = value;
    update();
  }

  void updateKGValue(bool value) {
    inKG = value;
    update();
  }

  void updateLiterValue(bool value) {
    inLiter = value;
    update();
  }

  void getActiveCategories() {
    bool haveCategories = cateId != '' ? true : false;
    Get.delete<CategoriesController>(force: true);
    Get.toNamed(AppRouter.getCategoriesRoutes(), arguments: [haveCategories, cateId]);
  }

  void onCategorySelected(String id, String name) {
    cateId = id;
    categoryName = name;
    update();
  }

  void onSubCategorySelected(String id, String name) {
    subCateId = id;
    subCateName = name;
    update();
  }

  void openSubCategoryModal() {
    if (cateId == '') {
      showToast('Please select category');
      return;
    }
    bool haveSubCategory = subCateId != '' ? true : false;
    Get.delete<SubCategoriesController>(force: true);
    Get.toNamed(AppRouter.getSubCategoriesRoutes(), arguments: [cateId, haveSubCategory, subCateId]);
  }

  void updateSingleValue(bool value) {
    isSingle = value;
    update();
  }

  void updateOffer(bool value) {
    inOffer = value;
    update();
  }

  void updateStatus(int selected) {
    status = selected;
    statusText = status == 1 ? 'Available'.tr : 'Hide'.tr;
    update();
  }

  void updateStock(int selected) {
    inStock = selected;
    inStockText = inStock == 1 ? 'In Stock'.tr : 'Out Of Stock'.tr;
    update();
  }

  void updateVeg(bool value) {
    haveVeg = value;
    update();
  }

  void selectFromGallery(String kind) async {
    _selectedImage = await ImagePicker().pickImage(source: kind == 'gallery' ? ImageSource.gallery : ImageSource.camera, imageQuality: 25);
    update();
    if (_selectedImage != null) {
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
      Response response = await parser.uploadImage(_selectedImage as XFile);
      Get.back();
      if (response.statusCode == 200) {
        _selectedImage = null;
        if (response.body['data'] != null && response.body['data'] != '') {
          dynamic body = response.body["data"];
          if (body['image_name'] != null && body['image_name'] != '') {
            productCover = body['image_name'];
            update();
          }
        }
      } else {
        ApiChecker.checkApi(response);
      }
    }
  }

  void uploadMoreImage(String kind, int index) async {
    _selectedImage = await ImagePicker().pickImage(source: kind == 'gallery' ? ImageSource.gallery : ImageSource.camera, imageQuality: 25);
    update();
    if (_selectedImage != null) {
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
      Response response = await parser.uploadImage(_selectedImage as XFile);
      Get.back();
      if (response.statusCode == 200) {
        _selectedImage = null;
        if (response.body['data'] != null && response.body['data'] != '') {
          dynamic body = response.body["data"];
          if (body['image_name'] != null && body['image_name'] != '') {
            galleryImage[index] = body['image_name'];
            update();
          }
        }
      } else {
        ApiChecker.checkApi(response);
      }
    }
  }

  void onSave() {
    if (cateId == '') {
      showToast('Please select category');
      return;
    }
    if (subCateId == '') {
      showToast('Please select sub category');
      return;
    }
    if (originalPrice.text == '') {
      showToast('Please enter product price');
      return;
    }
    if (description.text == '') {
      showToast('Please enter product description');
      return;
    }
    if (title.text == '') {
      showToast('Please enter product name');
      return;
    }
    if (productCover == '') {
      showToast('Please add product image');
      return;
    }

    if (kind == 'create') {
      createProduct();
    } else {
      updateProductInfo();
    }
  }

  Future<void> updateProductInfo() async {
    debugPrint(expireDate.toString());
    String savedExpireDate = '';
    if (expireDate.isNotEmpty) {
      List<String> dateParts = expireDate.split('/');
      debugPrint('${dateParts.toString()} -- ${dateParts.length}');
      if (dateParts.length == 3) {
        debugPrint('OK');
        savedExpireDate = Jiffy.parse('${dateParts[2]}/${dateParts[1]}/${dateParts[0]}').format(pattern: 'yyyy/MM/d').toString();
        debugPrint('Saved Date ---- >> $savedExpireDate');
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
              SizedBox(child: Text("Please wait".tr, style: const TextStyle(fontFamily: 'bold'))),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );

    isLogin.value = !isLogin.value;
    update();
    double realPriceParam = num.tryParse(originalPrice.text)!.toDouble();
    double sellPriceParam = num.tryParse(sellPrice.text)!.toDouble();
    double discountPriceParam = num.tryParse(discountPrice.text)!.toDouble();
    var variationData = {"title": "size", "type": "radio", "items": variationsList};
    List variationInfo = [];
    variationInfo.add(variationData);

    var param = {
      'store_id': uid,
      'cover': productCover,
      'name': title.text,
      'images': jsonEncode(galleryImage),
      'original_price': realPriceParam,
      'sell_price': sellPriceParam > 0 ? sellPriceParam : 0,
      'discount': discountPriceParam > 0 ? discountPriceParam : 0,
      'kind': haveVeg == true ? 1 : 0,
      'cate_id': cateId,
      'sub_cate_id': subCateId,
      'have_gram': inGram == true ? 1 : 0,
      'gram': inGram == true
          ? gramValue.text != ''
              ? gramValue.text
              : 0
          : 0,
      'have_kg': inKG == true ? 1 : 0,
      'kg': inKG == true
          ? kgValue.text != ''
              ? kgValue.text
              : 0
          : 0,
      'have_pcs': inPcs == true ? 1 : 0,
      'pcs': inPcs == true
          ? pcsValue.text != ''
              ? pcsValue.text
              : 0
          : 0,
      'have_liter': inLiter == true ? 1 : 0,
      'liter': inLiter == true
          ? literValue.text != ''
              ? literValue.text
              : 0
          : 0,
      'have_ml': inML == true ? 1 : 0,
      'ml': inML == true
          ? mlValue.text != ''
              ? mlValue.text
              : 0
          : 0,
      'descriptions': description.text != '' ? description.text : '',
      'exp_date': savedExpireDate,
      'type_of': 1,
      'in_stoke': inStock,
      'status': status,
      'in_offer': inOffer == true ? 1 : 0,
      'key_features': keyfeature.text != '' ? keyfeature.text : '',
      'disclaimer': disclaimer.text != '' ? disclaimer.text : '',
      'is_single': isSingle == true ? 1 : 0,
      'in_home': 0,
      'rating': 0,
      'total_rating': 0,
      'size': sizeOfProduct == true ? 1 : 0,
      'variations': jsonEncode(variationInfo),
      "id": productId
    };
    debugPrint(jsonEncode(param));
    Response response = await parser.updateProduct(param);
    isLogin.value = !isLogin.value;
    update();
    Get.back();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic productResponse = myMap["data"];
      debugPrint(productResponse.toString());
      successToast('Product updated'.tr);
      onBack();
    } else {
      Get.offNamed(AppRouter.getLoginRoute());
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> createProduct() async {
    debugPrint(expireDate.toString());
    String savedExpireDate = '';
    if (expireDate.isNotEmpty) {
      List<String> dateParts = expireDate.split('/');
      debugPrint('${dateParts.toString()} -- ${dateParts.length}');
      if (dateParts.length == 3) {
        debugPrint('OK');
        savedExpireDate = Jiffy.parse('${dateParts[2]}/${dateParts[1]}/${dateParts[0]}').format(pattern: 'yyyy/MM/d').toString();
        debugPrint('Saved Date ---- >> $savedExpireDate');
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
              SizedBox(child: Text("Please wait".tr, style: const TextStyle(fontFamily: 'bold'))),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );

    isLogin.value = !isLogin.value;
    update();
    double realPriceParam = num.tryParse(originalPrice.text)!.toDouble();
    double sellPriceParam = num.tryParse(sellPrice.text)!.toDouble();
    double discountPriceParam = num.tryParse(discountPrice.text)!.toDouble();
    var variationData = {"title": "size", "type": "radio", "items": variationsList};
    List variationInfo = [];
    variationInfo.add(variationData);

    var param = {
      'store_id': uid,
      'cover': productCover,
      'name': title.text,
      'images': jsonEncode(galleryImage),
      'original_price': realPriceParam,
      'sell_price': sellPriceParam > 0 ? sellPriceParam : 0,
      'discount': discountPriceParam > 0 ? discountPriceParam : 0,
      'kind': haveVeg == true ? 1 : 0,
      'cate_id': cateId,
      'sub_cate_id': subCateId,
      'have_gram': inGram == true ? 1 : 0,
      'gram': inGram == true
          ? gramValue.text != ''
              ? gramValue.text
              : 0
          : 0,
      'have_kg': inKG == true ? 1 : 0,
      'kg': inKG == true
          ? kgValue.text != ''
              ? kgValue.text
              : 0
          : 0,
      'have_pcs': inPcs == true ? 1 : 0,
      'pcs': inPcs == true
          ? pcsValue.text != ''
              ? pcsValue.text
              : 0
          : 0,
      'have_liter': inLiter == true ? 1 : 0,
      'liter': inLiter == true
          ? literValue.text != ''
              ? literValue.text
              : 0
          : 0,
      'have_ml': inML == true ? 1 : 0,
      'ml': inML == true
          ? mlValue.text != ''
              ? mlValue.text
              : 0
          : 0,
      'descriptions': description.text != '' ? description.text : '',
      'exp_date': savedExpireDate,
      'type_of': 1,
      'in_stoke': inStock,
      'status': status,
      'in_offer': inOffer == true ? 1 : 0,
      'key_features': keyfeature.text != '' ? keyfeature.text : '',
      'disclaimer': disclaimer.text != '' ? disclaimer.text : '',
      'is_single': isSingle == true ? 1 : 0,
      'in_home': 0,
      'rating': 0,
      'total_rating': 0,
      'size': sizeOfProduct == true ? 1 : 0,
      'variations': jsonEncode(variationInfo)
    };
    debugPrint(jsonEncode(param));
    Response response = await parser.createProduct(param);
    isLogin.value = !isLogin.value;
    update();
    Get.back();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic productResponse = myMap["data"];
      debugPrint(productResponse.toString());
      successToast('Product created');
      onBack();
    } else {
      Get.offNamed(AppRouter.getLoginRoute());
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onBack() {
    Get.find<ProductsController>().getProducts();
    var context = Get.context as BuildContext;
    Navigator.of(context).pop();
  }

  void addNewVariations(bool updateAddons) {
    editAddons = updateAddons;
    update();
    debugPrint('addNewVariations');
    var context = Get.context as BuildContext;
    showDialog(
      context: context,
      barrierColor: ThemeProvider.appColor,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0.0),
          title: Text("Add item to size".tr, textAlign: TextAlign.center),
          content: AbsorbPointer(
            absorbing: isLogin.value == false ? false : true,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(children: [Text('Add-ons name'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor))]),
                          TextFormField(
                            controller: variationTitle,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(fillColor: Colors.white),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(children: [Text('Add-ons price price'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor))]),
                          TextFormField(
                            controller: variationPrice,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(fillColor: Colors.white),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(children: [Text('Add-ons discount price'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor))]),
                          TextFormField(
                            controller: variationDiscount,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(fillColor: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                variationTitle.clear();
                variationDiscount.clear();
                variationPrice.clear();
                update();
              },
              child: Text('Cancel'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'semibold')),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onSaveVariation();
              },
              child: Text('Okay'.tr, style: const TextStyle(color: ThemeProvider.appColor, fontFamily: 'bold')),
            )
          ],
        );
      },
    );
  }

  void onSaveVariation() {
    if (variationTitle.text == '' && variationPrice.text == '') {
      return;
    }
    if (editAddons == false) {
      var param = {"title": variationTitle.text, "price": num.tryParse(variationPrice.text)!.toDouble(), "discount": num.tryParse(variationDiscount.text)!.toDouble()};

      VariationsModel info = VariationsModel.fromJson(param);
      _variationsList.add(info);
      debugPrint(jsonEncode(_variationsList));
      variationTitle.clear();
      variationDiscount.clear();
      variationPrice.clear();
      update();
    } else {
      variationsList[addonsId].title = variationTitle.text;
      variationsList[addonsId].price = num.tryParse(variationPrice.text)!.toDouble();
      variationsList[addonsId].discount = num.tryParse(variationDiscount.text)!.toDouble();
      update();
    }
  }

  void updateAddont(int index) {
    addonsId = index;
    editAddons = true;
    variationTitle.text = variationsList[index].title.toString();
    variationPrice.text = variationsList[index].price.toString();
    variationDiscount.text = variationsList[index].discount.toString();
    addNewVariations(true);
  }

  void removeAddons(int index) {
    _variationsList.removeAt(index);
    update();
  }

  void onRealPrice(var input) {
    if (input != '' && discountPrice.text != '') {
      double value = num.tryParse(input)!.toDouble();
      debugPrint(value.toString());
      double sellPriceFinal = num.tryParse(discountPrice.text)!.toDouble();
      if (sellPriceFinal > 0 && value > 1) {
        double discountPriceFinal = num.tryParse(discountPrice.text)!.toDouble();
        double realPrice = num.tryParse(originalPrice.text)!.toDouble();
        percentage(discountPriceFinal, realPrice);
      }
    }
  }

  void onDiscountPrice(var input) {
    if (input != '' && originalPrice.text != '') {
      double value = num.tryParse(input)!.toDouble();
      double realPrice = num.tryParse(originalPrice.text)!.toDouble();
      if (realPrice > 0 && value <= 99) {
        double discountPriceFinal = num.tryParse(discountPrice.text)!.toDouble();
        percentage(discountPriceFinal, realPrice);
      }
      if (value >= 99) {
        discountPrice.text = '';
        discountPrice.text = '99';
        showToast('Discount must be less than 100');
        update();
      }
    }
  }

  void percentage(double percent, double total) {
    double sum = (total * percent) / 100;
    sum = double.parse((sum).toStringAsFixed(2));
    debugPrint(sum.toString());
    // sellPrice.text = sum.toString();
    double realPrice = num.tryParse(originalPrice.text)!.toDouble();
    sellPrice.text = (realPrice - sum).toString();
    update();
  }
}
