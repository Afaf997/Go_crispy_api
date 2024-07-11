import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

class OrderSuccessfulScreen extends StatefulWidget {
  final String? orderID;
  final int status;
  const OrderSuccessfulScreen({Key? key, required this.orderID, required this.status}) : super(key: key);

  @override
  State<OrderSuccessfulScreen> createState() => _OrderSuccessfulScreenState();
}

class _OrderSuccessfulScreenState extends State<OrderSuccessfulScreen> {
  bool _isReload = true;

  @override
  void initState() {
    HomeScreen.loadData(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (_isReload && widget.status == 0) {
      Provider.of<OrderProvider>(context, listen: false).trackOrder(widget.orderID, fromTracking: false);
      _isReload = false;
    }
    return Scaffold(
      backgroundColor: ColorResources.kOrangeColor,
      body: SafeArea(
        child: Consumer<OrderProvider>(builder: (context, orderProvider, _) {
          double total = 0;
          bool success = true;

          if (orderProvider.trackModel != null &&
              Provider.of<SplashProvider>(context, listen: false).configModel!.loyaltyPointItemPurchasePoint != null) {
            total = ((orderProvider.trackModel!.orderAmount! / 100) *
                Provider.of<SplashProvider>(context, listen: false).configModel!.loyaltyPointItemPurchasePoint!);
          }

          return orderProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,180,Dimensions.paddingSizeDefault,10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                getTranslated(
                                  widget.status == 0
                                      ? 'Thank you!'
                                      : widget.status == 1
                                          ? 'payment_failed'
                                          : widget.status == 2
                                              ? 'order_failed'
                                              : 'payment_cancelled',
                                  context,
                                )!,
                                style: const TextStyle(
                                  color: ColorResources.kWhite,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                getTranslated(
                                  widget.status == 0
                                      ? 'Your order is confirmed'
                                      : widget.status == 1
                                          ? 'payment_failed'
                                          : widget.status == 2
                                              ? 'order_failed'
                                              : 'payment_cancelled',
                                  context,
                                )!,
                                style: const TextStyle(
                                  color: ColorResources.kWhite,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                              if (widget.status == 0)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${getTranslated('order_id', context)}:',
                                        style: const TextStyle(color: ColorResources.kWhite)),
                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                    Text('${widget.orderID}', style: const TextStyle(color: ColorResources.kWhite)),
                                  ],
                                ),
                              const SizedBox(height: 30),
                              (widget.status == 0 &&
                                      Provider.of<AuthProvider>(context, listen: false).isLoggedIn() &&
                                      success &&
                                      Provider.of<SplashProvider>(context).configModel!.loyaltyPointStatus! &&
                                      total.floor() > 0)
                                  ? Column(
                                      children: [
                                        Image.asset(
                                          Provider.of<ThemeProvider>(context, listen: false).darkTheme
                                              ? Images.gifBoxDark
                                              : Images.gifBox,
                                          width: 150,
                                          height: 150,
                                        ),
                                        Text(
                                          getTranslated('congratulations', context)!,
                                          style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                                        ),
                                        const SizedBox(height: Dimensions.paddingSizeSmall),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                          child: Text(
                                            '${getTranslated('you_have_earned', context)!} ${total.floor().toString()} ${getTranslated('points_it_will_add_to', context)!}',
                                            style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeLarge,
                                                color: Theme.of(context).disabledColor),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              const SizedBox(height:250),
                              SizedBox(
                                width: ResponsiveHelper.isDesktop(context)
                                    ? 400
                                    : MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CustomButton(
                                        backgroundColor: ColorResources.kWhite,
                                        btnTxt: getTranslated(
                                          widget.status == 0 &&
                                                  (orderProvider.trackModel?.orderType != 'take_away')
                                              ? 'track_order'
                                              : 'back_home',
                                          context,
                                        ),
                                        textColor: ColorResources.kOrangeColor,
                                        onTap: () {
                                          if (widget.status == 0 &&
                                              orderProvider.trackModel?.orderType != 'take_away') {
                                            RouterHelper.getOrderTrackingRoute(int.tryParse('${widget.orderID}'));
                                          } else {
                                            RouterHelper.getMainRoute(
                                                action: RouteAction.pushNamedAndRemoveUntil);
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      CustomButton(
                                        borderColor: ColorResources.kWhite,
                                        btnTxt: getTranslated(
                                            'Back to main menu', context),
                                        textColor: ColorResources.kWhite,
                                        onTap: () {
                                          RouterHelper.getMainRoute(
                                              action: RouteAction.pushNamedAndRemoveUntil);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (ResponsiveHelper.isDesktop(context)) const FooterView(),
                      ],
                    ),
                  ),
                );
        }),
      ),
    );
  }
}
