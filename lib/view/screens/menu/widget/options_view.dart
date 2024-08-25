import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/branch_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/language/model.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:flutter_restaurant/view/screens/scaner/scaner_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base/custom_dialog.dart';

class OptionsView extends StatelessWidget {
  final Function? onTap;
  const OptionsView({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final policyModel =
        Provider.of<SplashProvider>(context, listen: false).policyModel;
    final configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    final splashRepo = Provider.of<SplashProvider>(context, listen: false);

    return Consumer<AuthProvider>(
        builder: (context, authProvider, _) => SingleChildScrollView(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: SizedBox(
                  width: ResponsiveHelper.isTab(context) ? null : 1170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: ResponsiveHelper.isTab(context) ? 50 : 0),

                      ResponsiveHelper.isTab(context)
                          ? ListTile(
                              onTap: () =>
                                  RouterHelper.getDashboardRoute('home'),
                              leading: Image.asset(Images.home,
                                  width: 20,
                                  height: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                              title: Text(getTranslated('home', context)!,
                                  style: rubikMedium.copyWith(
                                      fontSize: Dimensions.fontSizeLarge)),
                            )
                          : const SizedBox(),

                      ListTile(
                        onTap: () => ResponsiveHelper.isMobilePhone()
                            ? onTap!(2)
                            : RouterHelper.getDashboardRoute('order'),
                        leading: Image.asset(
                          Images.ordericon,
                          width: 20,
                          height: 20,
                        ),
                        title: Text(getTranslated('my_order', context)!,
                            style: rubikMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14),
                      ),

                      ListTile(
                        onTap: () => RouterHelper.getNotificationRoute(),
                        leading: Image.asset(
                          Images.notificationicon,
                          width: 20,
                          height: 20,
                        ),
                        title: Text(getTranslated('notification', context)!,
                            style: rubikMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14),
                      ),

                      ListTile(
                        onTap: () => RouterHelper.getProfileRoute(),
                        leading: Image.asset(
                          Images.profileicon,
                          width: 20,
                          height: 20,
                        ),
                        title: Text(getTranslated('profile', context)!,
                            style: rubikMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14),
                      ),

                      // ListTile(
                      //   onTap: () => RouterHelper.getChatRoute(orderModel: null),
                      //   leading: Image.asset(Images.message, width: 20, height: 20, color: Theme.of(context).textTheme.bodyLarge!.color),
                      //   title: Text(getTranslated('message', context)!, style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                      // ),
                      ListTile(
                        onTap: () => RouterHelper.getCouponRoute(),
                        leading: Image.asset(
                          Images.walleticon,
                          width: 20,
                          height: 20,
                        ),
                        title: Text(getTranslated('coupon', context)!,
                            style: rubikMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14),
                      ),
                      ResponsiveHelper.isDesktop(context)
                          ? ListTile(
                              onTap: () => RouterHelper.getNotificationRoute(),
                              leading: Image.asset(
                                Images.coupenicon,
                                width: 20,
                                height: 20,
                              ),
                              title: Text(
                                  getTranslated('notifications', context)!,
                                  style: rubikMedium.copyWith(
                                      fontSize: Dimensions.fontSizeLarge)),
                              trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14),
                            )
                          : const SizedBox(),
                      ListTile(
                        onTap: () => RouterHelper.getAddressRoute(),
                        leading: Image.asset(
                          Images.addressicon,
                          width: 20,
                          height: 20,
                        ),
                        title: Text(getTranslated('address', context)!,
                            style: rubikMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14),
                      ),
                      ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LanguagemodelScreen())),
                        leading: Image.asset(
                          Images.languageicon,
                          width: 20,
                          height: 20,
                        ),
                        title: Text(getTranslated('language', context)!,
                            style: rubikMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14),
                      ),
                      ListTile(
                        onTap: () => RouterHelper.getSupportRoute(),
                        leading: SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset(
                              Images.helpicon,
                            )),
                        title: Text(getTranslated('help_and_support', context)!,
                            style: rubikMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14),
                      ),
                      ListTile(
                        onTap: () => RouterHelper.getPolicyRoute(),
                        leading: SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset(
                              Images.policyicon,
                            )),
                        title: Text(getTranslated('privacy_policy', context)!,
                            style: rubikMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14),
                      ),
                      ListTile(
                        onTap: () => RouterHelper.getTermsRoute(),
                        leading: SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset(
                              Images.termsicon,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            )),
                        title: Text(
                            getTranslated('terms_and_condition', context)!,
                            style: rubikMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14),
                      ),

                      if (policyModel != null &&
                          policyModel.returnPage != null &&
                          policyModel.returnPage!.status!)
                        ListTile(
                          onTap: () => RouterHelper.getReturnPolicyRoute(),
                          leading: Image.asset(
                            Images.returnPolicy,
                            width: 20,
                            height: 20,
                          ),
                          title: Text(getTranslated('return_policy', context)!,
                              style: rubikMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge)),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded,
                              size: 14),
                        ),

                      if (policyModel != null &&
                          policyModel.refundPage != null &&
                          policyModel.refundPage!.status!)
                        ListTile(
                          onTap: () => RouterHelper.getRefundPolicyRoute(),
                          leading: Image.asset(
                            Images.refundPolicy,
                            width: 20,
                            height: 20,
                          ),
                          title: Text(getTranslated('refund_policy', context)!,
                              style: rubikMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge)),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded,
                              size: 14),
                        ),
                      if (policyModel != null &&
                          policyModel.cancellationPage != null &&
                          policyModel.cancellationPage!.status!)
                        ListTile(
                          onTap: () =>
                              RouterHelper.getCancellationPolicyRoute(),
                          leading: Image.asset(
                            Images.cancellationPolicy,
                            width: 20,
                            height: 20,
                          ),
                          title: Text(
                              getTranslated('cancellation_policy', context)!,
                              style: rubikMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge)),
                        ),


                      ListTile(
                        onTap: () async {
                          if (authProvider.isLoggedIn()) {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) =>
                                    const SignOutConfirmationDialog());
                          } else {
                            final pref = await SharedPreferences.getInstance();

                            await pref.remove(AppConstants.branch);

                            RouterHelper.getLoginRoute();
                          }
                        },
                        leading: Image.asset(Images.login,
                            width: 20,
                            height: 20,
                            color: ColorResources.kOrangeColor),
                        title: Text(
                            getTranslated(
                                authProvider.isLoggedIn() ? 'logout' : 'login',
                                context)!,
                            style: rubikMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge)),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
