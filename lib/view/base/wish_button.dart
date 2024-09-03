import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

class WishButton extends StatelessWidget {
  final Product? product;
  final EdgeInsetsGeometry edgeInset;
  final double iconSize;

  const WishButton({
    Key? key,
    required this.product,
    this.edgeInset = EdgeInsets.zero,
    this.iconSize = 24.0, // Default size is 24.0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WishListProvider>(
      builder: (context, wishList, child) {
        return InkWell(
          onTap: () {
            if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
              List<int?> productIdList = [];
              productIdList.add(product!.id);

              if (wishList.wishIdList.contains(product!.id)) {
                wishList.removeFromWishList(product!, context);
              } else {
                wishList.addToWishList(product!, context);
              }
            } else {
              
              showCustomNotification(context,getTranslated('now_you_are_in_guest_mode', context,),  type: NotificationType.warning);
            }
          },
          child: Padding(
            padding: edgeInset,
            child: Icon(
              wishList.wishIdList.contains(product!.id) ? Icons.favorite : Icons.favorite,
              size: iconSize, // Use the provided iconSize parameter
              color: wishList.wishIdList.contains(product!.id) ? ColorResources.kredcolor : ColorResources.kfavouriteColor,
            ),
          ),
        );
      },
    );
  }
}
