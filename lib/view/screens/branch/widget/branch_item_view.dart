import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/branch_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

class BranchItemView extends StatelessWidget {
  final BranchValue? branchesValue;

  const BranchItemView({Key? key, this.branchesValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<BranchProvider>(
      builder: (context, branchProvider, _) {
        bool isSelected = branchProvider.selectedBranchId == branchesValue!.branches!.id;
        return GestureDetector(
          onTap: () {
            if (branchesValue!.branches!.status!) {
              branchProvider.updateBranchId(branchesValue!.branches!.id);
            } else {
              // showCustomSnackBar(
              //   '${branchesValue!.branches!.name} ${getTranslated('close_now', context)}',
              // );
            }
          },
          child: Stack(
            children: [
              Opacity(
                opacity: branchesValue!.branches!.status! ? 1 : 0.7,
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeExtraSmall,
                  ),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: isSelected ? ColorResources.kOrangeColor : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(Dimensions.radiusDefault),
                              topLeft: Radius.circular(Dimensions.radiusDefault),
                            ),
                            child: Stack(
                              children: [
                                FadeInImage.assetNetwork(
                                  placeholder: Images.branchBanner,
                                  image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.branchImageUrl}/${branchesValue!.branches!.coverImage}',
                                  fit: BoxFit.cover,
                                  width: Dimensions.webScreenWidth,
                                  height: 140.0, // Increased height
                                  imageErrorBuilder: (c, o, s) => Image.asset(
                                    Images.branchBanner,
                                    width: Dimensions.webScreenWidth,
                                    height: 100.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 250.0,
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(Dimensions.radiusDefault),
                                  bottomRight: Radius.circular(Dimensions.radiusDefault),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(70, 5, 0, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          branchesValue!.branches!.name!,
                                          style: rubikBold.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              size: 20,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              branchesValue!.branches!.address != null
                                                  ? branchesValue!.branches!.address!.length > 25
                                                      ? '${branchesValue!.branches!.address!.substring(0, 25)}...'
                                                      : branchesValue!.branches!.address!
                                                  : branchesValue!.branches!.name!,
                                              style: rubikMedium.copyWith(
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (branchesValue!.distance != -1)
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          branchesValue!.distance.toStringAsFixed(3),
                                          style: rubikMedium.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                          ),
                                        ),
                                        Text(
                                          '${getTranslated('km', context)}',
                                          style: rubikMedium.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 40),
                                          child: Text(
                                            getTranslated('away', context)!,
                                            style: rubikMedium.copyWith(
                                              fontSize: Dimensions.fontSizeSmall,
                                              color: Theme.of(context).disabledColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                        ],
                      ),
                      Positioned(
                        left: 10,
                        top: 115,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            border: Border.all(
                              color: ColorResources.kWhite,
                              width: 3,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholderImage,
                              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.branchImageUrl}/${branchesValue!.branches!.image}',
                              height: size.width < 400 ? 60 : 75, // Increased height
                              width: size.width < 400 ? 60 : 75, // Adjusted width for larger image
                              fit: BoxFit.cover,
                              imageErrorBuilder: (c, o, s) => Image.asset(
                                Images.placeholderImage,
                                width: size.width < 400 ? 50 : 65, // Adjusted width for larger image
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!branchesValue!.branches!.status!)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    border: Border.all(
                      color: isSelected ? ColorResources.kOrangeColor : Theme.of(context).primaryColor.withOpacity(0.1),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        border: Border.all(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.schedule_outlined,
                            color: Colors.white,
                            size: Dimensions.paddingSizeLarge,
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          Text(
                            getTranslated('close_now', context)!,
                            style: rubikRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
