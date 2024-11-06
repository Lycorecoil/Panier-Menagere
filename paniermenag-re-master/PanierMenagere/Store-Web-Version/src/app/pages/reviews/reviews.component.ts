/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Grocery Delivery App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import { Component, OnInit } from '@angular/core';
import * as moment from 'moment';
import { ApiService } from 'src/app/services/api.service';
import { UtilService } from 'src/app/services/util.service';

@Component({
  selector: 'app-reviews',
  templateUrl: './reviews.component.html',
  styleUrls: ['./reviews.component.scss']
})
export class ReviewsComponent implements OnInit {
  dummy: any[] = [];
  reviews: any[] = [];
  page: number = 1;
  constructor(
    public util: UtilService,
    public api: ApiService
  ) {
    this.getReviews();
  }

  ngOnInit(): void {
  }

  getReviews() {
    const param = {
      id: localStorage.getItem('uid'),
    };
    this.dummy = Array(10);
    this.api.post_private('v1/ratings/getWithStoreId', param).then((data: any) => {
      this.dummy = [];
      console.log(data);
      if (data && data.status && data.status === 200 && data.data) {
        this.reviews = data.data;
      }
    }, error => {
      console.log(error);
      this.dummy = [];
      this.util.apiErrorHandler(error);
    }).catch(error => {
      console.log(error);
      this.dummy = [];
      this.util.apiErrorHandler(error);
    });
  }

  getDate(date: any) {
    return moment(date).format('lll');
  }

}
