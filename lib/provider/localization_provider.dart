import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/view/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider extends ChangeNotifier {
  DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  LocalizationProvider(
      {required this.sharedPreferences, required this.dioClient}) {
    _loadCurrentLanguage();
  }

  Locale _locale = const Locale('en', 'US');
  bool _isLtr = true;
  Locale get locale => _locale;
  bool get isLtr => _isLtr;

  Future<void> setLanguage(Locale locale) async {
    _locale = locale;
    if (_locale.languageCode == 'ar') {
      _isLtr = false;
    } else {
      _isLtr = true;
    }
    _saveLanguage(_locale);

    await dioClient!
        .updateHeader(
            getToken: sharedPreferences!.getString(AppConstants.token))
        .then((value) {
      HomeScreen.loadData(true, isFcmUpdate: true);
    });
    notifyListeners();
  }

  _loadCurrentLanguage() async {
    _locale = Locale(
        sharedPreferences!.getString(AppConstants.languageCode) ??
            AppConstants.languages[0].languageCode!,
        sharedPreferences!.getString(AppConstants.countryCode) ??
            AppConstants.languages[0].countryCode);
    _isLtr = _locale.languageCode == 'en';
    notifyListeners();
  }

  _saveLanguage(Locale locale) async {
    sharedPreferences!
        .setString(AppConstants.languageCode, locale.languageCode);
    sharedPreferences!.setString(AppConstants.countryCode, locale.countryCode!);

    print("language saved in shared pref");
  }
}
