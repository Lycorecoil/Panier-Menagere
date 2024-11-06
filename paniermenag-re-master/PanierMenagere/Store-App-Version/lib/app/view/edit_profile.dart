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
import 'package:vendors/app/controller/edit_profile_controller.dart';
import 'package:vendors/app/util/theme.dart';
import 'package:vendors/app/env.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: true,
            title: Text('Profile'.tr, style: ThemeProvider.titleStyle),
            leading: IconButton(icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor), onPressed: () => Get.back()),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 30),
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
                            CupertinoActionSheetAction(child: Text('Cancel'.tr, style: const TextStyle(fontFamily: 'bold', color: Colors.red)), onPressed: () => Navigator.pop(context)),
                          ],
                        ),
                      );
                    },
                    child: value.storeCover == ''
                        ? Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(border: Border.all(color: ThemeProvider.greyColor), borderRadius: BorderRadius.circular(5)),
                            child: Center(child: Text('Your store cover image'.tr, style: ThemeProvider.titleStyle)),
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: 150,
                            child: FadeInImage(
                              image: NetworkImage('${Environments.apiBaseURL}storage/images/${value.storeCover}'),
                              placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                              },
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Color.fromRGBO(255, 255, 255, 1)),
                    child: TextField(
                      controller: value.storeName,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        labelText: 'Store Name'.tr,
                        labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Color.fromRGBO(255, 255, 255, 1)),
                    child: TextField(
                      controller: value.storeAddress,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      maxLines: 4,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        labelText: 'Store Address'.tr,
                        labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text('Select Latitude & Longitude from here :'.tr, style: const TextStyle(fontSize: 12, fontFamily: 'regular')),
                      const SizedBox(height: 5),
                      InkWell(onTap: () => value.openLink(), child: const Text('https://www.mapcoordinates.net/en', style: TextStyle(fontSize: 12, fontFamily: 'regular', color: Colors.blue))),
                      const SizedBox(height: 10),
                      Text('Please enter valid Latitude & Longitude otherwise app may not work properly.'.tr, style: const TextStyle(fontSize: 12, fontFamily: 'regular'), textAlign: TextAlign.center),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Color.fromRGBO(255, 255, 255, 1)),
                    child: TextField(
                      controller: value.storeLat,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        labelText: 'Store Latitude'.tr,
                        labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Color.fromRGBO(255, 255, 255, 1)),
                    child: TextField(
                      controller: value.storeLng,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        labelText: 'Store Longitude'.tr,
                        labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Color.fromRGBO(255, 255, 255, 1)),
                    child: TextField(
                      controller: value.storZipCode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        labelText: 'Zipcode'.tr,
                        labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Color.fromRGBO(255, 255, 255, 1)),
                    child: TextField(
                      controller: value.description,
                      keyboardType: TextInputType.text,
                      maxLines: 5,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        labelText: 'Description'.tr,
                        labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => value.openTimePicker(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                      decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: ThemeProvider.greyColor))),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Open Time'.tr), Text(value.openTime)]),
                    ),
                  ),
                  InkWell(
                    onTap: () => value.closeTimePicker(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                      decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: ThemeProvider.greyColor))),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Close Time'.tr), Text(value.closeTime)]),
                    ),
                  ),
                  Container(
                    height: 45,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white),
                    child: ElevatedButton(
                      onPressed: () => value.saveData(),
                      style: ElevatedButton.styleFrom(foregroundColor: ThemeProvider.whiteColor, backgroundColor: ThemeProvider.appColor, elevation: 0),
                      child: value.isLogin.value == true ? const CircularProgressIndicator(color: ThemeProvider.whiteColor) : Text('Update'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
