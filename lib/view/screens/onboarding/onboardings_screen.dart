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
      backgroundColor: Colors.black, // Ensure background is black to blend with image if needed
      body: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () {
              RouterHelper.getLoginRoute(); // Navigate to the login route when the image is tapped
            },
            child: Image.asset(
              Images.splash,
              fit: BoxFit.cover, // Cover the whole screen
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.05, // Adjust this value to position the button above the bottom
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            child: CustomButton(
              btnTxt: getTranslated('Get Started', context)!,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              onTap: () {
                RouterHelper.getLoginRoute(); // Navigate to the login route when the button is tapped
              },
            ),
          ),
        ],
      ),
    );
  }
}
