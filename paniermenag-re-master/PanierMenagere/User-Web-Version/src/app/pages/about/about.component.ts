/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Grocery Delivery App
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import { Component, OnInit } from '@angular/core';
import { ApiService } from 'src/app/services/api.service';
import { UtilService } from 'src/app/services/util.service';

@Component({
  selector: 'app-about',
  templateUrl: './about.component.html',
  styleUrls: ['./about.component.scss']
})
export class AboutComponent implements OnInit {
  content: any;
  loaded: boolean;
  constructor(
    public api: ApiService,
    public util: UtilService
  ) {
    this.loaded = false;
    this.getPageInfo();
  }

  getPageInfo() {
    const param = {
      id: 1
    };
    console.log('param', param);
    this.api.post_private('v1/pages/getContent', param).then((data: any) => {
      this.loaded = true;
      console.log(data);
      if (data && data.status && data.status === 200 && data.data) {
        this.content = data.data.content;
      }
    }, error => {
      console.log(error);
      this.util.apiErrorHandler(error);
      this.loaded = true;
    }).catch(error => {
      console.log(error);
      this.util.apiErrorHandler(error);
      this.loaded = true;
    });
  }

  ngOnInit(): void {
  }

}
