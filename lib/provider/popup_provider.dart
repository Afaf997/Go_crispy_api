import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/popup_model.dart';
import 'package:flutter_restaurant/data/repository/popup_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';


class PopupProvider extends ChangeNotifier {
  final PopupRepo popupRepo;

  PopupProvider({required this.popupRepo});

  List<PopupModel>? _popupList;

  List<PopupModel>? get popupList => _popupList; // Add a getter for popupList

  Future<void> initPopupList(BuildContext context) async {
    ApiResponse apiResponse = await popupRepo.getPopupList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _popupList = [];
      apiResponse.response!.data.forEach((notificatioModel) => _popupList!.add(PopupModel.fromJson(notificatioModel)));
      notifyListeners(); // Notify listeners after updating the list
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }
}
