/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Grocery Delivery App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import { Component, OnInit } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';

import { IconSetService } from '@coreui/icons-angular';
import { brandSet, flagSet, freeSet } from '@coreui/icons';
import { Title } from '@angular/platform-browser';
import { ApiService } from './services/api.service';
import { UtilService } from './services/util.service';
import { TranslateService } from '@ngx-translate/core';
@Component({
  // tslint:disable-next-line:component-selector
  selector: 'body',
  template: '<router-outlet></router-outlet>',
})
export class AppComponent implements OnInit {
  title = 'Ultimate Grocery Flutter Admin Panel';

  constructor(
    private router: Router,
    private titleService: Title,
    private iconSetService: IconSetService,
    private api: ApiService,
    public util: UtilService,
    private translate: TranslateService,
  ) {
    titleService.setTitle(this.title);

    // iconSet singleton
    iconSetService.icons = { ...brandSet, ...flagSet, ...freeSet };

    const lng = localStorage.getItem('selectedLanguage');
    if (!lng || lng == null) {
      localStorage.setItem('selectedLanguage', 'en');
      localStorage.setItem('direction', 'ltr');
    }

    this.translate.use(localStorage.getItem('selectedLanguage') || 'en');
    const direaction = localStorage.getItem('direction') as string;
    document.documentElement.dir = direaction;

    this.api.get_public('v1/settings/getDefaultWeb').then((data: any) => {
      console.log('by default', data);
      if (data && data.status && data.status == 200) {
        this.saveSettings(data);

      }
    }, error => {
      console.log(error);
      this.util.apiErrorHandler(error);
    }).catch(error => {
      console.log(error);
      this.util.apiErrorHandler(error);
    });

    if (localStorage.getItem('uid') != null && localStorage.getItem('uid') && localStorage.getItem('uid') !== '' && localStorage.getItem('uid') !== 'null') {
      this.getUserByID();
    }
  }

  ngOnInit(): void {
    this.router.events.subscribe((evt) => {
      if (!(evt instanceof NavigationEnd)) {
        return;
      }
    });
  }

  saveSettings(data: any) {
    const settings = data && data.data && data.data.settings ? data.data.settings : null;
    if (settings) {
      this.util.appLogo = settings.logo;
      this.util.direction = settings.appDirection;
      this.util.app_status = settings.app_status === 1 ? true : false;
      this.util.app_color = settings.app_color;
      this.util.findType = settings.findType;
      this.util.login_style = settings.login_style;
      this.util.register_style = settings.register_style;
      this.util.currecny = settings.currencySymbol;
      this.util.cside = settings.currencySide;
      this.util.makeOrders = settings.makeOrders;
      this.util.smsGateway = settings.sms_name;
      this.util.user_login_with = settings.store_login;
      this.util.user_verification = settings.user_verify_with;
      this.util.reset_pwd = settings.reset_pwd;
      this.util.driver_assign = settings.driver_assign;

      localStorage.setItem('theme', 'primary');
      if (((x) => { try { JSON.parse(x); return true; } catch (e) { return false } })(settings.country_modal)) {
        this.util.countrys = JSON.parse(settings.country_modal);
      }
      this.util.default_country_code = settings && settings.default_country_code ? settings.default_country_code : '91';
    }

    const general = data && data.data && data.data.general ? data.data.general : null;
    if (general) {
      this.util.appName = general.name;
      this.util.general = general;
    }

    const served = data && data.data && data.data.we_served ? data.data.we_served : null;
    if (served) {
      this.util.servingCities = served;
    }

    const adminInfo = data && data.data && data.data.support ? data.data.support : null;
    if (adminInfo) {
      this.util.adminInfo = adminInfo;
    }
    console.log(this.util);
  }

  getUserByID() {
    const body = {
      id: localStorage.getItem('uid')
    }
    this.api.post_private('v1/profile/getStoreFromId', body).then((data: any) => {
      console.log(">>>>><<<<<", data);
      if (data && data.success && data.status === 200) {
        this.util.userInfo = data.data;
        this.util.store = data.store;

      } else {
        localStorage.removeItem('uid');
        localStorage.removeItem('token');
      }
    }, err => {
      localStorage.removeItem('uid');
      localStorage.removeItem('token');
      this.util.userInfo = null;
      console.log(err);
    }).catch((err) => {
      localStorage.removeItem('uid');
      localStorage.removeItem('token');
      this.util.userInfo = null;
      console.log(err);
    });
  }
}
