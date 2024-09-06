import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/popup_model.dart';
import 'package:flutter_restaurant/data/repository/popup_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';


class PopupProvider extends ChangeNotifier {
  final PopupRepo popupRepo;

  PopupProvider({required this.popupRepo});
   bool popuploading =false;
  List<PopupModel>? _popupList;
  List<PopupModel>? get popupList => _popupList;

  Future<void> initPopupList(BuildContext context) async {
    popuploading=true;
    notifyListeners();
    ApiResponse apiResponse = await popupRepo.getPopupList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

      _popupList = [];
      apiResponse.response!.data.forEach((notificatioModel) => _popupList!.add(PopupModel.fromJson(notificatioModel)));
      notifyListeners();
      Future.delayed(const Duration(seconds: 3),(){
        popuploading=false; 
        notifyListeners();
      });
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }
}
