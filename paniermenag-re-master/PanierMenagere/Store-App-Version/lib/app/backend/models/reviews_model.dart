/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
class ReviewsModel {
  int? id;
  int? rate;
  String? timestamp;
  String? msg;
  String? way;
  String? firstName;
  String? lastName;
  String? cover;

  ReviewsModel({this.id, this.rate, this.timestamp, this.msg, this.way, this.firstName, this.lastName, this.cover});

  ReviewsModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    rate = int.parse(json['rate'].toString());
    timestamp = json['timestamp'];
    msg = json['msg'];
    way = json['way'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    cover = json['cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rate'] = rate;
    data['timestamp'] = timestamp;
    data['msg'] = msg;
    data['way'] = way;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['cover'] = cover;
    return data;
  }
}
