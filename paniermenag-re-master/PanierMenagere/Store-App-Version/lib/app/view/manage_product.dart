/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendors/app/controller/manage_product_controller.dart';
import 'package:vendors/app/util/theme.dart';
import 'package:vendors/app/env.dart';

class ManageProductScreen extends StatefulWidget {
  const ManageProductScreen({super.key});

  @override
  State<ManageProductScreen> createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageProductController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: Text(value.kind == 'update' ? 'Update Product'.tr : 'Create Product'.tr, style: ThemeProvider.titleStyle),
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor), onPressed: () => Get.back()),
          ),
          body: value.kind == 'update' && value.apiCalled == false
              ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor))
              : AbsorbPointer(
                  absorbing: value.isLogin.value == false ? false : true,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => value.getActiveCategories(),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(color: Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(children: [Text('Category'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor))]),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        value.categoryName != '' ? value.categoryName : 'Select Category'.tr,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor),
                                      ),
                                      const Icon(Icons.expand_more, color: Colors.grey),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () => value.openSubCategoryModal(),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(color: Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(children: [Text('Sub Category'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor))]),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        value.subCateName != '' ? value.subCateName : 'Select Sub Category'.tr,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor),
                                      ),
                                      const Icon(Icons.expand_more, color: Colors.grey),
                                    ],
                                  )
                                ],
                              ),
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
                                Row(children: [Text('Product name'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor))]),
                                TextFormField(
                                  controller: value.title,
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
                                Row(children: [Text('Product Price'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor))]),
                                TextFormField(
                                  controller: value.originalPrice,
                                  onChanged: (text) => value.onRealPrice(text),
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
                                Row(children: [Text('Discount %'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor))]),
                                TextFormField(
                                  controller: value.discountPrice,
                                  onChanged: (text) => value.onDiscountPrice(text),
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
                                Row(children: [Text('Sell Price'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor))]),
                                TextFormField(
                                  readOnly: true,
                                  controller: value.sellPrice,
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
                                Row(children: [Text('Description'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor))]),
                                TextFormField(
                                  controller: value.description,
                                  maxLines: 5,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(fillColor: Colors.white),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              showCupertinoModalPopup<void>(
                                context: context,
                                builder: (BuildContext context) => CupertinoActionSheet(
                                  title: Text('Status'.tr),
                                  actions: <CupertinoActionSheetAction>[
                                    CupertinoActionSheetAction(
                                      child: Text('Available'.tr),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        value.updateStatus(1);
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: Text('Hide'.tr),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        value.updateStatus(0);
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      onPressed: () => Navigator.pop(context),
                                      isDestructiveAction: true,
                                      child: Text('Cancel'.tr, style: const TextStyle(fontFamily: 'bold', color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(color: Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(children: [Text('Status'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor))]),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(value.statusText, textAlign: TextAlign.start, style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor)),
                                      const Icon(Icons.expand_more, color: Colors.grey),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              showCupertinoModalPopup<void>(
                                context: context,
                                builder: (BuildContext context) => CupertinoActionSheet(
                                  title: Text('In Stock'.tr),
                                  actions: <CupertinoActionSheetAction>[
                                    CupertinoActionSheetAction(
                                      child: Text('In Stock'.tr),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        value.updateStock(1);
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: Text('Out Of Stock'.tr),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        value.updateStock(0);
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      onPressed: () => Navigator.pop(context),
                                      isDestructiveAction: true,
                                      child: Text('Cancel'.tr, style: const TextStyle(fontFamily: 'bold', color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(color: Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(children: [Text('In Stock'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor))]),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(value.inStockText, textAlign: TextAlign.start, style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor)),
                                      const Icon(Icons.expand_more, color: Colors.grey),
                                    ],
                                  )
                                ],
                              ),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Veg?'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor)),
                                    Switch(
                                      onChanged: (bool status) => value.updateVeg(status),
                                      value: value.haveVeg,
                                      activeColor: ThemeProvider.appColor,
                                      activeTrackColor: ThemeProvider.secondaryAppColor,
                                      inactiveThumbColor: ThemeProvider.greyColor,
                                      inactiveTrackColor: ThemeProvider.greyColor.shade200,
                                    )
                                  ],
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Is Single'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor)),
                                    Switch(
                                      onChanged: (bool status) => value.updateSingleValue(status),
                                      value: value.isSingle,
                                      activeColor: ThemeProvider.appColor,
                                      activeTrackColor: ThemeProvider.secondaryAppColor,
                                      inactiveThumbColor: ThemeProvider.greyColor,
                                      inactiveTrackColor: ThemeProvider.greyColor.shade200,
                                    )
                                  ],
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('In Offer'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor)),
                                    Switch(
                                      onChanged: (bool status) => value.updateOffer(status),
                                      value: value.inOffer,
                                      activeColor: ThemeProvider.appColor,
                                      activeTrackColor: ThemeProvider.secondaryAppColor,
                                      inactiveThumbColor: ThemeProvider.greyColor,
                                      inactiveTrackColor: ThemeProvider.greyColor.shade200,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              showCupertinoModalPopup<void>(
                                context: context,
                                builder: (BuildContext context) => CupertinoActionSheet(
                                  title: Text('Choose From'.tr),
                                  actions: <CupertinoActionSheetAction>[
                                    CupertinoActionSheetAction(
                                      child: Text('Gallery'.tr),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        value.selectFromGallery('gallery');
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: Text('Camera'.tr),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        value.selectFromGallery('camera');
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: Text('Cancel'.tr, style: const TextStyle(fontFamily: 'bold', color: Colors.red)),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: value.productCover == ''
                                ? Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(border: Border.all(color: ThemeProvider.greyColor), borderRadius: BorderRadius.circular(5)),
                                    child: Center(child: Text('Product Cover'.tr, style: ThemeProvider.titleStyle)),
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    height: 150,
                                    child: FadeInImage(
                                      image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.productCover}'),
                                      placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                                      },
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 10),
                          Text('Upload More Images'.tr, style: const TextStyle(fontFamily: 'semibold', fontSize: 14)),
                          Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            child: GridView.count(
                              crossAxisCount: 3,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 80 / 100,
                              children: List.generate(6, (index) {
                                return _buildGallery(index);
                              }),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('In Gram'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor)),
                                    Switch(
                                      onChanged: (bool status) => value.updateGramValue(status),
                                      value: value.inGram,
                                      activeColor: ThemeProvider.appColor,
                                      activeTrackColor: ThemeProvider.secondaryAppColor,
                                      inactiveThumbColor: ThemeProvider.greyColor,
                                      inactiveTrackColor: ThemeProvider.greyColor.shade200,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          value.inGram == true
                              ? Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(color: Colors.white),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(children: [Text('Gram Value'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor))]),
                                      TextFormField(
                                        controller: value.gramValue,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(fillColor: Colors.white),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(color: Colors.white),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('In KG'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor)),
                                    Switch(
                                      onChanged: (bool status) => value.updateKGValue(status),
                                      value: value.inKG,
                                      activeColor: ThemeProvider.appColor,
                                      activeTrackColor: ThemeProvider.secondaryAppColor,
                                      inactiveThumbColor: ThemeProvider.greyColor,
                                      inactiveTrackColor: ThemeProvider.greyColor.shade200,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          value.inKG == true
                              ? Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(color: Colors.white),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(children: [Text('KG Value'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor))]),
                                      TextFormField(
                                        controller: value.kgValue,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(fillColor: Colors.white),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(color: Colors.white),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('In Liter'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor)),
                                    Switch(
                                      onChanged: (bool status) => value.updateLiterValue(status),
                                      value: value.inLiter,
                                      activeColor: ThemeProvider.appColor,
                                      activeTrackColor: ThemeProvider.secondaryAppColor,
                                      inactiveThumbColor: ThemeProvider.greyColor,
                                      inactiveTrackColor: ThemeProvider.greyColor.shade200,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          value.inLiter == true
                              ? Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(color: Colors.white),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(children: [Text('Liter Value'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor))]),
                                      TextFormField(
                                        controller: value.literValue,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(fillColor: Colors.white),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(color: Colors.white),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('In PCs'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor)),
                                    Switch(
                                      onChanged: (bool status) => value.updatePcsValue(status),
                                      value: value.inPcs,
                                      activeColor: ThemeProvider.appColor,
                                      activeTrackColor: ThemeProvider.secondaryAppColor,
                                      inactiveThumbColor: ThemeProvider.greyColor,
                                      inactiveTrackColor: ThemeProvider.greyColor.shade200,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          value.inPcs == true
                              ? Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(color: Colors.white),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(children: [Text('PCs Value'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor))]),
                                      TextFormField(
                                        controller: value.pcsValue,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(fillColor: Colors.white),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(color: Colors.white),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('In ML'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor)),
                                    Switch(
                                      onChanged: (bool status) => value.updateMLValue(status),
                                      value: value.inML,
                                      activeColor: ThemeProvider.appColor,
                                      activeTrackColor: ThemeProvider.secondaryAppColor,
                                      inactiveThumbColor: ThemeProvider.greyColor,
                                      inactiveTrackColor: ThemeProvider.greyColor.shade200,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          value.inML == true
                              ? Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(color: Colors.white),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(children: [Text('ML Value'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor))]),
                                      TextFormField(
                                        controller: value.mlValue,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(fillColor: Colors.white),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () => value.openTimePicker(),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [Text('Expire Date'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor)), Text(value.expireDate.toString())],
                                    )
                                  ],
                                ),
                              ),
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
                                Row(children: [Text('Key Features'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor))]),
                                TextFormField(
                                  controller: value.keyfeature,
                                  maxLines: 5,
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
                                Row(children: [Text('Disclaimer'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 10, color: ThemeProvider.greyColor))]),
                                TextFormField(
                                  controller: value.disclaimer,
                                  maxLines: 5,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Size?'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor)),
                                    Switch(
                                      onChanged: (bool status) => value.updateSizeOfProduct(status),
                                      value: value.sizeOfProduct,
                                      activeColor: ThemeProvider.appColor,
                                      activeTrackColor: ThemeProvider.secondaryAppColor,
                                      inactiveThumbColor: ThemeProvider.greyColor,
                                      inactiveTrackColor: ThemeProvider.greyColor.shade200,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          value.sizeOfProduct == true
                              ? Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(color: Colors.white),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Add / Remove'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor)),
                                          Row(
                                            children: [
                                              InkWell(onTap: () => value.addNewVariations(false), child: const Icon(Icons.add_circle_outline, color: ThemeProvider.blackColor)),
                                              const SizedBox(width: 20),
                                              InkWell(onTap: () => value.removeSizeOfProduct(), child: const Icon(Icons.delete_outline, color: ThemeProvider.blackColor)),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          Column(
                            children: List.generate(
                              value.variationsList.length,
                              (index) {
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(color: Colors.white),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(value.variationsList[index].title.toString(), textAlign: TextAlign.start, style: const TextStyle(fontSize: 12, color: ThemeProvider.blackColor)),
                                              const SizedBox(height: 5),
                                              value.variationsList[index].discount! > 0
                                                  ? value.currencySide == 'left'
                                                      ? Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(value.currencySymbol + value.variationsList[index].price.toString(),
                                                                style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                            Text(value.currencySymbol + value.variationsList[index].discount.toString(), style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                                          ],
                                                        )
                                                      : Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(value.variationsList[index].price.toString() + value.currencySymbol,
                                                                style: const TextStyle(fontSize: 10, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                                            Text(value.variationsList[index].discount.toString() + value.currencySymbol, style: const TextStyle(fontFamily: 'bold', fontSize: 10))
                                                          ],
                                                        )
                                                  : value.currencySide == 'left'
                                                      ? Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [Text(value.currencySymbol + value.variationsList[index].price.toString(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 10))],
                                                        )
                                                      : Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [Text(value.variationsList[index].price.toString() + value.currencySymbol, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10))],
                                                        ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              InkWell(onTap: () => value.updateAddont(index), child: const Icon(Icons.edit_outlined, color: ThemeProvider.blackColor)),
                                              const SizedBox(width: 20),
                                              InkWell(onTap: () => value.removeAddons(index), child: const Icon(Icons.delete_outline, color: ThemeProvider.blackColor)),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            height: 45,
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white),
                            child: ElevatedButton(
                              onPressed: () => value.onSave(),
                              style: ElevatedButton.styleFrom(foregroundColor: ThemeProvider.whiteColor, backgroundColor: ThemeProvider.appColor, elevation: 0),
                              child: value.isLogin.value == true ? const CircularProgressIndicator(color: ThemeProvider.whiteColor) : Text('Submit'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildGallery(int index) {
    return InkWell(
      onTap: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
            title: Text('Choose From'.tr),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                child: Text('Gallery'.tr),
                onPressed: () {
                  Navigator.pop(context);
                  Get.find<ManageProductController>().uploadMoreImage('gallery', index);
                },
              ),
              CupertinoActionSheetAction(
                child: Text('Camera'.tr),
                onPressed: () {
                  Navigator.pop(context);
                  Get.find<ManageProductController>().uploadMoreImage('camera', index);
                },
              ),
              CupertinoActionSheetAction(
                child: Text('Cancel'.tr, style: const TextStyle(fontFamily: 'bold', color: Colors.red)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
      child: Get.find<ManageProductController>().galleryImage[index] == ''
          ? Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(border: Border.all(color: ThemeProvider.greyColor), borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text('Image ${index + 1}', style: ThemeProvider.titleStyle),
              ),
            )
          : SizedBox(
              width: double.infinity,
              height: 150,
              child: FadeInImage(
                image: NetworkImage('${Environments.apiBaseURL}storage/images/${Get.find<ManageProductController>().galleryImage[index]}'),
                placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                },
                fit: BoxFit.fitWidth,
              ),
            ),
    );
  }
}
