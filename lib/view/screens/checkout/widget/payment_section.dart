import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/images.dart';
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
        barrierColor: ColorResources.kWhite,
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
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, _) {
        bool showPayment = orderProvider.selectedPaymentMethod != null ||
            (orderProvider.selectedOfflineValue != null && orderProvider.isOfflineSelected);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             Text(getTranslated('payment_method', context)!, style:TextStyle(fontSize: 16,fontWeight:FontWeight.w700)),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorResources.kColorgrey,
                  border: Border.all(color: ColorResources.klgreyColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onTap: () => openDialog(context),
                  child: Row(
                    children: [
                      Image.asset(Images.cardTick),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          showPayment
                              ? orderProvider.selectedOfflineMethod != null
                                  ? '${getTranslated('pay_offline', context)} (${orderProvider.selectedOfflineMethod?.methodName})'
                                  : orderProvider.selectedPaymentMethod?.getWayTitle ?? getTranslated('add_payment_method', context)
                              : getTranslated('add_payment_method', context),
                          style:const  TextStyle(
                            color: ColorResources.kblack,
                            fontWeight: FontWeight.w500,
                            fontSize: 14
                          ),
                        ),
                      ),
                     const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
