import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:flutter_restaurant/view/screens/home/widget/marque_text.dart';
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
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (DismissDirection direction) {
        Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
        Provider.of<CartProvider>(context, listen: false).removeFromCart(cartIndex);
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: const Icon(Icons.delete, color: Colors.white, size: 50),
      ),
      child: InkWell(
        onTap: () {
          ResponsiveHelper.isMobile()
              ? showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (con) => CartBottomSheet(
                    product: cart!.product,
                    cartIndex: cartIndex,
                    cart: cart,
                    fromCart: true,
                    callback: (CartModel cartModel) {
                      // showCustomSnackBar(
                      //     getTranslated('updated_in_cart', context),
                      //     isError: false);
                    },
                  ),
                )
              : showDialog(
                  context: context,
                  builder: (con) => Dialog(
                    backgroundColor: Colors.transparent,
                    child: CartBottomSheet(
                      product: cart!.product,
                      cartIndex: cartIndex,
                      cart: cart,
                      fromCart: true,
                      callback: (CartModel cartModel) {
                        // showCustomSnackBar(
                        //     getTranslated('updated_in_cart', context),
                        //     isError: false);
                      },
                    ),
                  ));
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
                  height: 116,
                  width: 139,
                  fit: BoxFit.cover,
                  image:
                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${cart!.product!.image}',
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
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cart!.product!.name!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: ColorResources.kstarYellow,
                            size: 10,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            cart!.product!.rating != null && cart!.product!.rating!.isNotEmpty
                                ? _getRatingStars(double.parse(cart!.product!.rating![0].average!))
                                : '0',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        cart!.product!.description!,
                        style: const TextStyle(fontSize: 8, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${cart!.product!.price} QR',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: ColorResources.kredcolor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: ColorResources.kblack,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
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
                        // Decrement logic
                        Provider.of<CartProvider>(context, listen: false)
                            .setQuantity(
                              isIncrement: false,
                              fromProductView: false,
                              cart: cart,
                              productIndex: null,
                            );
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
      ),
    );
  }
}
