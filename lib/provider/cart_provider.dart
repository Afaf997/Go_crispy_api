import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/repository/cart_repo.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';

class CartProvider extends ChangeNotifier {
  final CartRepo? cartRepo;
  CartProvider({required this.cartRepo});

  List<CartModel?> _cartList = [];
  double _amount = 0.0;
  bool _isCartUpdate = false;

  List<CartModel?> get cartList => _cartList;
  double get amount => _amount;
  bool get isCartUpdate => _isCartUpdate;

  void getCartData() {
    _cartList = [];
    _cartList.addAll(cartRepo!.getCartList());
    for (var cart in _cartList) {
      _amount = _amount + (cart!.discountedPrice! * cart.quantity!);
    }
  }

 void addToCart(CartModel cartModel, int? index) {
  // Check if the item already exists in the cart
  final existingCartIndex = _cartList.indexWhere(
    (item) => _generateProductKey(item!) == _generateProductKey(cartModel),
  );

  if (existingCartIndex != -1) {
    final existingCartItem = _cartList[existingCartIndex];
    existingCartItem?.quantity = (existingCartItem.quantity ?? 0) + (cartModel.quantity ?? 0);
    _cartList[existingCartIndex] = existingCartItem;
  } else {
    if (index != null && index != -1) {
      _cartList.replaceRange(index, index + 1, [cartModel]);
    } else {
      _cartList.add(cartModel);
    }
  }

  cartRepo!.addToCartList(_cartList);
  setCartUpdate(false);

  // Optionally show a notification or dialog
  // showCustomNotification(
  //   getTranslated(index == -1 ? 'added_in_cart' : 'cart_updated', Get.context!),
  //   isToast: true,
  //   isError: false,
  // );

  notifyListeners();
}

String _generateProductKey(CartModel cartModel) {
  // Generate a unique key based on product id and variation (and any other relevant attributes)
  final productId = cartModel.product?.id ?? 0;
  final variation = cartModel.variation?.map((v) => v.min).join(',') ?? '';
  return '$productId-$variation';
}

  void setQuantity(
      {required bool isIncrement,
      CartModel? cart,
      int? productIndex,
      required bool fromProductView}) {
    int? index = fromProductView ? productIndex : _cartList.indexOf(cart);

    if (index != null && index >= 0) {
      if (isIncrement) {
        _cartList[index]!.quantity = _cartList[index]!.quantity! + 1;
        _amount = _amount + _cartList[index]!.discountedPrice!;
      } else {
        // Ensure the quantity does not go below 1
        if (_cartList[index]!.quantity! > 1) {
          _cartList[index]!.quantity = _cartList[index]!.quantity! - 1;
          _amount = _amount - _cartList[index]!.discountedPrice!;
        }
      }
      cartRepo!.addToCartList(_cartList);
      notifyListeners();
    }
  }

  void removeFromCart(int index) {
    _amount = _amount -
        (_cartList[index]!.discountedPrice! * _cartList[index]!.quantity!);
    _cartList.removeAt(index);
    cartRepo!.addToCartList(_cartList);
    notifyListeners();
  }

  void removeAddOn(int index, int addOnIndex) {
    _cartList[index]!.addOnIds!.removeAt(addOnIndex);
    cartRepo!.addToCartList(_cartList);
    notifyListeners();
  }

  void clearCartList() {
    _cartList = [];
    _amount = 0;
    cartRepo!.addToCartList(_cartList);
    notifyListeners();
  }

  int isExistInCart(int? productID, int? cartIndex) {
    for (int index = 0; index < _cartList.length; index++) {
      if (_cartList[index]!.product!.id == productID) {
        if ((index == cartIndex)) {
          return -1;
        } else {
          return index;
        }
      }
    }
    return -1;
  }

  int getCartIndex(Product product) {
    for (int index = 0; index < _cartList.length; index++) {
      if (_cartList[index]!.product!.id == product.id) {
        return index;
      }
    }
    return -1;
  }

  int getCartProductQuantityCount(Product product) {
    int quantity = 0;
    for (int index = 0; index < _cartList.length; index++) {
      if (_cartList[index]!.product!.id == product.id) {
        quantity = quantity + (_cartList[index]!.quantity ?? 0);
      }
    }
    return quantity;
  }

  setCartUpdate(bool isUpdate) {
    _isCartUpdate = isUpdate;
    if (_isCartUpdate) {
      notifyListeners();
    }
  }
}
