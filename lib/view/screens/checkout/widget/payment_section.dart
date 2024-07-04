import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_image.dart';
import 'package:flutter_restaurant/view/screens/checkout/widget/payment_method_bottom_sheet.dart';
import 'package:provider/provider.dart';

class PaymentWidget extends StatefulWidget {
  final double total;

  PaymentWidget({required this.total});

  @override
  _PaymentWidgetState createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  bool showDetails = false;

  void openDialog(BuildContext context) {
    if (!ResponsiveHelper.isMobile()) {
      showDialog(
        context: context,
        builder: (con) => PaymentMethodBottomSheet(totalPrice: widget.total),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (con) => PaymentMethodBottomSheet(totalPrice: widget.total),
      );
    }
  }

  void toggleDetails() {
    setState(() {
      showDetails = !showDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => toggleDetails(),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorResources.kColorgrey ,
                border: Border.all(color: ColorResources.klgreyColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.credit_score_outlined),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Add Payment Method',
                      style: TextStyle(
                        color: ColorResources.klgreyColor ?? Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => openDialog(context),
                    child: Icon(Icons.arrow_drop_down),
                  ),
                ],
              ),
            ),
          ),
          if (showDetails)
            SelectedPaymentView(total: widget.total),
        ],
      ),
    );
  }
}

class SelectedPaymentView extends StatelessWidget {
  final double total;

  SelectedPaymentView({required this.total});

  @override
  Widget build(BuildContext context) {
    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return Container(
      decoration: ResponsiveHelper.isDesktop(context)
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              color: Theme.of(context).cardColor,
              border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.3), width: 1),
            )
          : BoxDecoration(),
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.paddingSizeSmall,
        horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.radiusDefault : 0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              orderProvider.selectedOfflineMethod != null
                  ? Image.asset(
                      Images.offlinePayment,
                      width: 20,
                      height: 20,
                    )
                  : orderProvider.selectedPaymentMethod?.type == 'online'
                      ? CustomImage(
                          height: Dimensions.paddingSizeLarge,
                          image: '${configModel.baseUrls?.getWayImageUrl}/${orderProvider.paymentMethod?.getWayImage}',
                        )
                      : Image.asset(
                          orderProvider.selectedPaymentMethod?.type == 'cash_on_delivery'
                              ? Images.cashOnDelivery
                              : Images.walletPayment,
                          width: 20,
                          height: 20,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
              SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: Text(
                  orderProvider.selectedOfflineMethod != null
                      ? '${getTranslated('pay_offline', context)}   (${orderProvider.selectedOfflineMethod?.methodName})'
                      : orderProvider.selectedPaymentMethod!.getWayTitle ?? '',
                  // style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                ),
              ),
              Text(
                PriceConverter.convertPrice(total),
                textDirection: TextDirection.ltr,
                // style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          if (orderProvider.selectedOfflineValue != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeExtraLarge),
              child: Column(
                children: orderProvider.selectedOfflineValue!.map((method) => Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              method.keys.single,
                              // style: rubikRegular,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: Dimensions.paddingSizeSmall),
                          Flexible(
                            child: Text(
                              ' :  ${method.values.single}',
                              // style: rubikRegular,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
