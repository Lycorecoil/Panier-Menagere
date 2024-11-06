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
import 'package:vendors/app/backend/models/stores_model.dart';
import 'package:vendors/app/backend/parse/edit_profile_parse.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendors/app/util/theme.dart';
import 'package:vendors/app/util/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class EditProfileController extends GetxController implements GetxService {
  final EditProfileParser parser;

  final storeName = TextEditingController();
  final storeAddress = TextEditingController();
  final storeLat = TextEditingController();
  final storeLng = TextEditingController();
  final storZipCode = TextEditingController();
  final description = TextEditingController();

  RxBool isLogin = false.obs;

  XFile? _selectedImage;

  String openTime = '';
  String closeTime = '';

  String storeCover = '';

  StoresModel _details = StoresModel();
  StoresModel get details => _details;

  int id = 0;
  EditProfileController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    id = parser.getStoreId();
    getDetails();
  }

  Future<void> getDetails() async {
    Response response = await parser.getStoreInfo();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic storeInfo = myMap["data"];
      _details = StoresModel();
      StoresModel orderInfoData = StoresModel.fromJson(storeInfo);
      _details = orderInfoData;
      storeName.text = details.name.toString();
      storeAddress.text = details.address.toString();
      storeLat.text = details.lat.toString();
      storeLng.text = details.lng.toString();
      storZipCode.text = details.zipcode.toString();
      description.text = details.descriptions.toString();
      storeCover = details.cover.toString();
      if (details.openTime != '') {
        var time = details.openTime!.split(':');
        if (time.isNotEmpty) {
          debugPrint('--------- 2020/01/01 ${num.parse(time[0]).toInt()}:${num.parse(time[1]).toInt()}:00');
          openTime = Jiffy.parseFromMap({Unit.year: 2024, Unit.month: 06, Unit.day: 14, Unit.hour: num.parse(time[0]).toInt(), Unit.minute: num.parse(time[1]).toInt()}).format(pattern: 'H:mm').toString();
        }
      }

      if (details.closeTime != '') {
        var time = details.closeTime!.split(':');
        if (time.isNotEmpty) {
          closeTime = Jiffy.parseFromMap({Unit.year: 2024, Unit.month: 06, Unit.day: 14, Unit.hour: num.parse(time[0]).toInt(), Unit.minute: num.parse(time[1]).toInt()}).format(pattern: 'H:mm').toString();
        }
      }

      update();
    } else {
      ApiChecker.checkApi(response);
    }
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
            storeCover = body['image_name'];
            var param = {'cover': body['image_name'], 'id': id};
            Response response = await parser.updateStoreData(param);
            if (response.statusCode == 200) {
              updateStoreInfo();
            } else {
              ApiChecker.checkApi(response);
            }
            update();
          }
        }
      } else {
        ApiChecker.checkApi(response);
      }
    }
  }

  void updateStoreInfo() {
    parser.saveStoreInfo(storeName.text, storeCover, storeAddress.text, storZipCode.text);
  }

  Future<void> openTimePicker() async {
    var context = Get.context as BuildContext;
    TimeOfDay initialTime = TimeOfDay.now();
    TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: initialTime, initialEntryMode: TimePickerEntryMode.input);
    openTime = Jiffy.parseFromMap({Unit.year: 2024, Unit.month: 06, Unit.day: 14, Unit.hour: pickedTime!.hour, Unit.minute: pickedTime.minute}).format(pattern: 'H:mm').toString();
    update();
  }

  Future<void> closeTimePicker() async {
    var context = Get.context as BuildContext;
    TimeOfDay initialTime = TimeOfDay.now();
    TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: initialTime, initialEntryMode: TimePickerEntryMode.input);
    closeTime = Jiffy.parseFromMap({Unit.year: 2024, Unit.month: 06, Unit.day: 14, Unit.hour: pickedTime!.hour, Unit.minute: pickedTime.minute}).format(pattern: 'H:mm').toString();
    update();
  }

  void onBackPage() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop();
  }

  void openLink() async {
    var url = Uri.parse('https://www.mapcoordinates.net/en');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> saveData() async {
    if (storeName.text == '' || storeAddress.text == '' || storeLat.text == '' || storeLng.text == '' || storZipCode.text == '' || description.text == '' || openTime == '' || closeTime == '') {
      showToast('All fields are required');
      return;
    }

    if (storeCover == '') {
      showToast('Cover image required');
      return;
    }

    var param = {'name': storeName.text, 'address': storeAddress.text, 'descriptions': description.text, 'lat': storeLat.text, 'lng': storeLng.text, 'cover': storeCover, 'open_time': openTime, 'close_time': closeTime, 'id': id};
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
    Response response = await parser.updateStoreData(param);
    Get.back();
    if (response.statusCode == 200) {
      successToast('Updated');
      updateStoreInfo();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }
}
