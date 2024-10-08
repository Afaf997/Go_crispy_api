
import 'dart:developer';

import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/repository/product_repo.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo? productRepo;

  ProductProvider({required this.productRepo});

  // Latest products
  List<Product>? _popularProductList;
  List<Product>? _latestProductList;
  bool _isLoading = false;
  int? _popularPageSize;
  int? _latestPageSize;
  List<String> _offsetList = [];
  // List<int> _variationIndex = [0];
  int? _quantity = 1;
  List<bool> _addOnActiveList = [];
  List<int?> _addOnQtyList = [];
  bool _seeMoreButtonVisible= true;
  int latestOffset = 1;
  int popularOffset = 1;
  int _cartIndex = -1;
  final List<String> _productTypeList = ['all', 'non_veg', 'veg'];
  List<List<bool?>> _selectedVariations = [];



  List<Product>? get popularProductList => _popularProductList;
  List<Product>? get latestProductList => _latestProductList;
  bool get isLoading => _isLoading;
  int? get popularPageSize => _popularPageSize;
  int? get latestPageSize => _latestPageSize;
  // List<int> get variationIndex => _variationIndex;
  int? get quantity => _quantity;
  List<bool> get addOnActiveList => _addOnActiveList;
  List<int?> get addOnQtyList => _addOnQtyList;
  bool get seeMoreButtonVisible => _seeMoreButtonVisible;
  int get cartIndex => _cartIndex;
  List<String> get productTypeList => _productTypeList;
  List<List<bool?>> get selectedVariations => _selectedVariations;




  Future<void> getLatestProductList(bool reload, String offset) async {
    _isLoading = true;
    notifyListeners();
    if(reload || offset == '1' || _latestProductList == null) {
      latestOffset = 1 ;
      _offsetList = [];
      _latestProductList = null;
    }
    if (!_offsetList.contains(offset)) {
      _offsetList = [];
      _offsetList.add(offset);
      ApiResponse apiResponse = await productRepo!.getLatestProductList(offset);
      log(apiResponse.toString());
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        if (reload || offset == '1' || _latestProductList == null) {
          _latestProductList = [];
        }
        _latestProductList!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
        _latestPageSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
        _isLoading = false;
        notifyListeners();
      } else {
        _latestProductList = [];

        // showCustomSnackBar(apiResponse.error.toString());
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> getPopularProductList( bool reload, String offset, {String type = 'all',bool isUpdate = false}) async {
    bool apiSuccess = false;
    if(reload || offset == '1') {
      popularOffset = 1 ;
      _offsetList = [];
      _popularProductList = null;
    }
    if(isUpdate) {
      notifyListeners();
    }

    if (!_offsetList.contains(offset)) {
      _offsetList = [];
      _offsetList.add(offset);
      ApiResponse apiResponse = await productRepo!.getPopularProductList(offset, type);

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        apiSuccess = true;
        if (reload || offset == '1') {
          _popularProductList = [];
        }
        _popularProductList!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
        _popularPageSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
        _isLoading = false;
        notifyListeners();
      } else {
        // showCustomSnackBar(apiResponse.error.toString());
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
    return apiSuccess;
  }

  void showBottomLoader() {
    _isLoading = true;
    notifyListeners();
  }

  void initData(Product? product, CartModel? cart) {
    _selectedVariations = [];
    _addOnQtyList = [];
    _addOnActiveList = [];

    if(cart != null) {
      _quantity = cart.quantity;
      _selectedVariations.addAll(cart.variations!);
      List<int?> addOnIdList = [];
      for (var addOnId in cart.addOnIds!) {
        addOnIdList.add(addOnId.id);
      }
      for (var addOn in product!.addOns!) {
        if(addOnIdList.contains(addOn.id)) {
          _addOnActiveList.add(true);
          _addOnQtyList.add(cart.addOnIds![addOnIdList.indexOf(addOn.id)].quantity);
        }else {
          _addOnActiveList.add(false);
          _addOnQtyList.add(1);
        }
      }
    }else {
      _quantity = 1;
      if(product!.variations != null){
        for(int index=0; index<product.variations!.length; index++) {
          _selectedVariations.add([]);
          for(int i=0; i < product.variations![index].variationValues!.length; i++) {
            _selectedVariations[index].add(false);
          }
        }
      }

      if(product.addOns != null){
        for (int i = 0; i < product.addOns!.length; i++) {
          _addOnActiveList.add(false);
          _addOnQtyList.add(1);
        }
      }

    }
  }

  void setAddOnQuantity(bool isIncrement, int index) {
    if (isIncrement) {
      _addOnQtyList[index] = _addOnQtyList[index]! + 1;
    } else {
      _addOnQtyList[index] = _addOnQtyList[index]! - 1;
    }
    notifyListeners();
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = _quantity! + 1;
    } else {
      _quantity = _quantity! - 1;
    }
    notifyListeners();
  }

  void setCartVariationIndex(int index, int i, Product? product, bool isMultiSelect) {
    if(!isMultiSelect) {
      for(int j = 0; j < _selectedVariations[index].length; j++) {
        if(product!.variations![index].isRequired!){
          _selectedVariations[index][j] = j == i;
        }else{
          if(_selectedVariations[index][j]!){
            _selectedVariations[index][j] = false;
          }else{
            _selectedVariations[index][j] = j == i;
          }
        }
      }
    } else {
      if(!_selectedVariations[index][i]! && selectedVariationLength(_selectedVariations, index) >= product!.variations![index].max!) {
        // showCustomSnackBar('${getTranslated('maximum_variation_for', Get.context!)} ${product.variations![index].name
        // } ${getTranslated('is', Get.context!)} ${product.variations![index].max}', isToast: true);

      }else {
        _selectedVariations[index][i] = !_selectedVariations[index][i]!;
      }
    }
    notifyListeners();
  }
  int selectedVariationLength(List<List<bool?>> selectedVariations, int index) {
    int length = 0;
    for(bool? isSelected in selectedVariations[index]) {
      if(isSelected!) {
        length++;
      }
    }
    return length;
  }

  int setExistInCart(Product product, {bool notify = true}) {
    final cartProvider = Provider.of<CartProvider>(Get.context!, listen: false);

    _cartIndex = cartProvider.isExistInCart(product.id, null);
    if(_cartIndex != -1) {
      _quantity = cartProvider.cartList[_cartIndex]!.quantity;
      _addOnActiveList = [];
      _addOnQtyList = [];
      List<int?> addOnIdList = [];
      for (var addOnId in cartProvider.cartList[_cartIndex]!.addOnIds!) {
        addOnIdList.add(addOnId.id);
      }
      for (var addOn in product.addOns!) {
        if(addOnIdList.contains(addOn.id)) {
          _addOnActiveList.add(true);
          _addOnQtyList.add(cartProvider.cartList[_cartIndex]!.addOnIds![addOnIdList.indexOf(addOn.id)].quantity);
        }else {
          _addOnActiveList.add(false);
          _addOnQtyList.add(1);
        }
      }
    }
    return _cartIndex;
  }

  void addAddOn(bool isAdd, int index) {
    _addOnActiveList[index] = isAdd;
    notifyListeners();
  }

  void moreProduct(BuildContext context) {
    int pageSize;
    pageSize =(latestPageSize! / 10).ceil();

    if (latestOffset < pageSize) {
      latestOffset++;
      showBottomLoader();
      getLatestProductList(false, latestOffset.toString());
    }
  }


  void seeMoreReturn(){
    latestOffset = 1;
    _seeMoreButtonVisible = true;
  }


  bool checkStock(Product product, {int? quantity}){
    int? stock;
    if(product.branchProduct?.stockType != 'unlimited' && product.branchProduct?.stock != null && product.branchProduct?.soldQuantity != null){
      stock = product.branchProduct!.stock! - product.branchProduct!.soldQuantity!;
      if(quantity != null){
        stock = stock - quantity;
      }

    }
    return stock == null || (stock > 0);
  }

}
