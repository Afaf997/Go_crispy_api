import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_divider.dart';
import 'package:flutter_restaurant/view/screens/cart/cart_screen.dart';
import 'package:flutter_restaurant/view/screens/cart/widget/item_view.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/js_util.dart';

class CostPriceView extends StatelessWidget {
  final double? deliveryCharge;
  final double? subtotal;
  const CostPriceView({
    Key? key,
    this.deliveryCharge, this.subtotal,

  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    final OrderProvider orderProvider =  Provider.of<OrderProvider>(context, listen: false);

    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal:16),
        child: Column(children: [

          if(ResponsiveHelper.isDesktop(context)) Text(
            getTranslated('cost_summery', context)!,
            style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          ItemView(
            title: getTranslated('subtotal', context,)!,
            subTitle: PriceConverter.convertPrice(subtotal),
          ),
          const SizedBox(height: 10),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            child: Divider(color: ColorResources.borderColor,),
          ),

         if(ResponsiveHelper.isDesktop(context)) ItemView(
            title: getTranslated('total_amount', context)!,
            titleStyle:const  TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
            subTitle: PriceConverter.convertPrice(subtotal! + deliveryCharge!),
            subTitleStyle:const TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
          ),
        ]),
      ),

    ]);
  }
}
