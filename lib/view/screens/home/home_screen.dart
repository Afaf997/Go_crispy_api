import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/product_type.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/set_menu_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/branch_button_view.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/category_web_view.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/set_menu_view_web.dart';
import 'package:flutter_restaurant/view/screens/home/widget/banner_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/category_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/main_slider.dart' as slider;
import 'package:flutter_restaurant/view/screens/home/widget/product_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/set_menu_view.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/options_view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final bool fromAppBar;
  const HomeScreen(this.fromAppBar, {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static Future<void> loadData(bool reload, {bool isFcmUpdate = false}) async {
    final context = Get.context!;
    final ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);
    final SetMenuProvider setMenuProvider = Provider.of<SetMenuProvider>(context, listen: false);
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final BannerProvider bannerProvider = Provider.of<BannerProvider>(context, listen: false);
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final isLogin = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    if (isLogin) {
      profileProvider.getUserInfo(reload, isUpdate: false);
      if (isFcmUpdate) {
        Provider.of<AuthProvider>(context, listen: false).updateToken();
      }
    } else {
      profileProvider.setUserInfoModel = null;
    }

    await Provider.of<WishListProvider>(context, listen: false).initWishList();
    await productProvider.getLatestProductList(reload, '1');
    if (reload || productProvider.popularProductList == null) {
      await productProvider.getPopularProductList(reload, '1');
      await splashProvider.getPolicyPage();
    }
    productProvider.seeMoreReturn();
    await categoryProvider.getCategoryList(reload);
    await setMenuProvider.getSetMenuList(reload);
    await bannerProvider.getBannerList(reload);
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);

    locationProvider.checkPermission(() =>
        locationProvider.getCurrentLocation(context, false).then((currentPosition) {}), context);

    Provider.of<ProductProvider>(context, listen: false).seeMoreReturn();
    Provider.of<ProductProvider>(context, listen: false).getLatestProductList(true, '1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.kWhite,
      key: drawerGlobalKey,
      endDrawerEnableOpenDragGesture: false,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 177,
              decoration: const BoxDecoration(
                color: ColorResources.kOrangeColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.0),
                  bottomRight: Radius.circular(24.0),
                ),
              ),
              padding: const EdgeInsets.only(right: 18, left: 18, top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getTranslated('current_location', context)!,
                            style: kLocationTextStyle.copyWith(color: ColorResources.kWhite),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: ColorResources.kWhite,
                              ),
                              GestureDetector(
                                onTap: () => RouterHelper.getAddressRoute(),
                                child: Flexible(
                                  child: Text(
                                    Provider.of<LocationProvider>(context).address!.isNotEmpty
                                        ? Provider.of<LocationProvider>(context).address!.length > 35
                                            ? '${Provider.of<LocationProvider>(context).address!.substring(0, 26)}...'
                                            : Provider.of<LocationProvider>(context).address!
                                        : getTranslated('top_to_get_best_food_for_you', context)!,
                                    style: const TextStyle(
                                      color: ColorResources.kWhite,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Image.asset(
                        Images.logo,
                        width: 50.0,
                        height: 50.0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () => RouterHelper.getSearchRoute(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: ColorResources.kWhite,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: ColorResources.kTextHintColor, size: kIconSize),
                          const SizedBox(width: 10),
                          Text(
                            getTranslated('search_items_here', context)!,
                            style: kSearchHintTextStyle.copyWith(color: ColorResources.kTextHintColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 177.0),
            child: RefreshIndicator(
              onRefresh: () async {
                Provider.of<OrderProvider>(context, listen: false).changeStatus(true, notify: true);
                Provider.of<ProductProvider>(context, listen: false).latestOffset = 1;
                Provider.of<SplashProvider>(context, listen: false).initConfig(context).then((value) {
                  if (value) {
                    HomeScreen.loadData(true);
                  }
                });
              },
              backgroundColor: ColorResources.kWhite,
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 1170,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          ResponsiveHelper.isDesktop(context) ? const Padding(
                            padding: EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                            child: slider.MainSlider(),
                          ):  const SizedBox(),
                          ResponsiveHelper.isDesktop(context) ?  const SizedBox(): const BannerView(),
                          ResponsiveHelper.isDesktop(context)? const CategoryViewWeb() : const CategoryView(),
                          ResponsiveHelper.isDesktop(context)? const SetMenuViewWeb() :  const SetMenuView(),
                         
                          ResponsiveHelper.isDesktop(context) ? Row(
                            mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                              //   child: Text(getTranslated('best_selling', context)!, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeOverLarge)),
                              // ),
                            ],
                          ) :
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: TitleWidget(title: getTranslated('best_selling', context), onTap: (){
                              RouterHelper.getPopularItemScreen();
                            },),
                          ),
                          const ProductView(productType: ProductType.popularProduct,),
                          ResponsiveHelper.isDesktop(context) ? Row(
                            mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                child: Text(getTranslated('latest_item', context)!, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeOverLarge)),
                              ),
                            ],
                          ) :
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                            child: TitleWidget(title: getTranslated('latest_item', context)),
                          ),
                        ]),
                      ),
                      if(ResponsiveHelper.isDesktop(context)) const FooterView(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
