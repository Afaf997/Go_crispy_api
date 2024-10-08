import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class OrderCancelDialog extends StatelessWidget {
  final String orderID;
  final Function callback;
  const OrderCancelDialog({Key? key, required this.orderID, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
    backgroundColor: ColorResources.kWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        
        width: 300,
        child: Consumer<OrderProvider>(builder: (context, order, child) {
          return Column(mainAxisSize: MainAxisSize.min, children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: 50),
              child: Text(getTranslated('are_you_sure_to_cancel', context)!, style: rubikBold, textAlign: TextAlign.center),
            ),

            Divider(height: 0, color: ColorResources.getHintColor(context)),

            !order.isLoading ? Row(children: [

              Expanded(child: InkWell(
                onTap: () {
                  Provider.of<OrderProvider>(context, listen: false).cancelOrder(orderID, (String message, bool isSuccess, String orderID) {
                    context.pop();
                    callback(message, isSuccess, orderID);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                  child: Text(getTranslated('yes', context)!, style: rubikBold.copyWith(color:ColorResources.kOrangeColor)),
                ),
              )),

              Expanded(child: InkWell(
                onTap: () => context.pop(),
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  alignment: Alignment.center,
                  decoration:const BoxDecoration(color:ColorResources.kOrangeColor),
                  child: Text(getTranslated('no', context)!, style: rubikBold.copyWith(color: Colors.white)),
                ),
              )),

            ]) :const Center(child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ColorResources.kOrangeColor)),
            )),
          ]);
        },
        ),
      ),
    );
  }
}
