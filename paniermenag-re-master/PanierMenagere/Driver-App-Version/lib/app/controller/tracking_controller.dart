/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'dart:async';

import 'package:driver/app/backend/models/google_maps_direction_response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:driver/app/backend/api/handler.dart';
import 'package:driver/app/backend/parse/tracking_parse.dart';
import 'package:driver/app/env.dart';
import 'package:driver/app/helper/pin_info.dart';
import 'package:driver/app/util/constant.dart';
import 'package:url_launcher/url_launcher.dart';

const double cameraZoom = 16;
const double cameraTilt = 0;
const double cameraBearing = 30;

class TrackingController extends GetxController implements GetxService {
  final TrackingParser parser;

  final Completer<GoogleMapController> googleMapsController = Completer();
  final Set<Marker> markers = <Marker>{};
  final Set<Polyline> polylines = <Polyline>{};
  List<LatLng> polylineCoordinates = [];
  // late PolylinePoints polylinePoints;
  String googleAPIKey = Environments.googleMapsKeys;
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  late LocationData currentLocation = LocationData.fromMap({"latitude": 21.530435, "longitude": 71.825037});
  late LocationData destinationLocation = LocationData.fromMap({"latitude": 21.536411, "longitude": 71.834638});
  late Location location;
  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(pinPath: '', avatarPath: '', location: const LatLng(0, 0), locationName: '', labelColor: Colors.grey);
  PinInformation sourcePinInfo = PinInformation(locationName: "Start Location", location: const LatLng(21.530435, 71.825037), pinPath: "assets/images/bike.png", avatarPath: "assets/images/bike.png", labelColor: Colors.blueAccent);
  PinInformation destinationPinInfo = PinInformation(locationName: "End Location", location: const LatLng(21.536411, 71.834638), pinPath: "assets/images/dest.png", avatarPath: "assets/images/dest.png", labelColor: Colors.purple);
  late CameraPosition initialCameraPosition;

  bool isLocationClosed = false;
  late StreamSubscription<LocationData> locationSubscription;
  String googleMapsType = '';
  double oppLat = 0.0;
  double oppLng = 0.0;

  String cover = '';
  String name = '';
  String mobile = '';
  String address = '';

  double amountCollect = 0.0;

  String paidMethod = '';

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  TrackingController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();

    googleMapsType = Get.arguments[0];
    oppLat = double.parse(Get.arguments[1]);
    oppLng = double.parse(Get.arguments[2]);
    cover = Get.arguments[3] ?? 'NA';
    name = Get.arguments[4] ?? 'NA';
    mobile = Get.arguments[5] ?? 'NA';
    address = Get.arguments[6] ?? 'NA';
    amountCollect = double.parse(Get.arguments[7]);
    paidMethod = Get.arguments[8] ?? 'NA';

    destinationLocation = LocationData.fromMap({"latitude": oppLat, "longitude": oppLng});

    var destPosition = LatLng(oppLat, oppLng);
    initialCameraPosition = CameraPosition(zoom: cameraZoom, tilt: cameraTilt, bearing: cameraBearing, target: destPosition);
    initialCameraPosition = CameraPosition(target: LatLng(currentLocation.latitude!, currentLocation.longitude!), zoom: cameraZoom, tilt: cameraTilt, bearing: cameraBearing);
    location = Location();
    // polylinePoints = PolylinePoints();
    locationSubscription = location.onLocationChanged.listen((LocationData cLoc) {
      currentLocation = cLoc;
      debugPrint(currentLocation.latitude.toString());
      debugPrint(currentLocation.longitude.toString());
      if (isLocationClosed == false) {
        updatePinOnMap();
      }
    });
    setSourceAndDestinationIcons();
    setInitialLocation();
  }

  void cancelLocationSubscription() {
    isLocationClosed = true;
    locationSubscription.cancel();
    update();
  }

  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(zoom: cameraZoom, tilt: cameraTilt, bearing: cameraBearing, target: LatLng(currentLocation.latitude!, currentLocation.longitude!));

    final GoogleMapController controller = await googleMapsController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    var pinPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);

    sourcePinInfo.location = pinPosition;

    markers.removeWhere((m) => m.markerId.value == 'sourcePin');
    markers.add(
      Marker(
        markerId: const MarkerId('sourcePin'),
        onTap: () {
          currentlySelectedPin = sourcePinInfo;
          pinPillPosition = 0;
          update();
        },
        position: pinPosition,
        icon: sourceIcon,
      ),
    );
    update();
  }

  void setSourceAndDestinationIcons() async {
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(100, 100)), 'assets/images/bike.png').then((onValue) {
      sourceIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(100, 100)), 'assets/images/dest.png').then((onValue) {
      destinationIcon = onValue;
    });
  }

  void setInitialLocation() async {
    currentLocation = await location.getLocation();
    destinationLocation = LocationData.fromMap({"latitude": destinationLocation.latitude, "longitude": destinationLocation.longitude});
  }

  void showPinsOnMap() {
    var pinPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
    var destPosition = LatLng(destinationLocation.latitude!, destinationLocation.longitude!);

    sourcePinInfo = PinInformation(locationName: "Start Location".tr, location: pinPosition, pinPath: "assets/images/bike.png", avatarPath: "assets/images/bike.png", labelColor: Colors.blueAccent);

    destinationPinInfo = PinInformation(locationName: "End Location".tr, location: destPosition, pinPath: "assets/images/dest.png", avatarPath: "assets/images/dest.png", labelColor: Colors.purple);

    markers.add(
      Marker(
        markerId: const MarkerId('sourcePin'),
        position: pinPosition,
        onTap: () {
          currentlySelectedPin = sourcePinInfo;
          pinPillPosition = 0;
          update();
        },
        icon: sourceIcon,
      ),
    );
    markers.add(
      Marker(
        markerId: const MarkerId('destPin'),
        position: destPosition,
        onTap: () {
          currentlySelectedPin = destinationPinInfo;
          pinPillPosition = 0;
          update();
        },
        icon: destinationIcon,
      ),
    );
    setPolylines();
  }

  void setPolylines() async {
    debugPrint('***********************************');
    debugPrint('***********************************');
    Response response = await parser.getGoogleDirection(currentLocation.latitude!, currentLocation.longitude!, destinationLocation.latitude!, destinationLocation.longitude!);
    if (response.statusCode == 200) {
      debugPrint('OKOKOKOKOKOKOKOKOKOKOKOKOKOKOK');
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      GoogleDirectionResponseModel directionResponse = GoogleDirectionResponseModel.fromJson(myMap);
      if (directionResponse.routes!.isNotEmpty && directionResponse.routes![0].overviewPolyline!.points!.isNotEmpty) {
        debugPrint(';;;;;;;;;;;;;;;;;;;;;;;;;');
        final String routeLine = directionResponse.routes![0].overviewPolyline!.points!;
        debugPrint('Route --> $routeLine');
        polylines.add(Polyline(polylineId: const PolylineId('direction'), width: 10, points: convertToLatLng(decodePoly(routeLine)), color: Colors.red));
        update();
      }
    }
    debugPrint('***********************************');
    debugPrint('***********************************');
  }

  List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List decodePoly(String poly) {
    var list = poly.codeUnits;
    List<double> lList = <double>[];
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);
    for (var i = 2; i < lList.length; i++) {
      lList[i] += lList[i - 2];
    }
    return lList;
  }

  void openActionModalStore() {
    var context = Get.context as BuildContext;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('${'Contact'.tr} $name'),
        actions: [
          CupertinoActionSheetAction(
            child: Text('Call'.tr),
            onPressed: () {
              Navigator.pop(context);
              makePhoneCall();
            },
          ),
          CupertinoActionSheetAction(child: Text('Cancel'.tr, style: const TextStyle(fontFamily: 'bold', color: Colors.red)), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Future<void> makePhoneCall() async {
    final Uri launchUri = Uri(scheme: 'tel', path: mobile);
    await launchUrl(launchUri);
  }

  Future<void> updateDriverInfo() async {
    var param = {'id': parser.getUID(), 'lat': currentLocation.latitude, 'lng': currentLocation.longitude};
    Response response = await parser.updateDriver(param);
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      debugPrint(body.toString());
    } else {
      ApiChecker.checkApi(response);
    }
  }
}
