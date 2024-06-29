import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';

const rubikRegular = TextStyle(
  fontFamily: 'Rubik',
  fontSize: Dimensions.fontSizeDefault,
  fontWeight: FontWeight.w400,
);

const rubikMedium = TextStyle(
  fontFamily: 'Rubik',
  fontSize: Dimensions.fontSizeDefault,
  fontWeight: FontWeight.w500,
);

const rubikBold = TextStyle(
  fontFamily: 'Rubik',
  fontSize: Dimensions.fontSizeDefault,
  fontWeight: FontWeight.w700,
);

const poppinsRegular = TextStyle(
  fontFamily: 'Poppins',
  fontSize: Dimensions.fontSizeDefault,
  fontWeight: FontWeight.w400,
);

const robotoRegular = TextStyle(
  fontFamily: 'Roboto',
  fontSize: Dimensions.fontSizeDefault,
  fontWeight: FontWeight.w400,
);


const TextStyle kLocationTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 12,
  fontWeight: FontWeight.bold
);

const TextStyle kSearchHintTextStyle = TextStyle(
  color:ColorResources.kTextHintColor,
  fontSize: 14
);

 BoxDecoration kSearchBoxDecoration = BoxDecoration(
  color:ColorResources.kWhite,
  borderRadius: BorderRadius.circular(15.0),
);

 BoxDecoration kImageBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(15.0),
);

const double kIconSize = 22.0; 

const TextStyle kTitleTextStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);

const TextStyle kSubtitleTextStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.normal,
);
