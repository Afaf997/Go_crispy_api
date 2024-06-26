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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.05),
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Image.asset(Images.handBurger),
              Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.44, left: screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Align children to the start of the column
                  children: [
                    Image.asset(Images.welcomeImage),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: screenWidth * 0.7,
                      child: Text(
                        "Experience Crispy Satisfaction with Every Bite!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.06,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05),
                CustomButton(
                  btnTxt: getTranslated('Get Started',context),
                  backgroundColor:Colors.black,
                  textColor: Colors.white,
                  onTap: () {
                        RouterHelper.getLoginRoute();
                      }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
