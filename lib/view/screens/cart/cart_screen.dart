import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/branch_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/screens/branch/branch_list_screen.dart';
import 'package:flutter_restaurant/view/screens/cart/widget/cart_product_widget.dart';
import 'package:flutter_restaurant/view/screens/cart/widget/delivery_option_button.dart';
import 'package:flutter_restaurant/view/screens/cart/widget/item_view.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    Provider.of<OrderProvider>(context, listen: false).setOrderType(
      Provider.of<SplashProvider>(context, listen: false)
              .configModel!
              .homeDelivery!
          ? 'delivery'
          : 'take_away',
      notify: false,
    );
  }

  Widget _buildAdditionalUI(BuildContext context) {
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context);
    final bool isTakeAway = orderProvider.orderType == 'take_away';
    final bool isCarHop = orderProvider.orderType == 'car_hop';

    double verticalPadding = Dimensions.paddingSizeSmall;
    double horizontalPadding = Dimensions.paddingSizeSmall;
    double containerHeight = 40;

    if (isTakeAway || isCarHop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCarHop) ...[
            Padding(
              padding: EdgeInsets.symmetric(vertical: verticalPadding / 2),
              child: Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      "Vehicle Number",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: horizontalPadding),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: containerHeight,
                      padding: EdgeInsets.all(horizontalPadding / 1),
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorResources.klgreyColor),
                        borderRadius: BorderRadius.circular(15.0),
                        color: ColorResources.kColorgrey,
                      ),
                      child: TextField(
                        controller: orderProvider.vehicleNumberController,
                        textAlign: TextAlign.start, // Horizontally center tex
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: verticalPadding / 3),
              child: Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      "Select Store",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(width: horizontalPadding),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: containerHeight,
                      padding: EdgeInsets.all(horizontalPadding / 2),
                      decoration: BoxDecoration(
                        color: ColorResources.kColorgrey,
                        border: Border.all(color: ColorResources.klgreyColor),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<BranchProvider>(
                            builder: (context, branchProvider, _) {
                              if (branchProvider.getBranchId() == -1) {
                                return SizedBox();
                              }

                              List<Branches?> sortedBranches = List.from(branchProvider.branches);
                              sortedBranches.sort((a, b) {
                                if (a!.id == branchProvider.getBranchId()) return -1;
                                if (b!.id == branchProvider.getBranchId()) return 1;
                                return 0;
                              });

                              return Text(
                                sortedBranches.isNotEmpty ? sortedBranches[0]!.name ?? '' : '',
                                style: const TextStyle(
                                  color: ColorResources.kblack,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w800,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                useSafeArea: true,
                                builder: (context) {
                                  return const BranchListScreen(
                                    useNavigator: true,
                                    istakeAway: true,
                                  );
                                },
                              );
                            },
                            child: Image.asset(Images.mapicon),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (isTakeAway) ...[
            Padding(
              padding: EdgeInsets.symmetric(vertical: verticalPadding / 2),
              child: Row(
                children: [
                  const Text(
                    "Select Store",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: containerHeight,
                      padding: EdgeInsets.all(horizontalPadding / 2),
                      decoration: BoxDecoration(
                        color: ColorResources.kColorgrey,
                        border: Border.all(color: ColorResources.klgreyColor),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<BranchProvider>(
                            builder: (context, branchProvider, _) {
                              if (branchProvider.getBranchId() == -1) {
                                return SizedBox();
                              }

                              List<Branches?> sortedBranches = List.from(branchProvider.branches);
                              sortedBranches.sort((a, b) {
                                if (a!.id == branchProvider.getBranchId()) return -1;
                                if (b!.id == branchProvider.getBranchId()) return 1;
                                return 0;
                              });

                              return Text(
                                sortedBranches.isNotEmpty ? sortedBranches[0]!.name ?? '' : '',
                                style: const TextStyle(
                                  color: ColorResources.kblack,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w800,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                useSafeArea: true,
                                context: context,
                                builder: (context) {
                                  return const BranchListScreen(
                                    useNavigator: true,
                                    istakeAway: true,
                                  );
                                },
                              );
                            },
                            child: Image.asset(Images.mapicon),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    } else {
      return const SizedBox.shrink(); // Empty space if neither take away nor car hop is selected
    }
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorResources.kWhite,
      appBar: (CustomAppBar(
              context: context,
              title: getTranslated('my_cart', context),
              isBackButtonExist: !ResponsiveHelper.isMobile()))
          as PreferredSizeWidget?,
      body: Consumer<OrderProvider>(builder: (context, order, child) {
        return Consumer<CartProvider>(
          builder: (context, cart, child) {
            double? deliveryCharge = 0;
            (Provider.of<OrderProvider>(context, listen: false).orderType ==
                        'delivery' &&
                    Provider.of<SplashProvider>(context, listen: false)
                            .configModel!
                            .deliveryManagement!
                            .status ==
                        0)
                ? deliveryCharge =
                    Provider.of<SplashProvider>(context, listen: false)
                        .configModel!
                        .deliveryCharge
                : deliveryCharge = 0;
            List<List<AddOns>> addOnsList = [];
            List<bool> availableList = [];
            double itemPrice = 0;
            double discount = 0;
            double tax = 0;
            double addOns = 0;
            for (var cartModel in cart.cartList) {
              List<AddOns> addOnList = [];

              for (var addOnId in cartModel!.addOnIds!) {
                for (AddOns addOns in cartModel.product!.addOns!) {
                  if (addOns.id == addOnId.id) {
                    addOnList.add(addOns);
                    break;
                  }
                }
              }
              addOnsList.add(addOnList);

              availableList.add(DateConverter.isAvailable(
                  cartModel.product!.availableTimeStarts!,
                  cartModel.product!.availableTimeEnds!,
                  context));

              for (int index = 0; index < addOnList.length; index++) {
                addOns = addOns +
                    (addOnList[index].price! *
                        cartModel.addOnIds![index].quantity!);
              }
              itemPrice = itemPrice + (cartModel.price! * cartModel.quantity!);
              discount =
                  discount + (cartModel.discountAmount! * cartModel.quantity!);

              tax = tax + (cartModel.taxAmount! * cartModel.quantity!);
            }
            double subTotal = itemPrice + tax + addOns;
            double total = subTotal -
                discount -
                Provider.of<CouponProvider>(context).discount! +
                deliveryCharge!;
            double totalWithoutDeliveryFee = subTotal -
                discount -
                Provider.of<CouponProvider>(context).discount!;

            double orderAmount = itemPrice + addOns;

            // bool kmWiseCharge = Provider.of<SplashProvider>(context, listen: false).configModel!.deliveryManagement!.status == 1;

            return cart.cartList.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeLarge),
                            child: Center(
                                child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight:
                                      !ResponsiveHelper.isDesktop(context) &&
                                              height < 600
                                          ? height
                                          : height - 400),
                              child: SizedBox(
                                  width: 1170,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (ResponsiveHelper.isDesktop(context))
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeLarge,
                                              vertical:
                                                  Dimensions.paddingSizeLarge),
                                          child: CartListWidget(
                                              cart: cart,
                                              addOns: addOnsList,
                                              availableList: availableList),
                                        )),
                                      if (ResponsiveHelper.isDesktop(context))
                                        const SizedBox(
                                            width: Dimensions.paddingSizeLarge),
                                      Expanded(
                                          child: Container(
                                        decoration: ResponsiveHelper.isDesktop(
                                                context)
                                            ? BoxDecoration(
                                                color: Theme.of(context)
                                                    .canvasColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              )
                                            : const BoxDecoration(),
                                        margin:
                                            ResponsiveHelper.isDesktop(context)
                                                ? const EdgeInsets.symmetric(
                                                    horizontal: Dimensions
                                                        .paddingSizeSmall,
                                                    vertical: Dimensions
                                                        .paddingSizeLarge)
                                                : const EdgeInsets.all(0),
                                        padding:
                                            ResponsiveHelper.isDesktop(context)
                                                ? const EdgeInsets.symmetric(
                                                    horizontal: Dimensions
                                                        .paddingSizeLarge,
                                                    vertical: Dimensions
                                                        .paddingSizeLarge)
                                                : const EdgeInsets.all(0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Product
                                              if (!ResponsiveHelper.isDesktop(
                                                  context))
                                                CartListWidget(
                                                    cart: cart,
                                                    addOns: addOnsList,
                                                    availableList:
                                                        availableList),

                            
Consumer<CouponProvider>(
  builder: (context, coupon, child) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _couponController,
              style: rubikRegular,
              decoration: InputDecoration(
                hintText: getTranslated('enter_promo_code', context),
                hintStyle: rubikRegular.copyWith(
                  color: ColorResources.getHintColor(context),
                ),
                isDense: true,
                filled: true,
                enabled: coupon.discount == 0,
                fillColor: ColorResources.kColorgrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              if (!Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                showCustomNotification(
                  context,
                  'Please log in to apply a coupon',
                  type: NotificationType.warning,
                );
              } else {
                if (_couponController.text.isNotEmpty && !coupon.isLoading) {
                  if (coupon.discount! < 1) {
                    coupon.applyCoupon(_couponController.text, total).then(
                      (discount) {
                        if (discount! > 0) {
                          // Show success notification
                          showCustomNotification(
                            context,
                            'You got ${PriceConverter.convertPrice(discount)} discount!',
                            type: NotificationType.success,
                          );
                        } else {
                          showCustomNotification(
                            context,
                            getTranslated('invalid_code_or', context),
                            type: NotificationType.error,
                          );
                        }
                      },
                    );
                  } else {
                    coupon.removeCouponData(true);
                  }
                } else if (_couponController.text.isEmpty) {
                  showCustomNotification(
                    context,
                    'Enter a coupon code',
                    type: NotificationType.warning,
                  );
                }
              }
            },
            child: Container(
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: coupon.discount! <= 0
                  ? !coupon.isLoading
                      ? Text(
                          getTranslated('apply', context),
                          style: rubikMedium.copyWith(color: Colors.white),
                        )
                      : const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        )
                  : const Icon(Icons.clear, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  },
),


                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeLarge),
                                              Text(
                                                  getTranslated(
                                                      'delivery_option',
                                                      context),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeLarge),
                                              // Order type
                                              Row(
                                                children: [
                                                  // Delivery
                                                  Provider.of<SplashProvider>(
                                                              context,
                                                              listen: false)
                                                          .configModel!
                                                          .homeDelivery!
                                                      ? DeliveryOptionButton(
                                                          value: 'delivery',
                                                          title: getTranslated(
                                                              'delivery',
                                                              context),
                                                          imagePath: Images
                                                              .deliverySvg,
                                                        )
                                                      : Container(),

                                                  // Take Away
                                                  Provider.of<SplashProvider>(
                                                              context,
                                                              listen: false)
                                                          .configModel!
                                                          .selfPickup!
                                                      ? DeliveryOptionButton(
                                                          value: 'take_away',
                                                          title: getTranslated(
                                                              'take_away',
                                                              context),
                                                          imagePath: Images
                                                              .takeAwaySvg,
                                                        )
                                                      : Container(),

                                                  // Car Hop
                                                  Provider.of<SplashProvider>(
                                                              context,
                                                              listen: false)
                                                          .configModel!
                                                          .selfPickup!
                                                      ? DeliveryOptionButton(
                                                          value: 'car_hop',
                                                          title: getTranslated(
                                                              'Car Hop',
                                                              context),
                                                          imagePath:
                                                              Images.carHopSvg,
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 13,
                                              ),
                                              const Divider(
                                                color:
                                                    ColorResources.kDeliveryBox,
                                              ),

                                              _buildAdditionalUI(context),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              // Totals
                                              ItemView(
                                                title: getTranslated(
                                                    'items_price', context),
                                                subTitle:
                                                    PriceConverter.convertPrice(
                                                        itemPrice),
                                              ),
                                              const SizedBox(height: 10),

                                              ItemView(
                                                title: getTranslated(
                                                    'addons', context),
                                                subTitle:
                                                    PriceConverter.convertPrice(addOns),
                                              ),         const SizedBox(height: 10),
                                             ItemView(
                                                title: getTranslated(
                                                    'Discount ', context),
                                                  subTitle: PriceConverter.convertPrice(discount),
                                                  
                                              ),
                                              const SizedBox(height: 10),
                                              ItemView(
                                                title: getTranslated(
                                                    'delivery_fee', context)!,
                                                subTitle:
                                                    PriceConverter.convertPrice(
                                                        deliveryCharge),
                                              ),
                                              const Divider(
                                                color:
                                                    ColorResources.borderColor,
                                              ),
                                              ItemView(
                                                title: getTranslated(
                                                    'total_amount', context),
                                                subTitle:
                                                    PriceConverter.convertPrice(
                                                        total),
                                                titleStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                subTitleStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),

                                              if (ResponsiveHelper.isDesktop(
                                                  context))
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeDefault),

                                              if (ResponsiveHelper.isDesktop(
                                                  context))
                                                CheckOutButtonView(
                                                  orderAmount: orderAmount,
                                                  totalWithoutDeliveryFee:
                                                      totalWithoutDeliveryFee,
                                                ),
                                            ]),
                                      )),
                                    ],
                                  )),
                            )),
                          ),
                          if (ResponsiveHelper.isDesktop(context))
                            const FooterView(),
                        ]),
                      )),
                      if (!ResponsiveHelper.isDesktop(context))
                        CheckOutButtonView(
                          orderAmount: orderAmount,
                          totalWithoutDeliveryFee: totalWithoutDeliveryFee,
                        ),
                    ],
                  )
                : const NoDataScreen(isCart: true);
          },
        );
      }),
    );
  }
}

class CheckOutButtonView extends StatelessWidget {
  const CheckOutButtonView(
      {Key? key,
      required this.orderAmount,
      required this.totalWithoutDeliveryFee})
      : super(key: key);

  final double orderAmount;
  final double totalWithoutDeliveryFee;

  @override
  Widget build(BuildContext context) {
    ConfigModel configModel =
        Provider.of<SplashProvider>(context, listen: false).configModel!;
    return ((configModel.selfPickup ?? false) ||
            (configModel.homeDelivery ?? false))
        ? Container(
            width: 1170,
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: CustomButton(
                btnTxt: getTranslated('continue_checkout', context),
                onTap: () {
                  if (orderAmount <
                      Provider.of<SplashProvider>(context, listen: false)
                          .configModel!
                          .minimumOrderValue!) {
                     
                      showCustomNotification(context,'Minimum order amount is ${PriceConverter.convertPrice(Provider.of<SplashProvider>(context, listen: false).configModel!
                          .minimumOrderValue)}, you have ${PriceConverter.convertPrice(orderAmount)} in your cart, please add more item.');
                  } else {
                    RouterHelper.getCheckoutRoute(
                        totalWithoutDeliveryFee,
                        'cart',
                        Provider.of<OrderProvider>(context, listen: false)
                            .orderType,
                        Provider.of<CouponProvider>(context, listen: false)
                            .code);
                  }
                }),
          )
        : const SizedBox();
  }
}

class CartListWidget extends StatelessWidget {
  final CartProvider cart;
  final List<List<AddOns>> addOns;
  final List<bool> availableList;
  const CartListWidget(
      {Key? key,
      required this.cart,
      required this.addOns,
      required this.availableList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cart.cartList.length,
      itemBuilder: (context, index) {
        return CartProductWidget(
            cart: cart.cartList[index],
            cartIndex: index,
            addOns: addOns[index],
            isAvailable: availableList[index]);
      },
    );
  }
}
