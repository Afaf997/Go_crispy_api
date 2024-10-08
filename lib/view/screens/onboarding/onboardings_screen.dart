import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';

class OnBoardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorResources.kOrangeColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                RouterHelper.getLoginRoute(); 
              },
              child: Image.asset(
                Images.splash,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Button
          Positioned(
            bottom: screenHeight * 0.05,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            child: CustomButton(
              btnTxt: getTranslated('get_started', context)!,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              onTap: () {
                RouterHelper.getLoginRoute();
              },
            ),
          ),
        ],
      ),
    );
  }
}
