import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/language_model.dart';
import 'package:flutter_restaurant/data/repository/language_repo.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/language_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:provider/provider.dart';

class ChooseLanguageScreen extends StatelessWidget {
  final bool fromMenu;

  const ChooseLanguageScreen({Key? key, this.fromMenu = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    Provider.of<LanguageProvider>(context, listen: false).initializeAllLanguages(context);

    return Scaffold(
      backgroundColor: ColorResources.kOrangeColor,
      appBar: null, // No app bar
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 150),
          child: Image.asset(
            Images.crispyLogo,
            width: 117,
            height: 160,
          ),
        ),
      ),
      bottomSheet: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          height: 250,
          width: double.infinity,
          color: Colors.white, // Use your desired color for the bottom sheet
          padding: const EdgeInsets.all(16.0),
          child: Consumer<LanguageProvider>(
            builder: (context, languageProvider, _) => Column(
              children: [
                buildLanguageRow(context, 'English', 'en', languageProvider),
                Divider(),
                buildLanguageRow(context, 'العربية', 'ar', languageProvider),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLanguageRow(BuildContext context, String title, String value, LanguageProvider languageProvider) {
    return InkWell(
      onTap: () {
        languageProvider.setSelectIndex(value == 'en' ? 0 : 1);
        Provider.of<LocalizationProvider>(context, listen: false).setLanguage(
          Locale(
            AppConstants.languages[languageProvider.selectIndex].languageCode!,
            AppConstants.languages[languageProvider.selectIndex].countryCode,
          ),
        );
        handleLanguageSelection(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style:const TextStyle(fontSize: 16),
            ),
            Consumer<LanguageProvider>(
              builder: (context, languageProvider, _) => Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                       border: Border.all(color: Colors.grey),
                      color: languageProvider.selectIndex == (value == 'en' ? 0 : 1)
                      ? ColorResources.kOrangeColor
                      : Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleLanguageSelection(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final localizationProvider = Provider.of<LocalizationProvider>(context, listen: false);

    if (languageProvider.languages.isNotEmpty && languageProvider.selectIndex != -1) {
      if (fromMenu) {
        Provider.of<ProductProvider>(context, listen: false).getLatestProductList(true, '1');
        Provider.of<CategoryProvider>(context, listen: false).getCategoryList(true);
      } else {
        ResponsiveHelper.isMobile()
            ? RouterHelper.getOnBoardingRoute(action: RouteAction.pushNamedAndRemoveUntil)
            : RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
      }
        } 
  }
}

