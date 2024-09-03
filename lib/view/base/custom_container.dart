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
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/wish_button.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ProductWidgetContainer extends StatelessWidget {
  final Product product;
  const ProductWidgetContainer({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String productImage = '${Provider.of<SplashProvider>(context, listen: false).baseUrls?.productImageUrl ?? ''}/${product.image ?? ''}';

    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      return Padding(
        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        child: InkWell(
          onTap: () {
            if (DateConverter.isAvailable(product.availableTimeStarts!, product.availableTimeEnds!, context)) {
              ResponsiveHelper.isMobile()
                ? showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (con) => CartBottomSheet(
                      product: product,
                      callback: (CartModel cartModel) {
                        showCustomNotification(context, 'added_to_cart',type: NotificationType.success);

                      },
                    ),
                  )
                : showDialog(
                    context: context,
                    builder: (con) => Dialog(
                      backgroundColor: Colors.transparent,
                      child: CartBottomSheet(
                        product: product,
                        callback: (CartModel cartModel) {
                          // showCustomSnackBar(getTranslated('added_to_cart', context), isError: false);
                          showCustomNotification(context, 'added_to_cart', type: NotificationType.success);

                        },
                      ),
                    ));
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
            child: Container(
              decoration: BoxDecoration(
                color: ColorResources.kallcontainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 139,
                    height: 116,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: productImage.isNotEmpty
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(productImage),
                            )
                          : const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(Images.placeholderImage),
                            ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                product.name ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              WishButton(
                                product: product,
                                edgeInset: EdgeInsets.zero,
                                iconSize: 20,
                              ),
                            ],
                          ),
                          if (product.rating != null && product.rating!.isNotEmpty)
                            Row(
                              children: [
                                const Icon(Icons.star, color: ColorResources.kstarYellow, size: 16),
                                Text(
                                  ' ${product.rating![0].average}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ],
                            ),
                          Text(
                            product.description ?? '',
                            style: const TextStyle(fontSize: 8, color: ColorResources.kIncreasedColor),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            PriceConverter.convertPrice(
                              PriceConverter.convertWithDiscount(product.price, product.discount, product.discountType),
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              color: ColorResources.kredcolor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
