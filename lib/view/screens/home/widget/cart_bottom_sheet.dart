import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/language_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_directionality.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_zoom_widget.dart';
import 'package:flutter_restaurant/view/base/stock_tag_view.dart';
import 'package:flutter_restaurant/view/base/wish_button.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class CartBottomSheet extends StatefulWidget {
  final Product? product;
  final bool fromSetMenu;
  final Function? callback;
  final CartModel? cart;
  final int? cartIndex;
  final bool fromCart;

  const CartBottomSheet(
      {Key? key,
      required this.product,
      this.fromSetMenu = false,
      this.callback,
      this.cart,
      this.cartIndex,
      this.fromCart = false})
      : super(key: key);

  @override
  State<CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false)
        .initData(widget.product, widget.cart);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LanguageProvider languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    return Consumer<CartProvider>(builder: (context, cartProvider, child) {
      return Stack(
        children: [
          Container(
            width: 600,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: ColorResources.kWhite,
              borderRadius: ResponsiveHelper.isMobile()
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))
                  : const BorderRadius.all(Radius.circular(20)),
            ),
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                List<Variation>? variationList;
                List<Variation>? variationarList;
                double? price;

                if (widget.product!.branchProduct != null &&
                    widget.product!.branchProduct!.isAvailable!) {
                  variationList = languageProvider.selectIndex == 0
                      ? widget.product!.branchProduct?.variations
                      : widget.product!.branchProduct?.variationsar;
                  // variationarList = widget.product!.branchProduct!.variationsar;
                  price = widget.product!.branchProduct!.price;
                  log('Using branch product variations');
                } else {
                  variationList = languageProvider.selectIndex == 0
                      ? widget.product!.variations
                      : widget.product!.variationsar;
                  variationarList = widget.product!.variationsar;
                  price = widget.product!.price;
                }

                double variationPrice = 0;

                if (variationList != null && variationList.isNotEmpty) {
                  for (int index = 0; index < variationList.length; index++) {
                    if (variationList[index].variationValues != null &&
                        variationList[index].variationValues!.isNotEmpty) {
                      if (productProvider.selectedVariations.length <= index) {
                        productProvider.selectedVariations.add(
                          List<bool>.filled(
                              variationList[index].variationValues!.length,
                              false),
                        );
                      }
                      for (int i = 0;
                          i < variationList[index].variationValues!.length &&
                              i <
                                  productProvider
                                      .selectedVariations[index].length;
                          i++) {
                        if (productProvider.selectedVariations[index][i]!) {
                          variationPrice += variationList[index]
                              .variationValues![i]
                              .optionPrice!;
                        }
                      }
                    } else {
                      debugPrint(
                          'Variation values for index $index are empty or null');
                    }
                  }
                } else {
                  debugPrint('Variation list is empty or null');
                }

                double? discount = widget.product!.discount;
                String? discountType = widget.product!.discountType;
                double priceWithDiscount = PriceConverter.convertWithDiscount(
                    price, discount, discountType)!;

                double addonsCost = 0;
                double addonsTax = 0;
                List<AddOn> addOnIdList = [];
                List<AddOns> addOnsList = [];
                for (int index = 0;
                    index < widget.product!.addOns!.length;
                    index++) {
                  if (productProvider.addOnActiveList[index]) {
                    double itemPrice = widget.product!.addOns![index].price! *
                        productProvider.addOnQtyList[index]!;
                    addonsCost += itemPrice;
                    addonsTax += (itemPrice -
                        PriceConverter.convertWithDiscount(
                            itemPrice,
                            widget.product!.addOns![index].tax ?? 0,
                            'percent')!);
                    addOnIdList.add(AddOn(
                        id: widget.product!.addOns![index].id,
                        quantity: productProvider.addOnQtyList[index]));
                    addOnsList.add(widget.product!.addOns![index]);
                  }
                }

// Calculate subtotal without discount
                double priceWithAddonsVariationWithoutDiscount =
                    (price! + variationPrice) * productProvider.quantity! +
                        addonsCost;

// Calculate total price with variations and add-ons, applying discount
                double priceWithAddonsVariation = addonsCost +
                    (PriceConverter.convertWithDiscount(
                            variationPrice + price!, discount, discountType)! *
                        productProvider.quantity!);

// Total price including variations
                double priceWithVariation = price + variationPrice;

// Availability check
                bool isAvailable = DateConverter.isAvailable(
                    widget.product!.availableTimeStarts!,
                    widget.product!.availableTimeEnds!,
                    context);

// Creating the CartModel
                CartModel cartModel = CartModel(
                  priceWithVariation,
                  priceWithDiscount,
                  [],
                  (priceWithVariation -
                      PriceConverter.convertWithDiscount(
                          priceWithVariation, discount, discountType)!),
                  productProvider.quantity,
                  (priceWithVariation -
                      PriceConverter.convertWithDiscount(priceWithVariation,
                          widget.product!.tax, widget.product!.taxType)! +
                      addonsTax),
                  addOnIdList,
                  widget.product,
                  productProvider.selectedVariations,
                );

                cartProvider.isExistInCart(widget.product?.id, null);

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(ResponsiveHelper.isMobile()
                              ? 0
                              : Dimensions.paddingSizeExtraLarge),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Product
                                _productView(
                                  context,
                                  price,
                                  priceWithDiscount,
                                ),

                                const SizedBox(
                                    height: Dimensions.paddingSizeLarge),

                                // Quantity
                                ResponsiveHelper.isMobile()
                                    ? Column(
                                        children: [
                                          _quantityView(context),
                                          const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeLarge),
                                        ],
                                      )
                                    : CartProductDescription(
                                        product: widget.product!),

                                ///Variations
                                variationList!.isNotEmpty
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: variationList.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          variationList![index]
                                                                  .name ??
                                                              '',
                                                          style: rubikMedium.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeLarge)),
                                                      CustomDirectionality(
                                                          child: Text(
                                                        ' (${getTranslated(variationList[index].isRequired! ? 'required' : 'optional', context)}) ',
                                                        style: rubikMedium.copyWith(
                                                            color: ColorResources
                                                                .kOrangeColor,
                                                            fontSize: Dimensions
                                                                .fontSizeSmall),
                                                      )),
                                                    ]),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeExtraSmall),
                                                Row(children: [
                                                  variationList[index]
                                                          .isMultiSelect!
                                                      ? Text(
                                                          '${getTranslated('you_need_to_select_minimum', context)} ${'${variationList[index].min}'
                                                              ' ${getTranslated('to_maximum', context)} ${variationList[index].max} ${getTranslated('options', context)}'}',
                                                          style: rubikMedium.copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeExtraSmall,
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor),
                                                        )
                                                      : const SizedBox(),
                                                ]),
                                                SizedBox(
                                                    height: variationList[index]
                                                            .isMultiSelect!
                                                        ? Dimensions
                                                            .paddingSizeExtraSmall
                                                        : 0),
                                            ListView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  padding: EdgeInsets.zero,
  itemCount: variationList[index].variationValues!.length,
  itemBuilder: (context, i) {
    if (i >= productProvider.selectedVariations.length ||
        productProvider.selectedVariations[index].length <= i) {
      return Container(); // Handle invalid index
    }
    
    return InkWell(
      onTap: () {
        productProvider.setCartVariationIndex(
            index, i, widget.product, variationList![index].isMultiSelect!);
      },
      child: Row(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              variationList![index].isMultiSelect!
                  ? Checkbox(
                      value: productProvider.selectedVariations[index][i],
                      activeColor: ColorResources.kOrangeColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                      onChanged: (bool? newValue) {
                        productProvider.setCartVariationIndex(
                          index,
                          i,
                          widget.product,
                          variationList![index].isMultiSelect!,
                        );
                      },
                      visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                    )
                  : Radio(
                      value: i,
                      groupValue: productProvider.selectedVariations[index].indexOf(true),
                      onChanged: (dynamic value) {
                        productProvider.setCartVariationIndex(
                          index,
                          i,
                          widget.product,
                          variationList![index].isMultiSelect!,
                        );
                      },
                      activeColor: ColorResources.kOrangeColor,
                      toggleable: false,
                      visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                    ),
              Text(
                variationList[index].variationValues![i].level!.trim(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: productProvider.selectedVariations[index][i]!
                    ? rubikMedium
                    : robotoRegular,
              ),
            ],
          ),
          const Spacer(),
          CustomDirectionality(
            child: Text(
              variationList[index].variationValues![i].optionPrice! > 0
                  ? '+${PriceConverter.convertPrice(variationList[index].variationValues![i].optionPrice)}'
                  : 'free',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: productProvider.selectedVariations[index][i]!
                  ? rubikMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall)
                  : robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: Theme.of(context).disabledColor,
                    ),
            ),
          ),
        ],
      ),
    );
  },
),

                                                SizedBox(
                                                    height: index !=
                                                            variationList
                                                                    .length -
                                                                1
                                                        ? Dimensions
                                                            .paddingSizeLarge
                                                        : 0),
                                              ]);
                                        },
                                      )
                                    : const SizedBox(),
                                SizedBox(
                                    height: (variationList.isNotEmpty)
                                        ? Dimensions.paddingSizeLarge
                                        : 0),

                                if (ResponsiveHelper.isMobile())
                                  CartProductDescription(
                                      product: widget.product!),

                                // Addons
                                _addonsView(context, productProvider),

                                Row(children: [
                                  Text(
                                      '${getTranslated('total_amount', context)}:',
                                      style: rubikMedium.copyWith(
                                          fontSize: Dimensions.fontSizeLarge)),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  CustomDirectionality(
                                    child: Text(
                                        PriceConverter.convertPrice(
                                            priceWithAddonsVariation),
                                        style: rubikBold.copyWith(
                                          color: ColorResources.kOrangeColor,
                                          fontSize: Dimensions.fontSizeLarge,
                                        )),
                                  ),
                                  const SizedBox(
                                    width: Dimensions.paddingSizeSmall,
                                  ),
                                  (priceWithAddonsVariationWithoutDiscount >
                                          priceWithAddonsVariation)
                                      ? CustomDirectionality(
                                          child: Text(
                                          '(${PriceConverter.convertPrice(priceWithAddonsVariationWithoutDiscount)})',
                                          style: rubikMedium.copyWith(
                                            color:
                                                Theme.of(context).disabledColor,
                                            fontSize: Dimensions.fontSizeSmall,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ))
                                      : const SizedBox(),
                                ]),
                                const SizedBox(
                                    height: Dimensions.paddingSizeLarge),
                                //Add to cart Button
                                if (ResponsiveHelper.isDesktop(context))
                                  _cartButton(isAvailable, context, cartModel,
                                      variationList),
                              ]),
                        ),
                      ),
                    ),
                    _cartButton(isAvailable, context, cartModel, variationList),
                  ],
                );
              },
            ),
          ),
          ResponsiveHelper.isMobile()
              ? const SizedBox()
              : Positioned(
                  right: 10,
                  top: 5,
                  child: InkWell(
                      onTap: () => context.pop(),
                      child: const Icon(Icons.close)),
                ),
        ],
      );
    });
  }

  Widget _addonsView(BuildContext context, ProductProvider productProvider) {
    return widget.product!.addOns!.isNotEmpty
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(getTranslated('addons', context)!,
                style:
                    rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
                childAspectRatio: (1 / 1.1),
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.product!.addOns!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (!productProvider.addOnActiveList[index]) {
                      productProvider.addAddOn(true, index);
                    } else if (productProvider.addOnQtyList[index] == 1) {
                      productProvider.addAddOn(false, index);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        bottom:
                            productProvider.addOnActiveList[index] ? 2 : 20),
                    decoration: BoxDecoration(
                      color: productProvider.addOnActiveList[index]
                          ? ColorResources.kOrangeColor
                          : Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: productProvider.addOnActiveList[index]
                          ? [
                              BoxShadow(
                                color: Theme.of(context).shadowColor,
                                blurRadius: Provider.of<ThemeProvider>(context)
                                        .darkTheme
                                    ? 2
                                    : 5,
                                spreadRadius:
                                    Provider.of<ThemeProvider>(context)
                                            .darkTheme
                                        ? 0
                                        : 1,
                              )
                            ]
                          : null,
                    ),
                    child: Column(children: [
                      Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Text(widget.product!.addOns![index].name!,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: rubikMedium.copyWith(
                                  color: productProvider.addOnActiveList[index]
                                      ? Colors.white
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                  fontSize: Dimensions.fontSizeSmall,
                                )),
                            const SizedBox(height: 5),
                            CustomDirectionality(
                                child: Text(
                              PriceConverter.convertPrice(
                                  widget.product!.addOns![index].price),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: rubikRegular.copyWith(
                                  color: productProvider.addOnActiveList[index]
                                      ? Colors.white
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                  fontSize: Dimensions.fontSizeExtraSmall),
                            )),
                          ])),
                      productProvider.addOnActiveList[index]
                          ? Container(
                              height: 25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Theme.of(context).cardColor),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          if (productProvider
                                                  .addOnQtyList[index]! >
                                              1) {
                                            productProvider.setAddOnQuantity(
                                                false, index);
                                          } else {
                                            productProvider.addAddOn(
                                                false, index);
                                          }
                                        },
                                        child: const Center(
                                            child:
                                                Icon(Icons.remove, size: 15)),
                                      ),
                                    ),
                                    Text(
                                        productProvider.addOnQtyList[index]
                                            .toString(),
                                        style: rubikMedium.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeSmall)),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => productProvider
                                            .setAddOnQuantity(true, index),
                                        child: const Center(
                                            child: Icon(Icons.add, size: 15)),
                                      ),
                                    ),
                                  ]),
                            )
                          : const SizedBox(),
                    ]),
                  ),
                );
              },
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          ])
        : const SizedBox();
  }

  Widget _quantityView(
    BuildContext context,
  ) {
    return Row(children: [
      Text(getTranslated('quantity', context)!,
          style:
              rubikMedium.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
      const Expanded(child: SizedBox()),
      _quantityButton(context),
    ]);
  }

  Widget _cartButton(bool isAvailable, BuildContext context,
      CartModel cartModel, List<Variation>? variationList) {
    return Column(
      children: [
        // Show 'Not Available' message if the product is unavailable
        isAvailable
            ? const SizedBox()
            : Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                margin:
                    const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorResources.kOrangeColor,
                ),
                child: Column(
                  children: [
                    Text(
                      getTranslated('not_available_now', context)!,
                      style: rubikMedium.copyWith(
                        color: ColorResources.kOrangeColor,
                        fontSize: Dimensions.fontSizeLarge,
                      ),
                    ),
                    Text(
                      '${getTranslated('available_will_be', context)} ${DateConverter.convertTimeToTime(widget.product!.availableTimeStarts!, context)} '
                      '- ${DateConverter.convertTimeToTime(widget.product!.availableTimeEnds!, context)}',
                      style: rubikRegular,
                    ),
                  ],
                ),
              ),

        // Show the 'Add to Cart' or 'Update in Cart' button if the product is available
        if (isAvailable)
          Consumer<ProductProvider>(
            builder: (context, productProvider, _) {
              final CartProvider cartProvider =
                  Provider.of<CartProvider>(context, listen: false);
              int quantity =
                  cartProvider.getCartProductQuantityCount(widget.product!);

              return CustomButton(
                btnTxt: getTranslated(
                    widget.cart != null ? 'update_in_cart' : 'add_to_cart',
                    context),
                backgroundColor: ColorResources.kOrangeColor,
                onTap: widget.cart == null &&
                        !productProvider.checkStock(widget.product!,
                            quantity: quantity)
                    ? null
                    : () {
                        // Check variations if applicable
                        if (variationList != null) {
                          for (int index = 0;
                              index < variationList.length;
                              index++) {
                            if (!variationList[index].isMultiSelect! &&
                                variationList[index].isRequired! &&
                                !productProvider.selectedVariations[index]
                                    .contains(true)) {
                              showCustomNotification(
                                context,
                                '${getTranslated('choose_a_variation_from', context)} ${variationList[index].name}',
                                type: NotificationType.error,
                              );
                              return;
                            } else if (variationList[index].isMultiSelect! &&
                                (variationList[index].isRequired! ||
                                    productProvider.selectedVariations[index]
                                        .contains(true)) &&
                                variationList[index].min! >
                                    productProvider.selectedVariationLength(
                                        productProvider.selectedVariations,
                                        index)) {
                              showCustomNotification(
                                context,
                                '${getTranslated('you_need_to_select_minimum', context)} ${variationList[index].min} '
                                '${getTranslated('to_maximum', context)} ${variationList[index].max} ${getTranslated('options_from', context)} ${variationList[index].name} ${getTranslated('variation', context)}',
                                type: NotificationType.error,
                              );
                              return;
                            }
                          }
                        }

                        context.pop();

                        // Add to cart or update cart logic
                        if (widget.cart != null) {
                          // If updating an existing item in the cart
                          Provider.of<CartProvider>(context, listen: false)
                              .addToCart(
                            cartModel,
                            widget.cartIndex,
                          );

                          // Show notification for updating the cart
                          showCustomNotification(
                            context,
                            getTranslated('already_added_in_cart', context),
                            type: NotificationType.error,
                          );
                        } else {
                          Provider.of<CartProvider>(context, listen: false)
                              .addToCart(
                            cartModel,
                            productProvider.cartIndex,
                          );
                          showCustomNotification(
                            context,
                            getTranslated('added_to_cart', context),
                            type: NotificationType.success,
                          );
                        }
                      },
              );
            },
          ),
      ],
    );
  }

  Widget _productView(
    BuildContext context,
    double price,
    double priceWithDiscount,
  ) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: ResponsiveHelper.isDesktop(context)
                ? null
                : () => RouterHelper.getProductImageScreen(
                    widget.product ?? widget.cart!.product!),
            child: CustomZoomWidget(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.placeholderRectangle,
                      image:
                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${widget.product!.image}',
                      width: ResponsiveHelper.isMobile()
                          ? 136
                          : ResponsiveHelper.isTab(context)
                              ? 136
                              : ResponsiveHelper.isDesktop(context)
                                  ? 136
                                  : null,
                      height: ResponsiveHelper.isMobile()
                          ? 108
                          : ResponsiveHelper.isTab(context)
                              ? 108
                              : ResponsiveHelper.isDesktop(context)
                                  ? 108
                                  : null,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (c, o, s) => Image.asset(
                        Images.placeholderRectangle,
                        width: ResponsiveHelper.isMobile()
                            ? 136
                            : ResponsiveHelper.isTab(context)
                                ? 136
                                : ResponsiveHelper.isDesktop(context)
                                    ? 136
                                    : null,
                        height: ResponsiveHelper.isMobile()
                            ? 108
                            : ResponsiveHelper.isTab(context)
                                ? 108
                                : ResponsiveHelper.isDesktop(context)
                                    ? 108
                                    : null,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  StockTagView(product: widget.product!),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      // Use Expanded to allow the Text to take available space
                      child: Row(
                        children: [
                          Expanded(
                            // Wrap Text with Expanded to enable multi-line
                            child: Text(
                              widget.product!.name!,
                              maxLines: 3, // Set to 2 lines
                              overflow: TextOverflow.ellipsis,
                              style: rubikMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (ResponsiveHelper.isMobile())
                            WishButton(
                              product: widget.product,
                              iconSize: 16,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: ColorResources.kstarYellow,
                      size: 10,
                    ),
                    Text(
                      widget.product!.rating!.isNotEmpty
                          ? double.parse(widget.product!.rating![0].average!)
                              .toStringAsFixed(1)
                          : '0.0',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    widget.product!.productType != null
                        ? VegTagView(product: widget.product!)
                        : const SizedBox(),
                  ],
                ),

                // const SizedBox(height: 20),
                Text(
                  widget.product!.description!,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: rubikMedium.copyWith(
                    fontSize: Dimensions.fontExtraSmall,
                    fontWeight: FontWeight.w400,
                    color: ColorResources.kIncreasedColor,
                  ),
                ),

                Row(mainAxisSize: MainAxisSize.min, children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          child: CustomDirectionality(
                            child: Text(
                              PriceConverter.convertPrice(
                                price,
                                discount: widget.product!.discount,
                                discountType: widget.product!.discountType,
                              ),
                              style: rubikMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis,
                                color: ColorResources.kOrangeColor,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: Dimensions.paddingSizeSmall,
                        ),
                        price > priceWithDiscount
                            ? FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: CustomDirectionality(
                                    child: Text(
                                      PriceConverter.convertPrice(price),
                                      style: rubikMedium.copyWith(
                                        color: Theme.of(context)
                                            .hintColor
                                            .withOpacity(0.7),
                                        decoration: TextDecoration.lineThrough,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ]),
                if (!ResponsiveHelper.isMobile()) _quantityView(context),
              ],
            ),
          ),
        ]);
  }

  Widget _quantityButton(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    return Container(
      decoration: const BoxDecoration(
          color: ColorResources.kradiuscolor,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Row(children: [
        InkWell(
          onTap: () => productProvider.quantity! > 1
              ? productProvider.setQuantity(false)
              : null,
          child: const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall,
                vertical: Dimensions.paddingSizeExtraSmall),
            child: Icon(Icons.remove, size: 14),
          ),
        ),
        Text(productProvider.quantity.toString(),
            style: rubikMedium.copyWith(fontSize: 14)),
        InkWell(
          onTap: () {
            final CartProvider cartProvider =
                Provider.of<CartProvider>(context, listen: false);
            int quantity =
                cartProvider.getCartProductQuantityCount(widget.product!);
            if (productProvider.checkStock(
              widget.cart != null ? widget.cart!.product! : widget.product!,
              quantity: (productProvider.quantity ?? 0) + quantity,
            )) {
              productProvider.setQuantity(true);
            } else {
              showCustomNotification(
                  context, getTranslated('out_of_stock', context),
                  type: NotificationType.error);
            }
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall,
                vertical: Dimensions.paddingSizeExtraSmall),
            child: Icon(Icons.add, size: 14),
          ),
        ),
      ]),
    );
  }
}

class CartProductDescription extends StatelessWidget {
  const CartProductDescription({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return product.description != null && product.description!.isNotEmpty
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: Dimensions.paddingSizeLarge),
          ])
        : const SizedBox();
  }
}

class VegTagView extends StatelessWidget {
  final Product? product;
  const VegTagView({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(builder: (context, splashProvider, _) {
      return Visibility(
        visible: splashProvider.configModel!.isVegNonVegActive!,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: SizedBox(
            height: 30,
            child: Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: Image.asset(
                    Images.getImageUrl(
                      '${product!.productType}',
                    ),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text(
                  getTranslated('${product!.productType}', context)!,
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall),
                ),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              ],
            ),
          ),
        ),
      );
    });
  }
}
