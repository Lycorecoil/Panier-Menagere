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
      this.util.app_status = settings.app_status == 1 ? true : false;
      this.util.app_color = settings.app_color;
      this.util.currecny = settings.currencySymbol;
      this.util.cside = settings.currencySide;
      localStorage.setItem('theme', 'primary');
    }

    const general = data && data.data && data.data.general ? data.data.general : null;
    if (general) {
      this.util.appName = general.name;
      this.util.general = general;
    }
  }
}
