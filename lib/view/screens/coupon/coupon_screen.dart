import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'dart:math' as math;

class CouponScreen extends StatefulWidget {
  const CouponScreen({Key? key}) : super(key: key);

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    if (_isLoggedIn || splashProvider.configModel!.isGuestCheckout!) {
      Provider.of<CouponProvider>(context, listen: false).getCouponList();
    }
  }
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontSizeLarge = screenWidth * 0.07;
    final double fontSizeMedium = screenWidth * 0.04;
    final double containerHeight = screenHeight * 0.15;
    final double fontSizeSmall = screenWidth * 0.035;
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final couponProvider = Provider.of<CouponProvider>(context);

    return Scaffold(
      backgroundColor: ColorResources.kWhite,
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar())
          : CustomAppBar(context: context, title: getTranslated('coupon', context)) as PreferredSizeWidget?,
      body: (splashProvider.configModel!.isGuestCheckout! || _isLoggedIn)
          ? couponProvider.couponList != null
              ? couponProvider.couponList!.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: () async {
                        await couponProvider.getCouponList();
                      },
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minHeight: !ResponsiveHelper.isDesktop(context) && screenHeight < 600 ? screenHeight : screenHeight - 400),
                                  child: Container(
                                    padding: screenWidth > 700 ? const EdgeInsets.all(Dimensions.paddingSizeLarge) : EdgeInsets.zero,
                                    child: Container(
                                      width: screenWidth > 700 ? 700 : screenWidth,
                                      padding: screenWidth > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                                      decoration: screenWidth > 700
                                          ? BoxDecoration(
                                              color: Theme.of(context).canvasColor,
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
                                            )
                                          : null,
                                      child: ListView.builder(
                                        itemCount: couponProvider.couponList!.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                        itemBuilder: (context, index) {
                                          Color backgroundColor;
                                          switch (index % 3) {
                                            case 0:
                                              backgroundColor = ColorResources.kOrangeColor;
                                              break;
                                            case 1:
                                              backgroundColor = ColorResources.kColoryellow;
                                              break;
                                            case 2:
                                              backgroundColor = ColorResources.kColorgreen;
                                              break;
                                            default:
                                              backgroundColor = Colors.white;
                                          }

                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                                            child: InkWell(
                                              onTap: () {
                                                Clipboard.setData(ClipboardData(text: couponProvider.couponList![index].code ?? ''));
                                                showCustomNotification(context,getTranslated('coupon_code_copied', context),type:NotificationType.success);
                                              },
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  ColorFiltered(
                                                    colorFilter: ColorFilter.mode(backgroundColor, BlendMode.srcATop),
                                                    child: Image.asset(
                                                      Images.couponBg,
                                                      height: 127,
                                                      width: 343,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 8),
                                                        child: Transform.rotate(
                                                          angle: -math.pi / 2,
                                                          child: Center(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  '${couponProvider.couponList![index].discount}${couponProvider.couponList![index].discountType == 'percent' ? '%' : splashProvider.configModel!.currencySymbol}',
                                                                  style: TextStyle(
                                                                    fontSize: fontSizeLarge,
                                                                    color: ColorResources.kWhite,
                                                                    fontWeight: FontWeight.w800,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  ' Off',
                                                                  style: TextStyle(
                                                                    fontSize: fontSizeMedium,
                                                                    color: ColorResources.kWhite,
                                                                    fontWeight: FontWeight.w800,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      // Image.asset(Images.line, height: 100, width: 3, color: ColorResources.kWhite),
                                                      SizedBox(width: screenWidth * 0.08), // Use MediaQuery to set the width
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              couponProvider.couponList![index].title!,
                                                              maxLines: 3,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle(
                                                                color: ColorResources.kWhite,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                            const SizedBox(height: Dimensions.paddingSizeDefault),
                                                            SizedBox(height: screenHeight * 0.01),
                                                            Container(
                                                              width: screenWidth * 0.33,
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: screenWidth * 0.01,
                                                                  vertical: screenHeight * 0.003),
                                                              decoration: BoxDecoration(
                                                                color: ColorResources.kWhite,
                                                                borderRadius: BorderRadius.circular(4.0),
                                                                border: Border.all(
                                                                  color: ColorResources.kGrayLogo,
                                                                  style: BorderStyle.solid,
                                                                ),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  SelectableText(
                                                                    couponProvider.couponList![index].code!,
                                                                    style: rubikRegular.copyWith(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),
                                                                  ),
                                                                  Spacer(),
                                                                  Image.asset(
                                                                    Images.copy,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (ResponsiveHelper.isDesktop(context)) const FooterView()
                            ],
                          ),
                        ),
                      ),
                    )
                  : const NoDataScreen()
              : Center( child:Image.asset(Images.gif,height:200,width: 200,))
          : const NotLoggedInScreen(),
    );
  }
}
