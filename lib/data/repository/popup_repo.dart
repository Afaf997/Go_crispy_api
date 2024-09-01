import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/repository/popup_repo.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/model/response/base/error_response.dart';

class PopupRepo {
  final DioClient dioClient;

  PopupRepo({required this.dioClient});

  Future<ApiResponse> getPopupList({String? guestId}) async {
    try {
      final response = await dioClient.get(AppConstants.popupUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
