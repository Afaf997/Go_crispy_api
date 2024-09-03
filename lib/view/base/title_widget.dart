import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';


class TitleWidget extends StatelessWidget {
  final String? title;
  final Function? onTap;

  const TitleWidget({Key? key, required this.title, this.onTap, required TextStyle textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title!, style:const TextStyle(fontSize: 20.0,
          fontWeight: FontWeight.w900,
          color: ColorResources.kblack,)),
      onTap != null && !ResponsiveHelper.isDesktop(context)? InkWell(
        onTap: onTap as void Function()?,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
          child: Text(
            getTranslated('see_all', context)!,
            style: TextStyle(fontSize: 12.0,
            fontWeight: FontWeight.w900,
            color: ColorResources.kredcolor,)
          ),
        ),
      ) : const SizedBox(),
    ]);
  }
}
