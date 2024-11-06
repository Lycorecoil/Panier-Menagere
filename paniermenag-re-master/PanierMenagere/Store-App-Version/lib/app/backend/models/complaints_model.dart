/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
class ComplaintsModel {
  int? id;
  int? uid;
  int? orderId;
  int? issueWith;
  String? driverId;
  int? storeId;
  int? productId;
  int? reasonId;
  String? title;
  String? shortMessage;
  String? images;
  String? extraField;
  int? status;

  ComplaintsModel({this.id, this.uid, this.orderId, this.issueWith, this.driverId, this.storeId, this.productId, this.reasonId, this.title, this.shortMessage, this.images, this.extraField, this.status});

  ComplaintsModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    uid = int.parse(json['uid'].toString());
    orderId = int.parse(json['order_id'].toString());
    issueWith = int.parse(json['issue_with'].toString());
    driverId = json['driver_id'];
    storeId = int.parse(json['store_id'].toString());
    productId = int.parse(json['product_id'].toString());
    reasonId = int.parse(json['reason_id'].toString());
    title = json['title'];
    shortMessage = json['short_message'];
    images = json['images'];
    extraField = json['extra_field'];
    status = int.parse(json['status'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['order_id'] = orderId;
    data['issue_with'] = issueWith;
    data['driver_id'] = driverId;
    data['store_id'] = storeId;
    data['product_id'] = productId;
    data['reason_id'] = reasonId;
    data['title'] = title;
    data['short_message'] = shortMessage;
    data['images'] = images;
    data['extra_field'] = extraField;
    data['status'] = status;
    return data;
  }
}
