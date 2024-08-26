import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/helper/product_type.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/branch_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/category_web_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/banner_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/category_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/locate_container.dart';
import 'package:flutter_restaurant/view/screens/home/widget/main_slider.dart'as slider;
import 'package:flutter_restaurant/view/screens/home/widget/product_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final bool fromAppBar;
  const HomeScreen(this.fromAppBar, {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static Future<void> loadData(bool reload, {bool isFcmUpdate = false}) async {
    final context = Get.context!;
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    final BannerProvider bannerProvider =
        Provider.of<BannerProvider>(context, listen: false);
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final isLogin =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

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
    // await setMenuProvider.getSetMenuList(reload);
    await bannerProvider.getBannerList(reload);
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final locationProvider =
          Provider.of<LocationProvider>(context, listen: false);
      Provider.of<ProductProvider>(context, listen: false)
          .getLatestProductList(true, '1');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.kWhite,
      key: drawerGlobalKey,
      endDrawerEnableOpenDragGesture: false,
      body: Consumer3<CategoryProvider, BannerProvider, ProductProvider>(
          builder: (context, cp, bp, pp, _) {
        if (pp.isLoading) {
          return Center(
            child: Image.asset(
              Images.gif,
              width: 150,
              height: 150,
            ),
          );
        }

        return Stack(
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
                padding: EdgeInsets.only(right: 18, left: 18, top: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTranslated('Current Branch', context)!,
                              style: kLocationTextStyle.copyWith(
                                  color: ColorResources.kWhite),
                            ),
                            GestureDetector(
                              onTap: () {
                                GoRouter.of(context).go('/branch-list');
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: ColorResources.kWhite,
                                  ),
                                  Consumer<BranchProvider>(
                                    builder: (context, branchProvider, _) {
                                      if (branchProvider.getBranchId() == -1) {
                                        return const SizedBox();
                                      }

                                      List<Branches?> sortedBranches =
                                          List.from(branchProvider.branches);
                                      sortedBranches.sort((a, b) {
                                        if (a!.id ==
                                            branchProvider.getBranchId())
                                          return -1;
                                        if (b!.id ==
                                            branchProvider.getBranchId())
                                          return 1;
                                        return 0;
                                      });

                                      return Text(
                                        sortedBranches.isNotEmpty
                                            ? sortedBranches[0]!.name ?? ''
                                            : '',
                                        style: const TextStyle(
                                          color: ColorResources.kWhite,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Image.asset(
                          Images.logo,
                          width: 50.0,
                          height: 50.0,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => RouterHelper.getSearchRoute(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: ColorResources.kWhite,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search,
                                color: ColorResources.kTextHintColor,
                                size: kIconSize),
                            const SizedBox(width: 10),
                            Text(
                              getTranslated('search_items_here', context)!,
                              style: kSearchHintTextStyle.copyWith(
                                  color: ColorResources.kTextHintColor),
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
              padding: EdgeInsets.only(top: 177.0),
              child: RefreshIndicator(
                onRefresh: () async {
                  Provider.of<OrderProvider>(context, listen: false)
                      .changeStatus(true, notify: true);
                  Provider.of<ProductProvider>(context, listen: false)
                      .latestOffset = 1;
                  Provider.of<SplashProvider>(context, listen: false)
                      .initConfig(context)
                      .then((value) {
                    if (value) {
                      HomeScreen.loadData(true);
                    }
                  });
                },
                backgroundColor: ColorResources.kWhite,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Center(
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (ResponsiveHelper.isDesktop(context))
                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: Dimensions.paddingSizeDefault),
                                  child: slider.MainSlider(),
                                ),
                              if (!ResponsiveHelper.isDesktop(context))
                                const BannerView(),
                              if (ResponsiveHelper.isDesktop(context))
                                const CategoryViewWeb()
                              else
                                const CategoryView(),
                              if (ResponsiveHelper.isDesktop(context))
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                         const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                      child: Text(
                                          getTranslated(
                                              'best_selling', context),
                                          style: rubikRegular.copyWith(
                                              fontSize: Dimensions
                                                  .fontSizeOverLarge)),
                                    ),
                                  ],
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                  child: TitleWidget(
                                      title: getTranslated(
                                          'best_selling', context),
                                      onTap: () {
                                        RouterHelper.getPopularItemScreen();
                                      }),
                                ),
                              const ProductView(
                                  productType: ProductType.popularProduct),
                              if (ResponsiveHelper.isDesktop(context))
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                      child: Text(
                                          getTranslated('latest_item', context),
                                          style: rubikRegular.copyWith(
                                              fontSize: Dimensions
                                                  .fontSizeOverLarge)),
                                    ),
                                  ],
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                                  child: TitleWidget(
                                      title: getTranslated(
                                          'latest_item', context)),
                                ),
                              const ProductView(
                                  productType: ProductType.latestProduct),
                              buildLocateContainer(context),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Consumer<SplashProvider>(builder: (context, splashProvider, _) {
              return !splashProvider.isRestaurantOpenNow(context)
                  ? Positioned(
                      bottom: Dimensions.paddingSizeExtraSmall,
                      left: 0,
                      right: 0,
                      child: Consumer<OrderProvider>(
                        builder: (context, orderProvider, _) {
                          return orderProvider.isRestaurantCloseShow
                              ? Container(
                                  padding:const  EdgeInsets.symmetric(
                                      vertical:
                                          Dimensions.paddingSizeExtraSmall),
                                  alignment: Alignment.center,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.9),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.paddingSizeDefault),
                                        child: Text(
                                          getTranslated('restaurant_is_close_now', context),
                                          style: rubikRegular.copyWith(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => orderProvider
                                            .changeStatus(false, notify: true),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeSmall),
                                          child: Icon(Icons.cancel_outlined,
                                              color: Colors.white,
                                              size:
                                                  Dimensions.paddingSizeLarge),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              :const SizedBox();
                        },
                      ),
                    )
                  :const SizedBox();
            }),
          ],
        );
      }),
    );
  }
}
