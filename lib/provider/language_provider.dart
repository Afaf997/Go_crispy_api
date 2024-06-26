import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/language_model.dart';
import 'package:flutter_restaurant/data/repository/language_repo.dart';

class LanguageProvider with ChangeNotifier {
  final LanguageRepo? languageRepo;

  LanguageProvider({this.languageRepo});

  int _selectIndex = -1;
  List<LanguageModel> _languages = [];

  int get selectIndex => _selectIndex;
  List<LanguageModel> get languages => _languages;

  void setSelectIndex(int index) {
    _selectIndex = index;
    notifyListeners();
  }

  void initializeAllLanguages(BuildContext context) {
    if (_languages.isEmpty) {
      _languages = languageRepo!.getAllLanguages(context: context);
    }
  }
}
