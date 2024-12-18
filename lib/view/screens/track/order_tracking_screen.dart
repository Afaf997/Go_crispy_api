import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/time_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/order_status.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/track/widget/custom_stepper.dart';
import 'package:flutter_restaurant/view/screens/track/widget/tracking_map_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widget/timer_view.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String? orderID;
  final String? phoneNumber;
  final OrderModel? orderModel;
  const OrderTrackingScreen(
      {Key? key, this.orderID, this.phoneNumber, this.orderModel})
      : super(key: key);

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  Future<void> _refreshOrder() async {
    final OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: false);
    final TimerProvider timerProvider =
        Provider.of<TimerProvider>(context, listen: false);

    if (widget.orderID != null) {
      await orderProvider.trackOrder(widget.orderID,
          fromTracking: true, phoneNumber: widget.phoneNumber);
      if (orderProvider.trackModel != null) {
        timerProvider.countDownTimer(orderProvider.trackModel!, context);
        if (orderProvider.trackModel?.deliveryMan != null) {
          orderProvider.getDeliveryManData(widget.orderID);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: false);
    final LocationProvider locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    if (widget.orderID != null) {
      locationProvider.initAddressList();
      orderProvider
          .trackOrder(widget.orderID,
              fromTracking: true, phoneNumber: widget.phoneNumber)
          .whenComplete(() {
        if (orderProvider.trackModel != null) {
          print("trdt");
          print(orderProvider.trackModel?.orderStatus ?? "test2");
          Provider.of<TimerProvider>(context, listen: false)
              .countDownTimer(orderProvider.trackModel!, context);
          if (orderProvider.trackModel?.deliveryMan != null) {
            orderProvider.getDeliveryManData(widget.orderID);
          }
        }
      });
    } else {
      orderProvider.clearPrevData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: ColorResources.kWhite,
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: WebAppBar(),
            )
          : CustomAppBar(
              title: getTranslated('track_order', context)!,
              centerTitle: true,
            ) as PreferredSizeWidget,
      body: RefreshIndicator(
        onRefresh: _refreshOrder, // The method to be called when refreshing
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(
            child:
                Consumer<OrderProvider>(builder: (context, orderProvider, _) {
              String? status;
              if (orderProvider.trackModel != null) {
                status = orderProvider.trackModel?.orderStatus;
                print(status ?? "testtt" + "statys");
              }
              return Container(
                margin: ResponsiveHelper.isDesktop(context)
                    ? EdgeInsets.symmetric(
                        horizontal: (width - Dimensions.webScreenWidth) / 2)
                    : null,
                decoration: ResponsiveHelper.isDesktop(context)
                    ? BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radiusDefault),
                      )
                    : null,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      child: Column(
                        children: [
                          if (widget.orderID != null)
                            if (status == OrderStatus.pending ||
                                status == OrderStatus.confirmed ||
                                status == OrderStatus.cooking ||
                                status == OrderStatus.processing ||
                                status == OrderStatus.outForDelivery)
                              const Column(
                                children: [
                                  SizedBox(
                                      height: Dimensions.paddingSizeDefault),
                                  TimerView(),
                                ],
                              ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          orderProvider.trackModel != null
                              ? Column(
                                  children: [
                                    const SizedBox(
                                        height: Dimensions.paddingSizeDefault),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${getTranslated('your_order', context)}',
                                            style: rubikMedium),
                                        Text(
                                            ' #${orderProvider.trackModel?.id}',
                                            style: rubikMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeLarge,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeLarge),
                                    Column(
                                      children: [
                                        CustomStepper(
                                          title: getTranslated(
                                              'order_placed', context),
                                          isComplete: status ==
                                                  OrderStatus.pending ||
                                              status == OrderStatus.confirmed ||
                                              status == OrderStatus.cooking ||
                                              status ==
                                                  OrderStatus.processing ||
                                              status ==
                                                  OrderStatus.outForDelivery ||
                                              status == OrderStatus.delivered,
                                          isActive:
                                              status == OrderStatus.pending,
                                          haveTopBar: false,
                                          statusImage: Images.icon1,
                                          subTitle:
                                              '${DateConverter.estimatedDate(DateConverter.convertStringToDatetime(orderProvider.trackModel!.createdAt!))} ${DateConverter.estimatedDate(DateConverter.convertStringToDatetime(orderProvider.trackModel!.createdAt!))}',
                                          iconColor:
                                              status == OrderStatus.pending
                                                  ? ColorResources.kOrangeColor
                                                  : Colors.grey,
                                        ),
                                        CustomStepper(
                                          title: getTranslated(
                                              'confirmed', context),
                                          isComplete: status ==
                                                  OrderStatus.confirmed ||
                                              status == OrderStatus.cooking ||
                                              status ==
                                                  OrderStatus.processing ||
                                              status ==
                                                  OrderStatus.outForDelivery ||
                                              status == OrderStatus.delivered,
                                          isActive:
                                              status == OrderStatus.confirmed,
                                          statusImage: Images.icon2,
                                          iconColor:
                                              status == OrderStatus.confirmed
                                                  ? ColorResources.kOrangeColor
                                                  : Colors.grey,
                                        ),
                                        CustomStepper(
                                          title:
                                              getTranslated('cooking', context),
                                          isComplete: status ==
                                                  OrderStatus.cooking ||
                                              status ==
                                                  OrderStatus.processing ||
                                              status ==
                                                  OrderStatus.outForDelivery ||
                                              status == OrderStatus.delivered,
                                          isActive:
                                              status == OrderStatus.cooking,
                                          statusImage: Images.icon3,
                                          iconColor:
                                              status == OrderStatus.cooking
                                                  ? ColorResources.kOrangeColor
                                                  : Colors.grey,
                                        ),
                                        CustomStepper(
                                          title: getTranslated(
                                              orderProvider.trackModel
                                                          ?.orderType ==
                                                      "delivery"
                                                  ? 'ready_for_delivery'
                                                  : 'Your order is ready',
                                              context),
                                          isComplete: status ==
                                                  OrderStatus.delivered ||
                                              status ==
                                                  OrderStatus.outForDelivery ||
                                              status == OrderStatus.delivered,
                                          statusImage: Images.icon4,
                                          isActive:
                                              status == OrderStatus.processing,
                                          subTitle: getTranslated(
                                              orderProvider.trackModel
                                                          ?.orderType ==
                                                      "delivery"
                                                  ? 'your_delivery_man_is_coming'
                                                  : 'Please collect your order',
                                              context),
                                          iconColor:
                                              status == OrderStatus.processing
                                                  ? ColorResources.kOrangeColor
                                                  : Colors.grey,
                                        ),
                                        Consumer<LocationProvider>(builder:
                                            (context, locationProvider, _) {
                                          AddressModel? address;
                                          if (locationProvider.addressList !=
                                              null) {
                                            for (int i = 0;
                                                i <
                                                    locationProvider
                                                        .addressList!.length;
                                                i++) {
                                              if (locationProvider
                                                      .addressList![i].id ==
                                                  orderProvider.trackModel!
                                                      .deliveryAddressId) {
                                                address = locationProvider
                                                    .addressList![i];
                                              }
                                            }
                                          }
                                          return Visibility(
                                            visible: orderProvider
                                                    .trackModel?.orderType ==
                                                "delivery",
                                            child: CustomStepper(
                                              title: getTranslated(
                                                  'order_is_on_the_way',
                                                  context),
                                              isComplete: status ==
                                                      OrderStatus
                                                          .outForDelivery ||
                                                  status ==
                                                      OrderStatus.delivered,
                                              statusImage: Images.icon5,
                                              height: orderProvider.trackModel
                                                          ?.deliveryMan ==
                                                      null
                                                  ? 30
                                                  : 130,
                                              isActive: status ==
                                                  OrderStatus.outForDelivery,
                                              trailing: orderProvider
                                                          .trackModel
                                                          ?.deliveryMan
                                                          ?.phone !=
                                                      null
                                                  ? InkWell(
                                                      onTap: () async {
                                                        Uri uri = Uri.parse(
                                                            'tel:${orderProvider.trackModel?.deliveryMan?.phone}');
                                                        if (await canLaunchUrl(
                                                            uri)) {
                                                          await launchUrl(uri);
                                                        }
                                                      },
                                                      child: const Icon(
                                                          Icons.phone_in_talk),
                                                    )
                                                  : const SizedBox(),
                                              iconColor: status ==
                                                      OrderStatus.outForDelivery
                                                  ? Colors.purple
                                                  : Colors.grey,
                                              child: orderProvider
                                                          .deliveryManModel !=
                                                      null
                                                  ? TrackingMapWidget(
                                                      deliveryManModel:
                                                          orderProvider
                                                              .deliveryManModel,
                                                      orderID:
                                                          '${orderProvider.trackModel?.id}',
                                                      addressModel: address,
                                                    )
                                                  : const SizedBox(),
                                            ),
                                          );
                                        }),
                                        Visibility(
                                          visible: orderProvider
                                                  .trackModel?.orderType ==
                                              "delivery",
                                          child: CustomStepper(
                                            title: getTranslated(
                                                'order_delivered', context),
                                            isComplete:
                                                status == OrderStatus.delivered,
                                            isActive:
                                                status == OrderStatus.delivered,
                                            statusImage: Images.icon6,
                                            iconColor:
                                                status == OrderStatus.delivered
                                                    ? Colors.green
                                                    : Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeLarge),
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    if (ResponsiveHelper.isDesktop(context)) const FooterView(),
                  ],
                ),
              );
            }),
          ),
        ]),
      ),
    );
  }
}
