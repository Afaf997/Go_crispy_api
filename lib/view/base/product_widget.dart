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

class ProductWidget extends StatelessWidget {
  final Product product;
  const ProductWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? startingPrice = product.price;
    double? discountedPrice = PriceConverter.convertWithDiscount(
        product.price, product.discount, product.discountType);

    bool isAvailable = DateConverter.isAvailable(
        product.availableTimeStarts!, product.availableTimeEnds!, context);

    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      String productImage =
          '${Provider.of<SplashProvider>(context, listen: false).baseUrls?.productImageUrl ?? ''}/${product.image ?? ''}';

      return InkWell(
        onTap: isAvailable
            ? () {
                ResponsiveHelper.isMobile()
                    ? showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (con) => CartBottomSheet(
                          product: product,
                          callback: (CartModel cartModel) {
                                                             showCustomNotification(context, 'enter_valid_email', isError: true);
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
                                  // showCustomSnackBar(
                                  //     getTranslated('added_to_cart', context),
                                  //     isError: false);
                                                                         showCustomNotification(context, 'enter_valid_email', isError: false);
                                },
                              ),
                            ));
              }
            : null,
        child: Center(
          child: Container(
            width: 354,
            height: 191,
            decoration: BoxDecoration(
              color: ColorResources.kmaincontainergrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.placeholderImage,
                        height: 144,
                        width: 354,
                        fit: BoxFit.cover,
                        image: productImage,
                        imageErrorBuilder: (c, o, s) => Image.asset(
                            Images.placeholderImage,
                            height: 144,
                            width: 354,
                            fit: BoxFit.cover),
                      ),
                    ),
                    if (!isAvailable)
                      Positioned(
                        top: 0,
                        left: 0,
                        bottom: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black.withOpacity(0.6)),
                          child: Text(
                            getTranslated('not_available_now_break', context)!,
                            textAlign: TextAlign.center,
                            style: rubikRegular.copyWith(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: WishButton(
                          product: product, edgeInset: const EdgeInsets.all(5)),
                    ),
                    if (product.discount != null &&
                        product.discountType == 'percent')
                      Positioned(
                        top: 100,
                        left: 4,
                        child: Container(
                          width: 35,
                          height: 35,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: ColorResources.kColorgreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${product.discount}%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Image.asset(
                        Images.group,
                        height: 18,
                        width: 25,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              product.name!,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        if (product.price! > discountedPrice!)
                          CustomDirectionality(
                            child: Text(
                              PriceConverter.convertPrice(startingPrice),
                              style: rubikMedium.copyWith(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.7),
                                decoration: TextDecoration.lineThrough,
                                fontSize: Dimensions.fontSizeExtraSmall,
                              ),
                            ),
                          ),
                        Row(
                          children: [
                            if (product.rating != null && product.rating!.isNotEmpty)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: ColorResources.kstarYellow,
                                    size: 9,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    ' ${product.rating![0].average}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                product.description!,
                                style: const TextStyle(fontSize: 8),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Spacer(),
                            CustomDirectionality(
                              child: Text(
                                PriceConverter.convertPrice(discountedPrice),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
