import 'package:flutter/material.dart';

class ItemView extends StatelessWidget {
  const ItemView({
    Key? key,
    required this.title,
    required this.subTitle,
    this.titleStyle,
    this.subTitleStyle,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: titleStyle ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        Text(
          subTitle,
          style: subTitleStyle ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
