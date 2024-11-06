/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:vendors/app/backend/api/handler.dart';
import 'package:vendors/app/backend/models/reviews_model.dart';
import 'package:vendors/app/backend/parse/reviews_parse.dart';

class ReviewsController extends GetxController implements GetxService {
  final ReviewsParser parser;
  bool apiCalled = false;
  List<ReviewsModel> _reviewsList = <ReviewsModel>[];
  List<ReviewsModel> get reviewsList => _reviewsList;
  ReviewsController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    getReviews();
  }

  Future<void> getReviews() async {
    Response response = await parser.getReviews();
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      dynamic body = myMap["data"];
      _reviewsList = [];
      body.forEach((data) {
        ReviewsModel datas = ReviewsModel.fromJson(data);
        datas.timestamp = datas.timestamp != '' && datas.timestamp != null ? datas.timestamp : '2022-05-31';
        datas.timestamp = Jiffy.parse(datas.timestamp.toString()).fromNow();
        _reviewsList.add(datas);
      });
      update();
    } else {
      ApiChecker.checkApi(response);
      update();
    }
    update();
  }
}
