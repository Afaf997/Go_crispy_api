import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/language_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

class LanguagemodelScreen extends StatelessWidget {
  final bool fromMenu;

  const LanguagemodelScreen({Key? key, this.fromMenu = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    // Initialize languages and set default language if none is selected
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    languageProvider.initializeAllLanguages(context);

    if (languageProvider.selectIndex == -1 && languageProvider.languages.isNotEmpty) {
      // Default to English if no selection is made
      languageProvider.setSelectIndex(0); // Assuming English is at index 0
    }

    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        title: getTranslated('language', context),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.white,
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

  Widget buildLanguageRow(BuildContext context, String title, String value,
      LanguageProvider languageProvider) {
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
          children: [
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
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void handleLanguageSelection(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final localizationProvider = Provider.of<LocalizationProvider>(context, listen: false);

    // Check if the language list is empty or the selected index is invalid
    if (languageProvider.languages.isEmpty || languageProvider.selectIndex == -1) {
      // Default to English if no selection is made or list is empty
      languageProvider.setSelectIndex(0);
      localizationProvider.setLanguage(
        Locale(
          AppConstants.languages[0].languageCode!,
          AppConstants.languages[0].countryCode,
        ),
      );
    }

    // Proceed with the language selection logic
    if (fromMenu) {
      Provider.of<ProductProvider>(context, listen: false).getLatestProductList(true, '1');
      Provider.of<CategoryProvider>(context, listen: false).getCategoryList(true);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(pageIndex: 4),
        ),
      );
    }
  }
}
