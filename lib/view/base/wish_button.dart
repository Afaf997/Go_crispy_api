import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:provider/provider.dart';

class WishButton extends StatelessWidget {
  final Product? product;
  final EdgeInsetsGeometry edgeInset;
  final double iconSize;

  const WishButton({
    Key? key,
    required this.product,
    this.edgeInset = EdgeInsets.zero,
    this.iconSize = 18.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WishListProvider>(
      builder: (context, wishList, child) {
        bool isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

        return InkWell(
          onTap: () {
            if (wishList.wishIdList.contains(product!.id)) {
              wishList.removeFromWishList(product!, context, isLoggedIn);
            } else {
              wishList.addToWishList(product!, context, isLoggedIn);
            }
          },
          child: Padding(
            padding: edgeInset,
            child: Icon(
              wishList.wishIdList.contains(product!.id) ? Icons.favorite : Icons.favorite_border,
              size: iconSize,
              color: wishList.wishIdList.contains(product!.id) ? ColorResources.kredcolor : ColorResources.kfavouriteColor,
            ),
          ),
        );
      },
    );
  }
}
