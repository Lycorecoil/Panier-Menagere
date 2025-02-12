/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Grocery Delivery App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { ApiService } from 'src/app/services/api.service';
import { UtilService } from 'src/app/services/util.service';
import * as firebase from 'firebase/auth';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent {
  email: any = '';
  password: any = '';

  phone: any = '';
  country_code: any = '';
  otp: any = '';

  otpSent: boolean = false;
  recaptchaVerifier: firebase.RecaptchaVerifier;

  otpId: any = '';

  languageId: any;

  submited: any = false;
  constructor(
    public api: ApiService,
    public util: UtilService,
    private router: Router
  ) {
    setTimeout(() => {
      this.country_code = this.util.default_country_code;
    }, 1000);

    setTimeout(() => {
      this.languageId = parseInt(localStorage.getItem('selectedLanguage') ?? 'en');
    }, 1000);
  }

  ngOnInit() {
    setTimeout(() => {
      this.recaptchaVerifier = new firebase.RecaptchaVerifier('sign-in-button', {
        size: 'invisible',
        callback: () => {

        },
        'expired-callback': () => {
        }
      }, firebase.getAuth());
    }, 5000);

  }

  loginWithPhonePassword() {
    this.submited = true;
    if (this.phone == null || this.password == null || this.phone === '' || this.password === '') {
      this.util.error(this.util.translate('All Fields are required'));
      return false;
    }
    console.log('ok');

    const param = {
      country_code: '+' + this.country_code,
      mobile: this.phone,
      password: this.password
    }
    this.util.show();
    this.api.post_public('v1/auth/loginWithPhonePassword', param).then((data: any) => {
      this.util.hide();
      console.log('data=>', data);
      this.util.hide();
      if (data && data.status && data.status == 200 && data.user && data.user.id) {
        if (data && data.user && data.user.type == 'store') {
          if (data.user.status == 1) {
            localStorage.setItem('uid', data.user.id);
            localStorage.setItem('token', data.token);
            this.util.userInfo = data.user;
            this.getUserByID();
            this.router.navigate(['']);
          } else {
            // blocked
            this.util.error(this.util.translate('Your account is blocked, please contact administrator'));
          }
        } else {
          this.util.error(this.util.translate('Not valid user'));
        }
      } else if (data && data.status == 401 && data.error.error) {
        this.util.error(data.error.error);
      } else {
        this.util.error(this.util.translate('Something went wrong'));
      }
    }, error => {
      this.util.hide();
      console.log('Error', error);
      this.util.apiErrorHandler(error);
    }).catch(error => {
      this.util.hide();
      console.log('Err', error);
      this.util.apiErrorHandler(error);
    });
  }

  onLogin() {
    this.submited = true;
    if (this.email == null || this.password == null || this.email === '' || this.password === '') {
      this.util.error(this.util.translate('All Fields are required'));
      return false;
    }
    const emailfilter = /^[\w._-]+[+]?[\w._-]+@[\w.-]+\.[a-zA-Z]{2,6}$/;
    if (!emailfilter.test(this.email)) {
      this.util.error(this.util.translate('Please enter valid email'));
      return false;
    }

    const param = {
      email: this.email,
      password: this.password
    }
    this.util.show();
    this.api.post_public('v1/auth/login', param).then((data: any) => {
      this.util.hide();
      console.log('data=>', data);
      this.util.hide();
      if (data && data.status && data.status == 200 && data.user && data.user.id) {
        if (data && data.user && data.user.type == 'store') {
          if (data.user.status == 1) {
            localStorage.setItem('uid', data.user.id);
            localStorage.setItem('token', data.token);
            this.util.userInfo = data.user;
            this.getUserByID();
            this.router.navigate(['']);
          } else {
            // blocked
            this.util.error(this.util.translate('Your account is blocked, please contact administrator'));
          }
        } else {
          this.util.error(this.util.translate('Not valid user'));
        }
      } else if (data && data.status == 401 && data.error.error) {
        this.util.error(data.error.error);
      } else {
        this.util.error(this.util.translate('Something went wrong'));
      }
    }, error => {
      this.util.hide();
      console.log('Error', error);
      this.util.apiErrorHandler(error);
    }).catch(error => {
      this.util.hide();
      console.log('Err', error);
      this.util.apiErrorHandler(error);
    });

  }

  loginWithPhoneOTP() {
    this.submited = true;
    if (this.phone == null || this.phone === '') {
      this.util.error(this.util.translate('Please enter phone'));
      return false;
    }
    if (this.util.smsGateway == '2') { // Firebase OTP ON PHONE
      console.log('firebase');
      const param = {
        country_code: '+' + this.country_code,
        mobile: this.phone,
      }
      this.util.show();
      this.api.post_public('v1/auth/verifyPhoneForFirebase', param).then((data: any) => {
        console.log(data);
        this.util.hide();
        if (data && data.status && data.status == 200 && data.data) {
          console.log('open firebase web version');
          this.util.show();
          this.api.signInWithPhoneNumber(this.recaptchaVerifier, '+' + this.country_code + this.phone).then(
            success => {
              this.util.hide();
              this.otpSent = true;
            }
          ).catch(error => {
            this.util.hide();
            console.log(error);
            this.util.error(error);
          });

        }
      }, error => {
        this.util.hide();
        this.util.apiErrorHandler(error);
      }).catch((error) => {
        this.util.hide();
        console.log(error);
        this.util.apiErrorHandler(error);
      });
    } else {
      this.util.show();
      const param = {
        country_code: '+' + this.country_code,
        mobile: this.phone,
      }
      this.api.post_public('v1/otp/verifyPhone', param).then((data: any) => {
        console.log(data);
        this.util.hide();
        if (data && data.status && data.status == 200 && data.data == true && data.otp_id) {
          this.otpId = data.otp_id;
          this.otpSent = true;
          // this.openVerificationModal(data.otp_id, param.country_code + param.mobile);
        } else if (data && data.status && data.status == 500 && data.data == false) {
          this.util.error(this.util.translate('Something went wrong'));
        }
      }, error => {
        this.util.hide();
        this.util.apiErrorHandler(error);
      }).catch((error) => {
        this.util.hide();
        console.log(error);
        this.util.apiErrorHandler(error);
      });
    }
    // this.otpSent = true;
    console.log('phone');
  }

  verifyOTP() {
    this.submited = true;
    if (this.otp == '' || !this.otp || this.otp == null) {
      this.util.error(this.util.translate('Please enter OTP'));
      return false;
    }

    if (this.util.smsGateway == '2') {
      this.util.show();
      this.api.enterVerificationCode(this.otp).then(
        userData => {
          this.util.hide();
          this.loginWithPhoneOTPVerified();
          console.log(userData);
        }
      ).catch(error => {
        this.util.error(error);
        console.log(error);
        this.util.hide();
      });
    } else {
      const param = {
        id: this.otpId,
        otp: this.otp
      };
      this.util.show();
      this.api.post_public('v1/otp/verifyOTP', param).then((data: any) => {
        console.log(data);
        this.util.hide();
        if (data && data.status && data.status === 200 && data.data) {
          this.loginWithPhoneOTPVerified();
        }
      }, error => {
        this.util.hide();
        console.log(error);
        if (error && error.status === 401 && error.error.error) {
          this.util.error(error.error.error);
          return false;
        }
        if (error && error.status === 500 && error.error.error) {
          this.util.error(error.error.error);
          return false;
        }
        this.util.hide();
        this.util.error(this.util.translate('Wrong OTP'));
      }).catch((error) => {
        this.util.hide();
        console.log(error);
        if (error && error.status === 401 && error.error.error) {
          this.util.error(error.error.error);
          return false;
        }
        if (error && error.status === 500 && error.error.error) {
          this.util.error(error.error.error);
          return false;
        }
        this.util.hide();
        this.util.error(this.util.translate('Wrong OTP'));
      });
    }
  }

  forgot() {
    console.log('item');
    this.router.navigate(['forgot']);
  }

  onOtpChange(event: any) {
    console.log(event);
    this.otp = event;
  }

  loginWithPhoneOTPVerified() {
    this.submited = true;
    console.log('login now .. it is verifieds');
    this.util.show();
    const param = {
      country_code: '+' + this.country_code,
      mobile: this.phone,
    }
    this.api.post_public('v1/auth/loginWithMobileOtp', param).then((data: any) => {
      this.util.hide();
      console.log('data=>', data);
      this.util.hide();
      if (data && data.status && data.status == 200 && data.user && data.user.id) {
        if (data && data.user && data.user.type == 'store') {
          if (data.user.status == 1) {
            localStorage.setItem('uid', data.user.id);
            localStorage.setItem('token', data.token);
            this.util.userInfo = data.user;
            this.getUserByID();
            this.router.navigate(['']);
          } else {
            // blocked
            this.util.error(this.util.translate('Your account is blocked, please contact administrator'));
          }
        } else {
          this.util.error(this.util.translate('Not valid user'));
        }
      } else if (data && data.status == 401 && data.error.error) {
        this.util.error(data.error.error);
      } else {
        this.util.error(this.util.translate('Something went wrong'));
      }
    }, error => {
      this.util.hide();
      console.log('Error', error);
      this.util.apiErrorHandler(error);
    }).catch(error => {
      this.util.hide();
      console.log('Err', error);
      this.util.apiErrorHandler(error);
    });
  }

  updateLanguage() {
    const selected = this.util.allLanguages.filter(x => x.code == this.languageId);
    localStorage.setItem('selectedLanguage', selected[0].code);
    localStorage.setItem('direction', selected[0].direction);
    window.location.reload();
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
