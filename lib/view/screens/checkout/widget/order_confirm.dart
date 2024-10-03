import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/screens/checkout/widget/confirm_button_view.dart';

void showDeliveryFeeDialog(
    BuildContext context, double deliveryCharge, double subtotal,
    {required ConfirmButtonView confirmButtonView}) {
  final double total = deliveryCharge + subtotal;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Images.deliveryman),
              const SizedBox(height: 16),
               Text(getTranslated('select_Address', context),   textAlign: TextAlign.center,
                style:const TextStyle(fontSize: 14),)
               ,
             
              // ),
              const SizedBox(height: 16),
              Text(
                '${deliveryCharge.toStringAsFixed(0)}QR',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorResources.kOrangeColor,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text(getTranslated('subtotal', context)),
                  Text('${subtotal.toStringAsFixed(0)} QR'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(getTranslated('delivery_fee', context)),
                  Text(
                      '${deliveryCharge.toStringAsFixed(2)} QR'), // Show delivery fee here
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(getTranslated('total', context)),
                  // const Text(
                  //   'Total',
                  //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  // ),
                  Text(
                    '${total.toStringAsFixed(2)} QR',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              confirmButtonView,
            ],
          ),
        ),
      );
    },
  );
}
