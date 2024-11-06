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

import { ManageStoreRoutingModule } from './manage-store-routing.module';
import { ManageStoreComponent } from './manage-store.component';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';
import { NgxSpinnerModule } from 'ngx-spinner';
import { FormsModule } from '@angular/forms';
import { CollapseModule } from 'ngx-bootstrap/collapse';
import { TabsModule } from 'ngx-bootstrap/tabs';
import { NgxPaginationModule } from 'ngx-pagination';

@NgModule({
  declarations: [
    ManageStoreComponent
  ],
  imports: [
    CommonModule,
    ManageStoreRoutingModule,
    NgxSkeletonLoaderModule,
    NgxSpinnerModule,
    FormsModule,
    CollapseModule.forRoot(),
    TabsModule,
    NgxPaginationModule
  ]
})
export class ManageStoreModule { }
