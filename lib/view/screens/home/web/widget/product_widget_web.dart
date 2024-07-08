import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_directionality.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/base/wish_button.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ProductWidgetWeb extends StatelessWidget {
  final bool fromPopularItem;
  final Product product;

  const ProductWidgetWeb({Key? key, required this.product, this.fromPopularItem = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? startingPrice = product.price;
    double? priceDiscount = PriceConverter.convertDiscount(context, product.price, product.discount, product.discountType);
    bool isAvailable = product.availableTimeStarts != null && product.availableTimeEnds != null
        ? DateConverter.isAvailable(product.availableTimeStarts!, product.availableTimeEnds!, context)
        : false;

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        int cartIndex = cartProvider.getCartIndex(product);
        String? productImage = product.image != null
            ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image}'
            : null;

        return InkWell(
          onTap: isAvailable ? () => _addToCart(context, cartIndex) : null,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.35,
            decoration: BoxDecoration(
              color: ColorResources.kcontainergrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: productImage != null 
                    ? FadeInImage.assetNetwork(
                        placeholder: Images.placeholderImage,
                        fit: BoxFit.cover,
                        height: 85,
                        width: double.infinity,
                        image: productImage,
                        imageErrorBuilder: (c, o, s) => Image.asset('assets/placeholder.png', fit: BoxFit.cover, height: 130, width: double.infinity),
                      )
                    : Image.asset('assets/placeholder.png', fit: BoxFit.cover, height: 85, width: double.infinity),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8,2,8,2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.name ?? 'No name available', 
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            PriceConverter.convertPrice(startingPrice, discount: product.discount, discountType: product.discountType),
                            style: const TextStyle(fontSize: 12, color: ColorResources.kredcolor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: ColorResources.kstarYellow, size: 10),
                          Text(
                            ' ${product.rating != null && product.rating!.isNotEmpty ? double.parse(product.rating![0].average!) : 0}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              product.description ?? 'No description available', 
                              style: const TextStyle(fontSize: 8),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addToCart(BuildContext context, int cartIndex) {
    ResponsiveHelper.isMobile() ? showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (con) => CartBottomSheet(
        product: product,
        callback: (CartModel cartModel) {
          showCustomSnackBar(getTranslated('added_to_cart', context), isError: false);
        },
      ),
    ) : showDialog(context: context, builder: (con) => Dialog(
      backgroundColor: Colors.transparent,
      child: CartBottomSheet(
        product: product,
        fromSetMenu: true,
        callback: (CartModel cartModel) {
          showCustomSnackBar(getTranslated('added_to_cart', context), isError: false);
        },
      ),
    ));
  }
}
