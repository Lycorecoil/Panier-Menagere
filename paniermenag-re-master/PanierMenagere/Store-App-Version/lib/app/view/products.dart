/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:vendors/app/controller/manage_product_controller.dart';
import 'package:vendors/app/controller/products_controller.dart';
import 'package:vendors/app/controller/search_controller.dart';
import 'package:vendors/app/env.dart';
import 'package:vendors/app/helper/router.dart';
import 'package:vendors/app/util/theme.dart';
import 'package:get/get.dart';
import '../util/drawer.dart' as drawer;

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  final GlobalKey<RefreshIndicatorState> refreshKeyNew = GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollControllerNew = ScrollController();

  void onProductPage(int id, String name) {
    Get.delete<ManageProductController>(force: true);
    Get.toNamed(AppRouter.getProductDetails(), arguments: ['update', id, name]);
  }

  @override
  void initState() {
    super.initState();

    _scrollControllerNew.addListener(() {
      if (_scrollControllerNew.position.pixels == _scrollControllerNew.position.maxScrollExtent) {
        Get.find<ProductsController>().increment();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsController>(
      builder: (value) {
        return SideMenu(
          key: _sideMenuKey,
          background: ThemeProvider.secondaryAppColor,
          menu: drawer.buildMenu(_sideMenuKey),
          type: SideMenuType.shrinkNSlide, // check above images
          inverse: true,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: ThemeProvider.appColor,
              iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
              automaticallyImplyLeading: false,
              title: Text('Products Insights'.tr, style: ThemeProvider.titleStyle),
              leading: IconButton(
                icon: const Icon(Icons.add, color: ThemeProvider.whiteColor),
                onPressed: () {
                  Get.delete<ManageProductController>(force: true);
                  Get.toNamed(AppRouter.getProductDetails(), arguments: ['create']);
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    if (_sideMenuKey.currentState!.isOpened) {
                      _sideMenuKey.currentState?.closeSideMenu();
                    } else {
                      _sideMenuKey.currentState?.openSideMenu();
                    }
                  },
                  icon: const Icon(Icons.menu, color: ThemeProvider.whiteColor),
                ),
              ],
              bottom: value.apiCalled == true
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(50),
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              height: 45,
                              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                              child: InkWell(
                                onTap: () {
                                  Get.delete<AppSearchController>(force: true);
                                  Get.toNamed(AppRouter.getSearchRoutes());
                                },
                                child: Container(
                                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [Text('Search products'.tr, style: const TextStyle(color: ThemeProvider.greyColor, fontSize: 14)), const Icon(Icons.search_outlined, color: ThemeProvider.greyColor, size: 14)],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : null,
            ),
            body: value.apiCalled == false
                ? SkeletonListView(
                    item: SkeletonListTile(
                      verticalSpacing: 12,
                      leadingStyle: const SkeletonAvatarStyle(width: 64, height: 64, shape: BoxShape.circle),
                      titleStyle: SkeletonLineStyle(height: 16, minLength: 200, randomLength: true, borderRadius: BorderRadius.circular(12)),
                      subtitleStyle: SkeletonLineStyle(height: 12, maxLength: 200, randomLength: true, borderRadius: BorderRadius.circular(12)),
                      hasSubtitle: true,
                    ),
                  )
                : RefreshIndicator(
                    key: refreshKeyNew,
                    onRefresh: () async => await value.hardRefresh(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollControllerNew,
                      child: Column(
                        children: [
                          ListView(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            children: List.generate(value.productsList.length, (index) {
                              return _buildCartProduct(value.productsList[index], index);
                            }),
                          ),
                          value.loadMore == true ? const Center(child: CircularProgressIndicator(color: ThemeProvider.appColor)) : const SizedBox()
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildCartProduct(product, productIndex) {
    return Stack(
      children: [
        InkWell(
          onTap: () => onProductPage(product.id, product.name),
          child: Container(
            color: ThemeProvider.whiteColor,
            margin: const EdgeInsets.only(bottom: 5, top: 5),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70,
                  width: 70,
                  child: FadeInImage(
                    image: NetworkImage('${Environments.apiBaseURL}storage/images/${product.cover}'),
                    placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/notfound.png', fit: BoxFit.fitWidth);
                    },
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name.length > 25 ? product.name.substring(0, 25) + '...' : product.name, style: const TextStyle(fontSize: 16, fontFamily: 'medium')),
                      Text(product.descriptions.length > 25 ? product.descriptions.substring(0, 25) + '...' : product.descriptions, style: const TextStyle(fontSize: 12, fontFamily: 'regular')),
                      Row(
                        children: [
                          Expanded(
                            child: product.discount > 0
                                ? Row(
                                    children: [
                                      Get.find<ProductsController>().currencySide == 'left'
                                          ? Text('${Get.find<ProductsController>().currencySymbol}${product.originalPrice}', style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough))
                                          : Text('${product.originalPrice}${Get.find<ProductsController>().currencySymbol}', style: const TextStyle(fontSize: 14, fontFamily: 'regular', decoration: TextDecoration.lineThrough)),
                                      Get.find<ProductsController>().currencySide == 'left'
                                          ? Text('${Get.find<ProductsController>().currencySymbol}${product.sellPrice}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                          : Text('${product.sellPrice}${Get.find<ProductsController>().currencySymbol}', style: const TextStyle(fontSize: 16, fontFamily: 'medium')),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Get.find<ProductsController>().currencySide == 'left'
                                          ? Text('${Get.find<ProductsController>().currencySymbol}${product.originalPrice}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                          : Text('${product.originalPrice}${Get.find<ProductsController>().currencySymbol}', style: const TextStyle(fontSize: 16, fontFamily: 'medium'))
                                    ],
                                  ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 15,
          child: product.discount > 0
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Color.fromARGB(255, 255, 185, 48)),
                  child: Text('${product.discount}%', style: const TextStyle(color: Colors.white, fontFamily: 'medium')),
                )
              : const SizedBox(),
        ),
        Positioned(
          top: 10,
          right: 15,
          child: ClipRRect(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(5),
              child: FittedBox(
                fit: BoxFit.cover,
                child: product.kind == 1 ? Image.asset('assets/images/veg.png') : Image.asset('assets/images/non.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
