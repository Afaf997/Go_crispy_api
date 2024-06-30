import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class BannerView extends StatefulWidget {
  const BannerView({Key? key}) : super(key: key);

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const SizedBox(height: 15,),
        Consumer<BannerProvider>(
          builder: (context, banner, child) {
            return banner.bannerList != null && banner.bannerList!.isNotEmpty
                ? Column(
                    children: [
                      CarouselSlider(
                        items: banner.bannerList!.map((bannerItem) {
                          return Builder(
                            builder: (BuildContext context) {
                              return InkWell(
                                onTap: () {
                                  if (bannerItem.productId != null) {
                                    Product? product;
                                    for (Product prod in banner.productList) {
                                      if (prod.id == bannerItem.productId) {
                                        product = prod;
                                        break;
                                      }
                                    }
                                    if (product != null) {
                                      ResponsiveHelper.isMobile()
                                          ? showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor: Colors.transparent,
                                              builder: (con) => CartBottomSheet(
                                                product: product,
                                                callback: (CartModel cartModel) {
                                                  showCustomSnackBar(
                                                      getTranslated('added_to_cart', context),
                                                      isError: false);
                                                },
                                              ),
                                            )
                                          : showDialog(
                                              context: context,
                                              builder: (con) => Dialog(
                                                backgroundColor: Colors.transparent,
                                                child: CartBottomSheet(
                                                  product: product,
                                                  callback: (CartModel cartModel) {
                                                    showCustomSnackBar(
                                                        getTranslated('added_to_cart', context),
                                                        isError: false);
                                                  },
                                                ),
                                              ),
                                            );
                                    }
                                  } else if (bannerItem.categoryId != null) {
                                    CategoryModel? category;
                                    for (CategoryModel categoryModel in Provider.of<CategoryProvider>(context, listen: false).categoryList!) {
                                      if (categoryModel.id == bannerItem.categoryId) {
                                        category = categoryModel;
                                        break;
                                      }
                                    }
                                    if (category != null) {
                                      RouterHelper.getCategoryRoute(category);
                                    }
                                  }
                                },
                                child: Container(
                                  width: 353,
                                  height: 145,
                                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}/${bannerItem.image}'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 145,
                          viewportFraction: 1.0,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval:const Duration(seconds: 3),
                          autoPlayAnimationDuration:const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: banner.bannerList!.map((url) {
                          int index = banner.bannerList!.indexOf(url);
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? Color.fromRGBO(0, 0, 0, 0.9)
                                  : Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  )
                : Center(child: Text(getTranslated('no_banner_available', context)!));
          },
        ),
      ],
    );
  }
}
