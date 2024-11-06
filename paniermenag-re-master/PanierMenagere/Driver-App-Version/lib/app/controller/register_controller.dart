/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:driver/app/backend/api/handler.dart';
import 'package:driver/app/backend/models/city_mode.dart';
import 'package:driver/app/backend/parse/register_parse.dart';
import 'package:driver/app/env.dart';
import 'package:driver/app/helper/router.dart';
import 'package:driver/app/util/constant.dart';
import 'package:driver/app/util/theme.dart';
import 'package:driver/app/util/toast.dart';
import 'package:image_picker/image_picker.dart';

class RegisterController extends GetxController implements GetxService {
  final RegisterParser parser;

  RxBool isLogin = false.obs;
  final phoneRegister = TextEditingController();
  final emailRegister = TextEditingController();
  final firstNameRegsiter = TextEditingController();
  final lastNameRegister = TextEditingController();
  final passwordRegister = TextEditingController();
  final confirmPasswordRegister = TextEditingController();
  final driverAddress = TextEditingController();

  String countryCode = '+91';
  RxBool passwordVisible = false.obs;

  String smsName = AppConstants.defaultSMSGateway;
  int smsId = 1;
  String otpCode = '';

  String gender = 'Male';

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  String driverCover = '';

  List<CityModel> _list = <CityModel>[];
  List<CityModel> get list => _list;

  XFile? _selectedImage;
  String savedCity = '';
  String savedCityName = '';
  double lat = 0.0;
  double lng = 0.0;
  RegisterController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    smsName = parser.getSMSName();
    getActiveCities();
    getLocation();
  }

  void getLocation() async {
    _determinePosition().then((value) async {
      lat = value.latitude;
      lng = value.longitude;
      update();
    }).catchError((error) async {
      showToast(error.toString());
      await Geolocator.openLocationSettings();
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.'.tr);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied'.tr);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.'.tr);
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getActiveCities() async {
    Response response = await parser.getActiveCities();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _list = [];
      body.forEach((data) {
        CityModel datas = CityModel.fromJson(data);
        _list.add(datas);
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void updateActiveIndex(int index) {
    currentIndex = index;
    update();
  }

  void verifiedFirebaseCode() {
    successToast('Contact Number Verified');
    carouselController.nextPage();
  }

  void updateCountryCode(String code) {
    countryCode = code;
    update();
  }

  Future<void> loginWithPhoneOTP() async {
    if (phoneRegister.text == '') {
      showToast('Phone Number is required');
      return;
    }

    if (smsName == '2') {
      isLogin.value = !isLogin.value;
      update();

      var param = {'country_code': countryCode, 'mobile': phoneRegister.text};
      Response response = await parser.verifyPhoneWithFirebase(param);
      if (response.statusCode == 200) {
        isLogin.value = !isLogin.value;
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        if (myMap['data'] != '' && myMap['data'] == true) {
          FocusManager.instance.primaryFocus?.unfocus();
          Get.toNamed(AppRouter.getFirebaseRegisterRoute(), arguments: [countryCode, phoneRegister.text]);
        } else {
          showToast('Something went wrong');
        }
        update();
      } else if (response.statusCode == 401) {
        isLogin.value = !isLogin.value;
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        if (myMap['error'] != '') {
          showToast(myMap['error']);
        } else {
          showToast('Something went wrong');
        }
        update();
      } else if (response.statusCode == 500) {
        isLogin.value = !isLogin.value;
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        if (myMap['error'] != '') {
          showToast(myMap['error']);
        } else {
          showToast('Something went wrong');
        }
        update();
      } else {
        isLogin.value = !isLogin.value;
        ApiChecker.checkApi(response);
        update();
      }
      update();
    } else {
      isLogin.value = !isLogin.value;
      update();

      var param = {'country_code': countryCode, 'mobile': phoneRegister.text};
      Response response = await parser.verifyPhone(param);
      if (response.statusCode == 200) {
        isLogin.value = !isLogin.value;
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        if (myMap['data'] != '' && myMap['data'] == true) {
          smsId = myMap['otp_id'];
          FocusManager.instance.primaryFocus?.unfocus();
          onOpenPage();
        } else {
          showToast('Something went wrong');
        }
        update();
      } else if (response.statusCode == 401) {
        isLogin.value = !isLogin.value;
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        if (myMap['error'] != '') {
          showToast(myMap['error']);
        } else {
          showToast('Something went wrong');
        }
        update();
      } else if (response.statusCode == 500) {
        isLogin.value = !isLogin.value;
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        if (myMap['error'] != '') {
          showToast(myMap['error']);
        } else {
          showToast('Something went wrong');
        }
        update();
      } else {
        isLogin.value = !isLogin.value;
        ApiChecker.checkApi(response);
        update();
      }
      update();
    }
  }

  void onOpenPage() {
    var context = Get.context as BuildContext;
    openOTPModal(context, countryCode.toString() + phoneRegister.text.toString());
  }

  void openOTPModal(context, String text) {
    showDialog(
      context: context,
      barrierColor: ThemeProvider.appColor,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0.0),
          title: Text("Verification".tr, textAlign: TextAlign.center),
          content: AbsorbPointer(
            absorbing: isLogin.value == false ? false : true,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  children: [
                    Text('We have sent verification code on'.tr, style: const TextStyle(fontSize: 12, fontFamily: 'medium')),
                    Text(text, style: const TextStyle(fontSize: 12, fontFamily: 'medium')),
                    const SizedBox(height: 10),
                    OtpTextField(
                      numberOfFields: 6,
                      borderColor: ThemeProvider.greyColor,
                      keyboardType: TextInputType.number,
                      focusedBorderColor: ThemeProvider.appColor,
                      showFieldAsBox: true,
                      onCodeChanged: (String code) {},
                      onSubmit: (String verificationCode) {
                        otpCode = verificationCode;
                        onOtpSubmit(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            AbsorbPointer(
              absorbing: isLogin.value == false ? false : true,
              child: Container(
                height: 45,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: Colors.white),
                child: ElevatedButton(
                  onPressed: () async {
                    if (otpCode != '' && otpCode.length >= 6) {
                      onOtpSubmit(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(foregroundColor: ThemeProvider.whiteColor, backgroundColor: ThemeProvider.appColor, elevation: 0),
                  child: isLogin.value == true ? const CircularProgressIndicator(color: ThemeProvider.whiteColor) : Text('Verify'.tr, style: const TextStyle(fontFamily: 'regular', fontSize: 16)),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> onOtpSubmit(context) async {
    isLogin.value = !isLogin.value;
    update();
    var param = {'id': smsId, 'otp': otpCode};
    Response response = await parser.verifyOTP(param);
    if (response.statusCode == 200) {
      isLogin.value = !isLogin.value;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['data'] != '' && myMap['success'] == true) {
        Navigator.of(context).pop(true);
        if (currentIndex == 0) {
          successToast('Contact Number Verified');
        } else {
          successToast('Email Verified');
        }
        carouselController.nextPage();
      } else {
        showToast('Something went wrong');
      }
      update();
    } else if (response.statusCode == 401) {
      isLogin.value = !isLogin.value;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['error'] != '') {
        showToast(myMap['error']);
      } else {
        showToast('Something went wrong');
      }
      update();
    } else if (response.statusCode == 500) {
      isLogin.value = !isLogin.value;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['error'] != '') {
        showToast(myMap['error']);
      } else {
        showToast('Something went wrong');
      }
      update();
    } else {
      isLogin.value = !isLogin.value;
      ApiChecker.checkApi(response);
      update();
    }
  }

  Future<void> loginWithEmail() async {
    if (emailRegister.text == '') {
      showToast('E-mail is required');
      return;
    }
    if (!GetUtils.isEmail(emailRegister.text)) {
      showToast('Email is not valid');
      return;
    }
    isLogin.value = !isLogin.value;
    update();

    var param = {'email': emailRegister.text, 'subject': 'Verification'};
    Response response = await parser.verifyEmailForRegister(param);
    if (response.statusCode == 200) {
      isLogin.value = !isLogin.value;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['data'] != '' && myMap['data'] == true) {
        smsId = myMap['otp_id'];
        FocusManager.instance.primaryFocus?.unfocus();
        onEmailOpen();
      } else {
        showToast('Something went wrong');
      }
      update();
    } else if (response.statusCode == 401) {
      isLogin.value = !isLogin.value;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['error'] != '') {
        showToast(myMap['error']);
      } else {
        showToast('Something went wrong');
      }
      update();
    } else if (response.statusCode == 500) {
      isLogin.value = !isLogin.value;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['error'] != '') {
        showToast(myMap['error']);
      } else {
        showToast('Something went wrong');
      }
      update();
    } else {
      isLogin.value = !isLogin.value;
      ApiChecker.checkApi(response);
      update();
    }
    update();
  }

  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
    update();
  }

  void onEmailOpen() {
    var context = Get.context as BuildContext;
    openOTPModal(context, emailRegister.text.toString());
  }

  Future<void> onCityModal() async {
    var context = Get.context as BuildContext;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Text('Choose City'.tr, style: const TextStyle(fontSize: 14, fontFamily: 'bold'), textAlign: TextAlign.center),
          content: Column(
            children: [
              SizedBox(
                height: 200.0, // Change as per your requirement
                width: 300.0, // Change as per your requirement
                child: Scrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      Color getColor(Set<WidgetState> states) {
                        return ThemeProvider.appColor;
                      }

                      return ListTile(
                        textColor: ThemeProvider.appColor,
                        iconColor: ThemeProvider.appColor,
                        title: Text(list[index].name.toString()),
                        leading: Radio(
                          fillColor: WidgetStateProperty.resolveWith(getColor),
                          value: list[index].id.toString(),
                          groupValue: savedCity,
                          onChanged: (e) {
                            savedCity = e.toString();
                            var selected = list.firstWhere((element) => element.id.toString() == savedCity).name;
                            savedCityName = selected!;
                            update();
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> onSaveInfo() async {
    if (firstNameRegsiter.text == '' || lastNameRegister.text == '' || passwordRegister.text == '' || confirmPasswordRegister.text == '') {
      showToast('All fields are required');
      return;
    }

    if (passwordRegister.text != confirmPasswordRegister.text) {
      showToast('Password mismatch');
      return;
    }
    carouselController.nextPage();
  }

  void onBackPage() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop();
  }

  void changeGender(String name) {
    gender = name;
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
            driverCover = body['image_name'];
            update();
          }
        }
      } else {
        ApiChecker.checkApi(response);
      }
    }
  }

  Future<void> sendRegisterRequest() async {
    if (driverAddress.text == '' || savedCity == '' || driverCover == '') {
      showToast('All fields are required');
      return;
    }
    var param = {
      'email': emailRegister.text,
      'first_name': firstNameRegsiter.text,
      'last_name': lastNameRegister.text,
      'mobile': phoneRegister.text,
      'cover': driverCover,
      'country_code': countryCode,
      'password': passwordRegister.text,
      'lat': lat,
      'lng': lng,
      'address': driverAddress.text,
      'cid': savedCity,
      'gender': gender == 'Male' ? 1 : 0
    };

    isLogin.value = !isLogin.value;
    update();

    Response response = await parser.registerStoreRequest(param);
    if (response.statusCode == 200) {
      isLogin.value = !isLogin.value;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['data'] != '' && myMap['data']['id'] != '') {
        var successParam = {'email': emailRegister.text, 'subject': 'Thanks for your interest in the ${Environments.appName}'};
        await parser.thankyouMail(successParam);
        onBackPage();
        successToast('Your Register Request Sent');
      } else {
        showToast('Something went wrong');
      }
      update();
    } else if (response.statusCode == 401) {
      isLogin.value = !isLogin.value;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['error'] != '') {
        showToast(myMap['error']);
      } else {
        showToast('Something went wrong');
      }
      update();
    } else if (response.statusCode == 500) {
      isLogin.value = !isLogin.value;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      if (myMap['error'] != '') {
        showToast(myMap['error']);
      } else {
        showToast('Something went wrong');
      }
      update();
    } else {
      isLogin.value = !isLogin.value;
      ApiChecker.checkApi(response);
      update();
    }
    update();
  }
}
