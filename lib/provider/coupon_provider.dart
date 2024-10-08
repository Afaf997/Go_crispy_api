import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/coupon_model.dart';
import 'package:flutter_restaurant/data/repository/coupon_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class CouponProvider extends ChangeNotifier {
  final CouponRepo? couponRepo;
  CouponProvider({required this.couponRepo});

  List<CouponModel>? _couponList;
  CouponModel? _coupon;
  double? _discount = 0.0;
  String? _code = '';
  bool _isLoading = false;

  CouponModel? get coupon => _coupon;
  double? get discount => _discount;
  String? get code => _code;
  bool get isLoading => _isLoading;
  List<CouponModel>? get couponList => _couponList;

  Future<void> getCouponList() async {
    ApiResponse apiResponse = await couponRepo!.getCouponList(
      guestId:
          Provider.of<AuthProvider>(Get.context!, listen: false).getGuestId(),
        
    );
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _couponList = [];
      apiResponse.response!.data.forEach(
          (category) => _couponList!.add(CouponModel.fromJson(category)));
      notifyListeners();
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }

  // Future<double?> applyCoupon(String coupon, double order) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   ApiResponse apiResponse = await couponRepo!.applyCoupon(coupon, guestId: Provider.of<AuthProvider>(Get.context!, listen: false).getGuestId(),);
  //   if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
  //     _coupon = CouponModel.fromJson(apiResponse.response!.data);
  //     _code = _coupon!.code;
  //     if (_coupon!.minPurchase != null && _coupon!.minPurchase! <= order) {
  //       if(_coupon!.discountType == 'percent') {
  //         if(_coupon!.maxDiscount != null && _coupon!.maxDiscount != 0) {
  //           _discount = (_coupon!.discount! * order / 100) < _coupon!.maxDiscount! ? (_coupon!.discount! * order / 100) : _coupon!.maxDiscount;
  //         }else {
  //           _discount = _coupon!.discount! * order / 100;
  //         }
  //       }else {
  //         if(_coupon!.maxDiscount != null){
  //           _discount = _coupon!.discount;
  //         }
  //         _discount = _coupon!.discount;
  //       }
  //     } else {
  //       _discount = 0.0;
  //     }
  //   } else {
  //     _discount = 0.0;
  //   }
  //   _isLoading = false;
  //   notifyListeners();
  //   return _discount;
  // }

  //new coupon applying logic if the coupon type is amount and the coupon amount is greater than the order amount, the subtotal will be zero.

  Future<double?> applyCoupon(String coupon, double order) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await couponRepo!.applyCoupon(
      coupon,
      guestId:
          Provider.of<AuthProvider>(Get.context!, listen: false).getGuestId(),
    );

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _coupon = CouponModel.fromJson(apiResponse.response!.data);
      _code = _coupon!.code;

      if (_coupon!.minPurchase != null && _coupon!.minPurchase! <= order) {
        if (_coupon!.discountType == 'percent') {
          if (_coupon!.maxDiscount != null && _coupon!.maxDiscount != 0) {
            _discount =
                (_coupon!.discount! * order / 100) < _coupon!.maxDiscount!
                    ? (_coupon!.discount! * order / 100)
                    : _coupon!.maxDiscount;
          } else {
            _discount = _coupon!.discount! * order / 100;
          }
        } else {
          _discount = _coupon!.discount!;

          // Ensure discount is not negative when discount type is 'amount'
          if (_discount != null && _discount! > order) {
            _discount = order;
          }
        }
      } else {
        _discount = 0.0;
      }
    } else {
      _discount = 0.0;
    }

    _isLoading = false;
    notifyListeners();

    return _discount;
  }

  void removeCouponData(bool notify) {
    _coupon = null;
    _isLoading = false;
    _discount = 0.0;
    _code = '';
    if (notify) {
      notifyListeners();
    }
  }
}
