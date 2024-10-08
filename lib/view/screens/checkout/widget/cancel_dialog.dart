import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:go_router/go_router.dart';

class CancelDialog extends StatelessWidget {
  final int? orderID;
  const CancelDialog({Key? key, required this.orderID}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Container(
            height: 70, width: 70,
            decoration: BoxDecoration(
              color:  ColorResources.kOrangeColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color:  ColorResources.kOrangeColor, size: 50,
            ),
          ),
          //SizedBox(height: Dimensions.paddingSizeLarge),

          // fromCheckout ? Text(
          //   getTranslated('order_placed_successfully', context),
          //   style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color:  ColorResources.kOrangeColor,),
          // ) : SizedBox(),
          // SizedBox(height: fromCheckout ? Dimensions.paddingSizeSmall : 0),

        orderID != null ?   Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('${getTranslated('order_id', context)}:', style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Text(orderID.toString(), style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
          ]) : const SizedBox(),
          const SizedBox(height: 30),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.info, color:  ColorResources.kOrangeColor,),
            Text(
              getTranslated('payment_failed', context)!,
              style: rubikMedium.copyWith(color:  ColorResources.kOrangeColor,),
            ),
          ]),
          const SizedBox(height: 10),

          Text(
            getTranslated('payment_process_is_interrupted', context)!,
            style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          Row(children: [
            Expanded(child: SizedBox(
              height: 50,
              child: TextButton(
                onPressed: () {
                  RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 2, color:  ColorResources.kOrangeColor,)),
                ),
                child: Text(getTranslated('maybe_later', context)!, style: rubikBold.copyWith(color:  ColorResources.kOrangeColor,)),
              ),
            )),
           if(orderID != null) const SizedBox(width: 10),
           if(orderID != null) Expanded(child: CustomButton(btnTxt: 'Order Details', onTap: () {
              context.pop();
            })),
          ]),

        ]),
      ),
    );
  }
}
