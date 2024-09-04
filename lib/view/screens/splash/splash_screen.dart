import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/check_version.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/branch_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/onboarding_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final String? routeTo;
  const SplashScreen({Key? key, this.routeTo}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();
    bool firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? const SizedBox() : _globalKey.currentState?.hideCurrentSnackBar();
        _globalKey.currentState?.showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? getTranslated('no_internet_connection', _globalKey.currentContext!) : getTranslated('connected', _globalKey.currentContext!),
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<CartProvider>(context, listen: false).getCartData();

    _route();
  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged.cancel();
  }

  void _route() async {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    splashProvider.initConfig(context).then((bool isSuccess) async {
      if (isSuccess) {
        final config = splashProvider.configModel!;
        double? minimumVersion;

        // Check the platform and set the minimum version
        if (defaultTargetPlatform == TargetPlatform.android && config.playStoreConfig != null) {
          minimumVersion = config.playStoreConfig!.minVersion;
        } else if (defaultTargetPlatform == TargetPlatform.iOS && config.appStoreConfig != null) {
          minimumVersion = config.appStoreConfig!.minVersion;
        }

        // Directly access shared preferences to check for the token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString(AppConstants.token);

        // If the token is present, navigate to the dashboard immediately
        if (token != null && token.isNotEmpty) {
          RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
        } else {
          // Otherwise, proceed with the normal flow after the delay
          Timer(const Duration(seconds: 1), () async {
            if (config.maintenanceMode!) {
              RouterHelper.getMaintainRoute(action: RouteAction.pushNamedAndRemoveUntil);
            } else if (Version.parse('$minimumVersion') > Version.parse(AppConstants.appVersion)) {
              RouterHelper.getUpdateRoute(action: RouteAction.pushNamedAndRemoveUntil);
            } else {
              if (widget.routeTo != null) {
                context.pushReplacement(widget.routeTo!);
              } else {
                ResponsiveHelper.isMobile() && Provider.of<OnBoardingProvider>(Get.context!, listen: false).showOnBoardingStatus
                    ? RouterHelper.getLanguageRoute(false, action: RouteAction.pushNamedAndRemoveUntil)
                    : Provider.of<BranchProvider>(Get.context!, listen: false).getBranchId() != -1
                        ? RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil)
                        : RouterHelper.getBranchListScreen(action: RouteAction.pushNamedAndRemoveUntil);
              }
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: ColorResources.kOrangeColor,
      body: Center(
        child: Consumer<SplashProvider>(builder: (context, splash, child) {
          return Image.asset(
            Images.splash, // The single splash image
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover, // Ensure the image covers the entire screen
          );
        }),
      ),
    );
  }
}
