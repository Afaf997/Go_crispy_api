import 'dart:async';  // Import the Timer package
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class MainSlider extends StatefulWidget {
  const MainSlider({Key? key}) : super(key: key);

  @override
  State<MainSlider> createState() => _MainSliderState();
}

class _MainSliderState extends State<MainSlider> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentIndex) {
        setState(() {
          _currentIndex = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();  
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentIndex + 1) % (Provider.of<BannerProvider>(context, listen: false).bannerList?.length ?? 1);
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentIndex = nextPage;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<BannerProvider>(
      builder: (context, banner, child) {
        return banner.bannerList != null
            ? banner.bannerList!.isNotEmpty
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 300,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: banner.bannerList!.length,
                            itemBuilder: (ctx, index) {
                              return Consumer<CartProvider>(
                                builder: (context, cartProvider, child) {
                                  return InkWell(
                                    onTap: () {
                                      if (banner.bannerList![index].productId != null) {
                                        Product? product;
                                        for (Product prod in banner.productList) {
                                          if (prod.id == banner.bannerList![index].productId) {
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
                                                      showCustomNotification(
                                                        context,
                                                        getTranslated('added_to_cart', context),
                                                        type: NotificationType.success,
                                                      );
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
                                                        showCustomNotification(
                                                          context,
                                                          getTranslated('added_to_cart', context),
                                                          type: NotificationType.success,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                );
                                        }
                                      } else if (banner.bannerList![index].categoryId != null) {
                                        CategoryModel? category;
                                        for (CategoryModel categoryModel in Provider.of<CategoryProvider>(context, listen: false).categoryList!) {
                                          if (categoryModel.id == banner.bannerList![index].categoryId) {
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
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: Images.placeholderBanner,
                                          width: size.width,
                                          height: size.height,
                                          fit: BoxFit.cover,
                                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}/${banner.bannerList![index].image}',
                                          imageErrorBuilder: (c, o, s) => Image.asset(
                                            Images.placeholderBanner,
                                            width: size.width,
                                            height: size.height,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: banner.bannerList!.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => _pageController.animateToPage(
                                entry.key,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              ),
                              child: Container(
                                width: 8.0,
                                height: 8.0,
                                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentIndex == entry.key
                                      ? Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.9)
                                      : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.4),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  )
                : const SizedBox()
            : const MainSliderShimmer();
      },
    );
  }
}

class MainSliderShimmer extends StatelessWidget {
  const MainSliderShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
        child: Shimmer(
          duration: const Duration(seconds: 1),
          interval: const Duration(seconds: 1),
          enabled: Provider.of<BannerProvider>(context).bannerList == null,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).shadowColor,
              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
            ),
            height: 400,
          ),
        ),
      ),
    );
  }
}
