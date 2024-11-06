/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:carousel_slider/carousel_slider.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendors/app/controller/register_controller.dart';
import 'package:vendors/app/env.dart';
import 'package:vendors/app/util/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      builder: (value) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: true,
            title: Text('Register Your Store'.tr, style: ThemeProvider.titleStyle),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: ThemeProvider.whiteColor),
              onPressed: () {
                if (value.currentIndex == 0) {
                  Get.back();
                } else {
                  value.carouselController.previousPage();
                }
              },
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(30),
              child: Column(
                children: [
                  Container(
                    color: ThemeProvider.whiteColor,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 25,
                              width: 25,
                              child: CircleAvatar(
                                backgroundColor: value.currentIndex >= 0 ? ThemeProvider.appColor.withOpacity(0.3) : ThemeProvider.blackColor.withOpacity(0.3),
                                child: Text('•', style: TextStyle(color: value.currentIndex >= 0 ? ThemeProvider.appColor : ThemeProvider.blackColor, fontFamily: 'bold')),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '1'.tr,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontFamily: 'bold', color: value.currentIndex >= 0 ? ThemeProvider.appColor : ThemeProvider.blackColor, fontSize: 10),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: value.currentIndex >= 0 ? ThemeProvider.appColor : ThemeProvider.blackColor))),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 25,
                              width: 25,
                              child: CircleAvatar(
                                backgroundColor: value.currentIndex >= 1 ? ThemeProvider.appColor.withOpacity(0.3) : ThemeProvider.blackColor.withOpacity(0.3),
                                child: Text('•', style: TextStyle(color: value.currentIndex >= 1 ? ThemeProvider.appColor : ThemeProvider.blackColor, fontFamily: 'bold')),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '2'.tr,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontFamily: 'bold', color: value.currentIndex >= 1 ? ThemeProvider.appColor : ThemeProvider.blackColor, fontSize: 10),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: value.currentIndex >= 1 ? ThemeProvider.appColor : ThemeProvider.blackColor))),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 25,
                              width: 25,
                              child: CircleAvatar(
                                backgroundColor: value.currentIndex >= 2 ? ThemeProvider.appColor.withOpacity(0.3) : ThemeProvider.blackColor.withOpacity(0.3),
                                child: Text('•', style: TextStyle(color: value.currentIndex >= 2 ? ThemeProvider.appColor : ThemeProvider.blackColor, fontFamily: 'bold')),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '3'.tr,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontFamily: 'bold', color: value.currentIndex >= 2 ? ThemeProvider.appColor : ThemeProvider.blackColor, fontSize: 10),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: value.currentIndex >= 3 ? ThemeProvider.appColor : ThemeProvider.blackColor))),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 25,
                              width: 25,
                              child: CircleAvatar(
                                backgroundColor: value.currentIndex >= 3 ? ThemeProvider.appColor.withOpacity(0.3) : ThemeProvider.blackColor.withOpacity(0.3),
                                child: Text('•', style: TextStyle(color: value.currentIndex >= 3 ? ThemeProvider.appColor : ThemeProvider.blackColor, fontFamily: 'bold')),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '4'.tr,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontFamily: 'bold', color: value.currentIndex >= 3 ? ThemeProvider.appColor : ThemeProvider.blackColor, fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: CarouselSlider(
            options: CarouselOptions(
                onPageChanged: (index, reason) => value.updateActiveIndex(index),
                height: double.infinity,
                viewportFraction: 1.0,
                initialPage: 0,
                enableInfiniteScroll: false,
                reverse: false,
                autoPlay: false,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                scrollPhysics: const NeverScrollableScrollPhysics()),
            carouselController: value.carouselController,
            items: [1, 2, 3, 4].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (i == 1)
                            AbsorbPointer(
                              absorbing: value.isLogin.value == false ? false : true,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 30),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: CountryCodePicker(
                                            onChanged: (e) => e,
                                            initialSelection: 'IN',
                                            favorite: const ['+91', 'IN'],
                                            showCountryOnly: false,
                                            showOnlyCountryWhenClosed: false,
                                            alignLeft: false,
                                            showFlag: false,
                                            showFlagDialog: true,
                                            textStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 20),
                                            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Color.fromRGBO(255, 255, 255, 1)),
                                            child: TextField(
                                              controller: value.phoneRegister,
                                              textInputAction: TextInputAction.done,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                                labelText: 'Phone Number'.tr,
                                                labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 45,
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white),
                                      child: ElevatedButton(
                                        onPressed: () => value.loginWithPhoneOTP(),
                                        style: ElevatedButton.styleFrom(foregroundColor: ThemeProvider.whiteColor, backgroundColor: ThemeProvider.appColor, elevation: 0),
                                        child: value.isLogin.value == true ? const CircularProgressIndicator(color: ThemeProvider.whiteColor) : Text('Verify Phone'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 16)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else if (i == 2)
                            AbsorbPointer(
                              absorbing: value.isLogin.value == false ? false : true,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 30),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Color.fromRGBO(255, 255, 255, 1)),
                                      child: TextField(
                                        controller: value.emailRegister,
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                          labelText: 'Email Address'.tr,
                                          labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 45,
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white),
                                      child: ElevatedButton(
                                        onPressed: () => value.loginWithEmail(),
                                        style: ElevatedButton.styleFrom(foregroundColor: ThemeProvider.whiteColor, backgroundColor: ThemeProvider.appColor, elevation: 0),
                                        child: value.isLogin.value == true ? const CircularProgressIndicator(color: ThemeProvider.whiteColor) : Text('Verify E-Mail'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 16)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else if (i == 3)
                            AbsorbPointer(
                              absorbing: value.isLogin.value == false ? false : true,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 30),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Color.fromRGBO(255, 255, 255, 1)),
                                      child: TextField(
                                        controller: value.firstNameRegsiter,
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                          labelText: 'First Name'.tr,
                                          labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Color.fromRGBO(255, 255, 255, 1)),
                                      child: TextField(
                                        controller: value.lastNameRegister,
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                          labelText: 'Last Name'.tr,
                                          labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                                      child: TextField(
                                        controller: value.passwordRegister,
                                        textInputAction: TextInputAction.done,
                                        obscureText: value.passwordVisible.value == true ? false : true,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                          labelText: 'Password'.tr,
                                          suffixIcon: InkWell(
                                            onTap: () => value.togglePassword(),
                                            child: Icon(value.passwordVisible.value == false ? Icons.visibility : Icons.visibility_off, color: ThemeProvider.appColor),
                                          ),
                                          labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
                                      child: TextField(
                                        controller: value.confirmPasswordRegister,
                                        textInputAction: TextInputAction.done,
                                        obscureText: value.passwordVisible.value == true ? false : true,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                          labelText: 'Confirm Password'.tr,
                                          suffixIcon: InkWell(
                                            onTap: () => value.togglePassword(),
                                            child: Icon(value.passwordVisible.value == false ? Icons.visibility : Icons.visibility_off, color: ThemeProvider.appColor),
                                          ),
                                          labelStyle: const TextStyle(fontSize: 14, fontFamily: 'regular', color: ThemeProvider.blackColor),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 45,
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white),
                                      child: ElevatedButton(
                                        onPressed: () => value.onGeneralInfo(),
                                        style: ElevatedButton.styleFrom(foregroundColor: ThemeProvider.whiteColor, backgroundColor: ThemeProvider.appColor, elevation: 0),
                                        child:
                                            value.isLogin.value == true ? const CircularProgressIndicator(color: ThemeProvider.whiteColor) : Text('Save Information'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 16)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else if (i == 4)
                            AbsorbPointer(
                              absorbing: value.isLogin.value == false ? false : true,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
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
                                              CupertinoActionSheetAction(
                                                child: Text('Cancel'.tr, style: const TextStyle(fontFamily: 'bold', color: Colors.red)),
                                                onPressed: () => Navigator.pop(context),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: value.storeCover == ''
                                          ? Container(
                                              width: double.infinity,
                                              height: 150,
                                              decoration: BoxDecoration(border: Border.all(color: ThemeProvider.greyColor), borderRadius: BorderRadius.circular(5)),
                                              child: Center(
                                                child: Text('Your store cover image'.tr, style: ThemeProvider.titleStyle),
                                              ),
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
                                        InkWell(
                                          onTap: () => value.openLink(),
                                          child: const Text('https://www.mapcoordinates.net/en', style: TextStyle(fontSize: 12, fontFamily: 'regular', color: Colors.blue)),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Please enter valid Latitude & Longitude otherwise app may not work properly.'.tr,
                                          style: const TextStyle(fontSize: 12, fontFamily: 'regular'),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 20),
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
                                    InkWell(
                                      onTap: () => value.onCityModal(),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: ThemeProvider.greyColor))),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(children: [Text('Choose City'.tr, textAlign: TextAlign.start, style: const TextStyle(fontSize: 8, color: ThemeProvider.greyColor))]),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  value.savedCityName != '' ? value.savedCityName : 'Select City'.tr,
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
                                    InkWell(
                                      onTap: () => value.openTimePicker(),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: ThemeProvider.greyColor))),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Open Time'.tr), Text(value.openTime)]),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => value.closeTimePicker(),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 20),
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
                                        onPressed: () => value.sendRegisterRequest(),
                                        style: ElevatedButton.styleFrom(foregroundColor: ThemeProvider.whiteColor, backgroundColor: ThemeProvider.appColor, elevation: 0),
                                        child: value.isLogin.value == true ? const CircularProgressIndicator(color: ThemeProvider.whiteColor) : Text('Register Now'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 16)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
