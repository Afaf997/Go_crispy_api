import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';

class CustomButton extends StatelessWidget {
  final Function? onTap;
  final String? btnTxt;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final double borderRadius;
  final double? width;
  final double? height;
  final bool transparent;
  final EdgeInsets? margin;
  final Color? textColor;
  final Color? borderColor; // Add this line for border color

  const CustomButton({
    Key? key, 
    this.onTap, 
    required this.btnTxt,
    this.backgroundColor, 
    this.textStyle,
    this.borderRadius = 10, 
    this.width, 
    this.transparent = false, 
    this.height, 
    this.margin,
    this.textColor,
    this.borderColor, // Add this line for border color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onTap == null 
        ? ColorResources.kOrangeColor
        : backgroundColor ?? ColorResources.kOrangeColor,
      minimumSize: Size(width ?? Dimensions.webScreenWidth, height ?? 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: borderColor != null ? BorderSide(color: borderColor!) : BorderSide.none, // Add border side
      ),
    );

    return Center(
      child: SizedBox(
        width: width ?? Dimensions.webScreenWidth,
        child: Padding(
          padding: margin ?? const EdgeInsets.all(0),
          child: TextButton(
            onPressed: onTap as void Function()?,
            style: flatButtonStyle,
            child: Text(
              btnTxt ?? '',
              style: textStyle?.copyWith(color: textColor) ??
                     Theme.of(context).textTheme.displaySmall!.copyWith(
                       color: textColor ?? Colors.white, 
                       fontSize: Dimensions.fontSizeLarge,
                     ),
            ),
          ),
        ),
      ),
    );
  }
}
