import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ColorResources {

  static Color getSearchBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  const Color(0xFF585a5c) :  const Color(0xFFF4F7FC);
  }
  static Color getBackgroundColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  const Color(0xFF343636) :  const Color(0xFFF4F7FC);
  }
  static Color getHintColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  const Color(0xFF98a1ab) :  const Color(0xFF52575C);
  }
  static Color getGreyBunkerColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  const Color(0xFFE4E8EC) :  const Color(0xFF25282B);
  }
  


  static Color getCartTitleColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?   const Color(0xFF61699b) :  const Color(0xFF000743);
  }


  static Color getProfileMenuHeaderColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  footerCol0r.withOpacity(0.5) : footerCol0r;
  }
  static Color getFooterColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?   const Color(0xFF494949) : const Color(0xFFFFDDD9);
  }


   static const Color colorNero = Color(0xFF1F1F1F);
   static const Color searchBg = Color(0xFFF4F7FC);
   static const Color borderColor = Color(0xFFDCDCDC);
   static const Color footerCol0r = Color(0xFFFFDDD9);
   static const Color cardShadowColor = Color(0xFFA7A7A7);

static const Color kOrangeColor =  Color(0xFFED5D37);
static const Color kGrayLogo = Color(0xFFEEEEEE);
static const Color kWhite = Colors.white;
static const Color kTextHintColor = Color.fromARGB(137, 88, 86, 86);
static const Color kBackgroundColor = Color(0xFFF2F2F2);
static const Color koffwhite=Color.fromARGB(255, 219, 216, 216);
static const Color koffYellow =Color.fromARGB(255, 204, 167, 45);
static const Color koffGreen =Color.fromARGB(255, 18, 148, 27);
static const Color kblack=Colors.black;
static const Color kTextgreyColor =Color.fromARGB(136, 150, 147, 147);
static const Color kredcolor =Colors.red;
static const Color korgGrey=Colors.grey;
static const Color klistgreyColor =  Color(0xFFDDDDDD);
static const Color kfavouriteColor =  Color(0xFFD9D9D9);
static const Color  klgreyColor =  Color(0xFFE1E1E1);
static const Color kSEARCHColor =  Color(0xFFEAEAEA);
static const Color kColorgrey =  Color(0xFFF6F6F6);
static const Color kmaincontainergrey =  Color(0xFFF7F7F7);
static const Color kcontainergrey =  Color(0xFFF5F5F5);
static const Color ktextgrey =  Color(0xFFBCBCBC);
static const Color kallcontainer =  Color(0xFFFAFAFA);
static const Color kColoryellow =  Color(0xFFFFBF34);
static const Color kColorgreen =  Color(0xFF4C782D);
static const Color kiconcolor =  Color(0xFF292D32);
static const Color kradiuscolor =  Color(0xFFEDEDED);
static const Color kOriginalColor = Color(0xFFDDDDDD);
static const Color kIncreasedColor = Color(0xFFB3B3B3);
static const Color kstarYellow =  Color(0xFFFFBF34);
static const Color kDeliveryBox =  Color(0xFFF0F0F0);

  



}
