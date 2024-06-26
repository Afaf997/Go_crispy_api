import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/app_localization.dart';

String getTranslated(String? key, BuildContext context) {
  String text = key ?? ''; // Default to empty string if key is null
  try {
    text = AppLocalization.of(context)?.translate(key!) ?? key ?? '';
  } catch (error) {
    debugPrint('Error fetching translation for key: $key, error: $error');
  }
  return text;
}
