/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Grocery Delivery App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { DriverRequestRoutingModule } from './driver-request-routing.module';
import { DriverRequestComponent } from './driver-request.component';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';
import { FormsModule } from '@angular/forms';
import { NgxPaginationModule } from 'ngx-pagination';
import { NgxSpinnerModule } from 'ngx-spinner';
import { ModalModule } from 'ngx-bootstrap/modal';
import { CKEditorModule } from 'ng2-ckeditor';

@NgModule({
  declarations: [
    DriverRequestComponent
  ],
  imports: [
    CommonModule,
    DriverRequestRoutingModule,
    FormsModule,
    NgxSkeletonLoaderModule,
    NgxPaginationModule,
    ModalModule.forRoot(),
    NgxSpinnerModule,
    CKEditorModule
  ]
})
export class DriverRequestModule { }
