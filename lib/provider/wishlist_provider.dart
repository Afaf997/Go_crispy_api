import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/repository/wishlist_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishListProvider extends ChangeNotifier {
  final WishListRepo? wishListRepo;
  WishListProvider({required this.wishListRepo});

  List<Product>? _wishList;
  List<int?> _wishIdList = [];

  List<Product>? get wishList => _wishList;
  List<int?> get wishIdList => _wishIdList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Guest mode storage key
  final String _guestWishListKey = 'guest_wish_list';

  Future<void> _saveGuestWishList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> guestWishList =
        _wishList!.map((product) => product.id.toString()).toList();
    prefs.setStringList(_guestWishListKey, guestWishList);
  }

  Future<void> _loadGuestWishList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? guestWishList = prefs.getStringList(_guestWishListKey);
    if (guestWishList != null) {
      _wishIdList = guestWishList.map((id) => int.parse(id)).toList();
      // Assuming you can fetch the product details by ID from a local source or an API
      // You would have to implement the logic to populate _wishList from _wishIdList
    }
  }

  void addToWishList(Product product, BuildContext context, bool isLoggedIn) async {
    _wishList!.add(product);
    _wishIdList.add(product.id);
    notifyListeners();

    if (isLoggedIn) {
      ApiResponse apiResponse = await wishListRepo!.addWishList(product.id);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        // Handle success
      } else {
        _wishList!.remove(product);
        _wishIdList.remove(product.id);
        ApiChecker.checkApi(apiResponse);
      }
    } else {
      await _saveGuestWishList();
    }
    notifyListeners();
  }

  void removeFromWishList(Product product, BuildContext context, bool isLoggedIn) async {
    _wishList!.removeAt(_wishIdList.indexOf(product.id));
    _wishIdList.remove(product.id);
    notifyListeners();

    if (isLoggedIn) {
      ApiResponse apiResponse = await wishListRepo!.removeWishList(product.id);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        // Handle success
      } else {
        _wishList!.add(product);
        _wishIdList.add(product.id);
        ApiChecker.checkApi(apiResponse);
      }
    } else {
      await _saveGuestWishList();
    }
    notifyListeners();
  }

  Future<void> initWishList() async {
    _wishList = [];
    _wishIdList = [];
    bool isLoggedIn = Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn();
    
    if (isLoggedIn) {
      _isLoading = true;
      ApiResponse apiResponse = await wishListRepo!.getWishList();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _wishList!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
        for (int i = 0; i < _wishList!.length; i++) {
          _wishIdList.add(_wishList![i].id);
        }
      } else {
        ApiChecker.checkApi(apiResponse);
      }
      _isLoading = false;
    } else {
      await _loadGuestWishList();
    }
    notifyListeners();
  }
}
