/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Grocery Delivery App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import { Component, OnInit } from '@angular/core';
import { NavigationExtras, Router } from '@angular/router';
import { orderBy } from 'lodash';
import { ApiService } from 'src/app/services/api.service';
import { UtilService } from 'src/app/services/util.service';
import Swal from 'sweetalert2';
@Component({
  selector: 'app-products',
  templateUrl: './products.component.html',
  styleUrls: ['./products.component.scss']
})
export class ProductsComponent implements OnInit {
  products: any[] = [];
  dummy = Array(20);
  dummyProducts: any[] = [];

  page: number = 1;
  constructor(
    private router: Router,
    public api: ApiService,
    public util: UtilService
  ) {
    this.getProducts();

  }

  ngOnInit() {
  }

  getProducts() {
    const param = {
      id: localStorage.getItem('uid'),
      limit: 5000,
    };
    this.api.post_private('v1/products/getByStoreIdStoreAll', param).then((data: any) => {
      console.log(data);
      this.dummy = [];
      if (data && data.status === 200) {
        this.products = data.data;
        this.dummyProducts = data.data;
        this.products = orderBy(this.products, ['id'], ['desc']);
      }
    }, error => {
      console.log(error);
      this.util.apiErrorHandler(error);
      this.dummy = [];
    }).catch(error => {
      console.log(error);
      this.util.apiErrorHandler(error);
      this.dummy = [];
    });
  }

  onSearchChange(event: any) {
    console.log(event);
    this.products = this.dummyProducts.filter((ele: any) => {
      return ele.name.toLowerCase().includes(event.toLowerCase());
    });
  }

  viewProduct(item: any) {
    const param: NavigationExtras = {
      queryParams: {
        id: item.id
      }
    };
    this.router.navigate(['products-details'], param);
  }

  createNew() {
    console.log('createnew');
    this.router.navigate(['products-details']);
  }

  sortByName() {
    this.products = orderBy(this.products, ['name'], ['asc']);
  }

  sortByRating() {
    this.products = orderBy(this.products, ['rating'], ['desc']);
  }

  updateStock(item: any) {
    console.log(item);
    Swal.fire({
      title: this.util.translate('Are you sure?'),
      text: this.util.translate('To update this item?'),
      icon: 'question',
      showConfirmButton: true,
      confirmButtonText: this.util.translate('Yes'),
      showCancelButton: true,
      cancelButtonText: this.util.translate('Cancel'),
      backdrop: false,
      background: 'white'
    }).then((data) => {
      if (data && data.value) {
        console.log('update it');
        const body = {
          id: item.id,
          in_stoke: item.in_stoke === 0 ? 1 : 0
        };
        console.log("===========", body);
        this.util.show();
        this.api.post_private('v1/products/updateProducts', body).then((data: any) => {
          this.util.hide();
          console.log("+++++++++++++++", data);
          if (data && data.status && data.status === 200 && data.success) {
            this.util.success(this.util.translate('Status Updated !'));
            this.getProducts();
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
    });
  }

  updateStatus(item: any) {
    console.log(item);
    Swal.fire({
      title: this.util.translate('Are you sure?'),
      text: this.util.translate('To update this item?'),
      icon: 'question',
      showConfirmButton: true,
      confirmButtonText: this.util.translate('Yes'),
      showCancelButton: true,
      cancelButtonText: this.util.translate('Cancel'),
      backdrop: false,
      background: 'white'
    }).then((data) => {
      if (data && data.value) {
        console.log('update it');
        const body = {
          id: item.id,
          status: item.status === 0 ? 1 : 0
        };
        console.log("===========", body);
        this.util.show();
        this.api.post_private('v1/products/updateProducts', body).then((data: any) => {
          this.util.hide();
          console.log("+++++++++++++++", data);
          if (data && data.status && data.status === 200 && data.success) {
            this.util.success(this.util.translate('Status Updated !'));
            this.getProducts();
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
    });
  }
}
