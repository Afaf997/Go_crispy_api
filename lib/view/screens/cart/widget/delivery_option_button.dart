import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:provider/provider.dart';

class DeliveryOptionButton extends StatelessWidget {
  final String value;
  final String? title;
  final String imagePath; // New parameter for image path
  const DeliveryOptionButton({
    Key? key,
    required this.value,
    required this.title,
    required this.imagePath, // Updated constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        bool isSelected = order.orderType == value;

        return GestureDetector(
          onTap: () => order.setOrderType(value, notify: true),
          child: Container(
            width: 109, // Maintain specified width
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            margin: EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: ColorResources.kDeliveryBox,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? ColorResources.kOrangeColor : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  imagePath,
                  width: 24, // Adjust width as needed
                  height: 24, // Adjust height as needed
                  color: isSelected ? ColorResources.kOrangeColor : ColorResources.ktextgrey, // Color when selected
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    title!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected ? ColorResources.kOrangeColor : ColorResources.ktextgrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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
}
