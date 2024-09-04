import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/images.dart';

class OnBoardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black, // Ensure background is black to blend with image if needed
      body: GestureDetector(
        onTap: () {
          RouterHelper.getLoginRoute(); // Navigate to the login route when the image is tapped
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              Images.welcome,
              fit: BoxFit.cover, // Cover the whole screen
            ),
          ],
        ),
      ),
    );
  }
}
