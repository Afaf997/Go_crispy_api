import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/menu/web/menu_screen_web.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/options_view.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  final Function? onTap;
  const MenuScreen({Key? key, this.onTap}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: ColorResources.kWhite,
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar())
          : null,
      body: ResponsiveHelper.isDesktop(context)
          ? const MenuScreenWeb()
          : Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return Column(
                  children: [
                    Consumer<ProfileProvider>(
                      builder: (context, profileProvider, child) => Center(
                        child: Container(
                          width: 1170,
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          decoration: const BoxDecoration(
                            color: ColorResources.kOrangeColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: MediaQuery.of(context).padding.top),
                              Container(
                                height: 80,
                                width: 80,
                                child: ClipOval(
                                  child: authProvider.isLoggedIn()
                                      ? FadeInImage.assetNetwork(
                                          placeholder: Images.placeholderUser,
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.cover,
                                          image:
                                              '${Provider.of<SplashProvider>(context).baseUrls!.customerImageUrl}/${profileProvider.userInfoModel?.image ?? ''}',
                                          imageErrorBuilder: (c, o, s) => Image.asset(
                                            Images.placeholderUser,
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Image.asset(
                                          Images.placeholderUser,
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              Column(
                                children: [
                                  const SizedBox(height: 10),
                                  authProvider.isLoggedIn()
                                      ? profileProvider.userInfoModel != null
                                          ? Text(
                                              '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}',
                                              style: rubikRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeExtraLarge, color: Colors.white),
                                            )
                                          : Container(height: 15, width: 150, color: Colors.white)
                                      : Text(
                                          getTranslated('guest', context)!,
                                          style: rubikRegular.copyWith(
                                              fontSize: Dimensions.fontSizeExtraLarge, color: Colors.white),
                                        ),
                                  if (authProvider.isLoggedIn() && profileProvider.userInfoModel != null)
                                    Text(
                                      profileProvider.userInfoModel!.email ?? '',
                                      style: rubikRegular.copyWith(color: Colors.white),
                                    ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "QR",
                                        style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700,
                                            color: ColorResources.kWhite),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '${profileProvider.userInfoModel?.walletBalance ?? ''}',
                                        style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700,
                                            color: ColorResources.kWhite),
                                      ),
                                      
                                    ],
                                  ),
                                  const Text(
                                        "Wallet Amount",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: ColorResources.kWhite),
                                      ),
                            
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: OptionsView(onTap: widget.onTap)),
                  ],
                );
              },
            ),
    );
  }
}
