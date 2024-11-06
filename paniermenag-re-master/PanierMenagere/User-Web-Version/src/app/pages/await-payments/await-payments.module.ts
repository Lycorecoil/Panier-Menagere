/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Grocery Delivery App
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { AwaitPaymentsRoutingModule } from './await-payments-routing.module';
import { AwaitPaymentsComponent } from './await-payments.component';
import { MDBBootstrapModule } from 'angular-bootstrap-md';
import { NgxPayPalModule } from 'ngx-paypal';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { FormsModule } from '@angular/forms';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';

@NgModule({
  declarations: [
    AwaitPaymentsComponent
  ],
  imports: [
    CommonModule,
    AwaitPaymentsRoutingModule,
    MDBBootstrapModule.forRoot(),
    NgxPayPalModule,
    NgbModule,
    FormsModule,
    NgxSkeletonLoaderModule
  ]
})
export class AwaitPaymentsModule { }
