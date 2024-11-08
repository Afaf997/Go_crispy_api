import 'package:flutter/material.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class CustomStepper extends StatelessWidget {
  final bool isActive;
  final bool isComplete;
  final bool haveTopBar;
  final String? title;
  final String? subTitle;
  final Widget? child;
  final double height;
  final String? statusImage;
  final Widget? trailing;
  final Color? iconColor; // Added icon color parameter

  const CustomStepper({
    Key? key,
    required this.title,
    required this.isActive,
    this.child,
    this.haveTopBar = true,
    this.height = 30,
    this.statusImage = Images.order,
    this.subTitle,
    required this.isComplete,
    this.trailing,
    this.iconColor, // Added icon color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (haveTopBar)
        Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 35),
              height: height,
            ),
            child == null ? const SizedBox() : child!,
          ],
        ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          height: 58,
          width: 61,
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(left: 6),
          decoration: BoxDecoration(
            border: Border.all(color: ColorResources.klgreyColor),
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            color: ColorResources.kColorgrey,
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Image.asset(
              statusImage!,
              width: 30,

              color: isComplete
                  ? ColorResources.kOrangeColor
                  : ColorResources.korgGrey, // Icon color is dynamic now
            ),
          ),
        ),
        title: Text(
          title!,
          style: rubikRegular.copyWith(
            fontSize: 14,
            color: isComplete
                ? ColorResources.kOrangeColor
                : ColorResources.korgGrey,
          ),
        ),
        subtitle: subTitle != null
            ? Text(subTitle!,
                style: const TextStyle(
                    fontSize: 12, color: ColorResources.korgGrey))
            : const SizedBox(),
      ),
    ]);
  }
}
