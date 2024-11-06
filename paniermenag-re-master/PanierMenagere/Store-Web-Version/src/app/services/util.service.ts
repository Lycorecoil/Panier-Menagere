/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Grocery Delivery App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { NgxSpinnerService } from 'ngx-spinner';
import { Subject } from 'rxjs';
import Swal from 'sweetalert2';
import { TranslateService } from '@ngx-translate/core';
import { INavData } from '@coreui/angular';
@Injectable({
  providedIn: 'root'
})
export class UtilService {
  // public translations: any[] = [];
  public default_country_code: any = '';
  public user_verification: any = 0;
  public themeColor = [
    { name: 'Default', class: 'default' },
    { name: 'Dark', class: 'dark-theme' },
  ];
  public findType: any = 0;
  public userInfo: any;
  public general: any;
  public cside: any = 'left';
  public currecny: any = '$';
  public appName: any;
  public appLogo: any;
  public direction: any;
  public show_booking: boolean = true;
  public app_color: any;
  public app_status: boolean = true;
  public app_closed_message: any = '';
  public settingInfo: any;
  public adminInfo: any;
  public isWebOrPWA: boolean = false;
  public diningInformations: any;
  public appClosedMessage: any = '';
  public driver_assign: any = '';
  public store: any;
  orderStatus = [
    'Created',
    'Accepted',
    'Prepared',
    'Ongoing',
    'Delivered',
    'Pending Payments',
    'Cancelled',
    'Refunded',
    'Rejected'
  ];
  paidMethods = [
    'Index',
    'COD',
    'STRIPE',
    'PAYPAL',
    'PAYTM',
    'RAZORPAY',
    'INSTAMOJO',
    'PAYSTACK',
    'FLUTTERWAVE',
    'PAYKUN'
  ];
  public allLanguages: any[] = [
    {
      name: 'English',
      code: 'en',
      direction: 'ltr'
    },
    {
      name: 'Español',
      code: 'es',
      direction: 'ltr'
    },
    {
      name: 'عربي',
      code: 'ar',
      direction: 'rtl'
    },
    {
      name: 'हिन्दी',
      code: 'hi',
      direction: 'ltr'
    }
  ];
  private ejectMessages = new Subject<any>();
  public loggedIN: boolean = false;
  public home_style: any = 1;
  public countrys: any[] = [];
  public smsGateway: any = '0';
  public login_style: any = 3;
  public user_login_with: any = 0;
  public register_style: any = 3;
  public servingCities: any[] = [];
  public cityName: any = '';
  public cityId: any = '';
  public zipcode: any = '';
  public deliveryAddress: any = '';
  public active_store: any[] = [];

  public makeOrders: any = 0;
  public reset_pwd: any = 0;
  public appPage: any[] = [];
  public haveFav: boolean;

  public navItems: INavData[] = [
    {
      name: 'Dashboard',
      url: '/dashboard',
      iconComponent: { name: 'cil-speedometer' }
    },
    {
      name: 'Analytics',
      url: '/analytics',
      iconComponent: { name: 'cil-chart-line' }
    },
    {
      name: 'Products',
      url: '/products',
      iconComponent: { name: 'cil-burger' }
    },
    {
      name: 'Reviews',
      url: '/reviews',
      iconComponent: { name: 'cil-star' }
    },
    {
      name: 'Support',
      url: '/support',
      iconComponent: { name: 'cil-chat-bubble' }
    },
    {
      name: 'Stats',
      url: '/stats',
      iconComponent: { name: 'cil-bar-chart' }
    }
  ];
  constructor(
    private spinner: NgxSpinnerService,
    private router: Router,
    private translateService: TranslateService
  ) { }

  error(message: any) {
    Swal.fire({
      icon: 'error',
      title: message,
      toast: true,
      showConfirmButton: false,
      timer: 2000,
      position: 'bottom-right'
    });
  }

  show() {
    this.spinner.show();
  }

  hide() {
    this.spinner.hide();
  }

  translate(str: any) {
    return this.translateService.instant(str);
  }

  success(message: any) {
    Swal.fire({
      icon: 'success',
      title: message,
      showConfirmButton: false,
      timer: 1500
    });
  }

  apiErrorHandler(err: any) {
    if (err && err.status === 401 && err.error.error) {
      this.error(err.error.error);
      this.router.navigateByUrl('/login');
      return false;
    }
    if (err && err.status === 500 && err.error.error) {
      this.error(err.error.error);
      return false;
    }
    if (err.status === -1) {
      this.error(this.translate('Failed To Connect With Server'));
    } else if (err.status === 401) {
      this.error(this.translate('Unauthorized Request!'));
      this.router.navigateByUrl('/login');
    } else if (err.status === 500) {
      if (err.status == 500 && err.error && err.error.message) {
        this.error(err.error.message);
        return false;
      }
      this.error(this.translate('Somethimg Went Wrong'));
    } else if (err.status === 422 && err.error.error) {
      this.error(err.error.error);
    } else {
      this.error(this.translate('Something went wrong'));
    }

  }

  ejectMsg() {
    this.ejectMessages.next(0);
  }

  successEject(): Subject<any> {
    return this.ejectMessages;
  }
}
