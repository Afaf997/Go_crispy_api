import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class CartProductWidget extends StatelessWidget {
  final CartModel? cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;

  const CartProductWidget({
    Key? key,
    required this.cart,
    required this.cartIndex,
    required this.isAvailable,
    required this.addOns,
  }) : super(key: key);

  String _getRatingStars(double rating) {
    int fullStars = rating.floor();
    double fractionalStar = rating - fullStars;
    String starString = '';

    for (int i = 0; i < fullStars; i++) {
      starString += '★';
    }
    if (fractionalStar >= 0.5) {
      starString += '☆';
    }
    return starString;
  }

  @override
  Widget build(BuildContext context) {
    final product = cart!.product!;

    // Calculate the total price and discount
    double originalPrice = product.price!;
    double discount = product.discount ?? 0;
    double discountedPrice = originalPrice - (originalPrice * discount / 100);
    double totalPrice = discountedPrice * cart!.quantity!;
    double totalOriginalPrice = originalPrice * cart!.quantity!;

    return InkWell(
      onTap: () {
        ResponsiveHelper.isMobile()
            ? showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (con) => CartBottomSheet(
                  product: product,
                  cartIndex: cartIndex,
                  cart: cart,
                  fromCart: true,
                  callback: (CartModel cartModel) {
                    showCustomNotification(context,
                        getTranslated('updated_in_cart', context),
                        type: NotificationType.error);
                  },
                ),
              )
            : showDialog(
                context: context,
                builder: (con) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: CartBottomSheet(
                    product: product,
                    cartIndex: cartIndex,
                    cart: cart,
                    fromCart: true,
                    callback: (CartModel cartModel) {
                      showCustomNotification(context,
                          getTranslated('updated_in_cart', context),
                          type: NotificationType.error);
                    },
                  ),
                ),
              );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: ColorResources.kColorgrey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FadeInImage.assetNetwork(
                placeholder: Images.placeholderImage,
                height: 117,
                width: 139,
                fit: BoxFit.cover,
                image:
                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image}',
                imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                  Images.placeholderImage,
                  width: 139,
                  height: 116,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.description!,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 9, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  // Show original or discounted price based on discount
                  Text(
                    discount > 0
                        ? '${totalOriginalPrice.toStringAsFixed(2)} QR'
                        : '${totalPrice.toStringAsFixed(2)} QR', // Show original amount if no discount
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: discount > 0
                          ? ColorResources.kredcolor // Red color if there's a discount
                          : ColorResources.kredcolor , // Black color if no discount
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorResources.kblack,
              ),
              child: Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove,
                      color: ColorResources.kWhite,
                      size: 14,
                    ),
                    onPressed: () {
                      if (cart!.quantity! > 1) {
                        Provider.of<CartProvider>(context, listen: false)
                            .setQuantity(
                          isIncrement: false,
                          fromProductView: false,
                          cart: cart,
                          productIndex: null,
                        );
                      } else {
                        Provider.of<CartProvider>(context, listen: false)
                            .removeFromCart(cartIndex);
                        Provider.of<CouponProvider>(context, listen: false)
                            .removeCouponData(true);
                      }
                    },
                  ),
                  Text(
                    '${cart!.quantity}',
                    style: const TextStyle(
                      color: ColorResources.kWhite,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: ColorResources.kWhite,
                      size: 14,
                    ),
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .setQuantity(
                        isIncrement: true,
                        fromProductView: false,
                        cart: cart,
                        productIndex: null,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
