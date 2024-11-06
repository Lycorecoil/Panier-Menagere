/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
class UserDetailsModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? countryCode;
  String? mobile;
  String? cover;
  String? lat;
  String? lng;
  String? fcmToken;
  String? others;
  String? extraField;
  int? status;
  double? distance;

  UserDetailsModel({this.id, this.firstName, this.lastName, this.email, this.countryCode, this.mobile, this.cover, this.lat, this.lng, this.fcmToken, this.others, this.extraField, this.status, this.distance});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    countryCode = json['country_code'];
    mobile = json['mobile'];
    cover = json['cover'];
    lat = json['lat'];
    lng = json['lng'];
    fcmToken = json['fcm_token'];
    others = json['others'];
    extraField = json['extra_field'];
    status = int.parse(json['status'].toString());
    if (json['distance'] != null && json['distance'] != '') {
      distance = double.parse(json['distance'].toString());
    } else {
      distance = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['country_code'] = countryCode;
    data['mobile'] = mobile;
    data['cover'] = cover;
    data['lat'] = lat;
    data['lng'] = lng;
    data['fcm_token'] = fcmToken;
    data['others'] = others;
    data['extra_field'] = extraField;
    data['status'] = status;
    data['distance'] = distance;
    return data;
  }
}
