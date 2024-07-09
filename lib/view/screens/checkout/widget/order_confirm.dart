import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/images.dart';

void showDeliveryFeeDialog(BuildContext context, double deliveryFee, double subtotal) {
  final double total = deliveryFee + subtotal;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: ColorResources.kWhite,
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
              const Text(
                'Delivery Fee from your selected address to the branch',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Text(
                '${deliveryFee.toStringAsFixed(2)} QR',
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
                  const Text('Subtotal'),
                  Text('${subtotal.toStringAsFixed(2)} QR'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Delivery fee'),
                  Text('${deliveryFee.toStringAsFixed(2)} QR'),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '${total.toStringAsFixed(2)} QR',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorResources.kOrangeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to the order success screen
                    // RouterHelper.orderSuccessScreen(context);
                  },
                  child: const Text(
                    'Okay',
                    style: TextStyle(color: ColorResources.kWhite, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
