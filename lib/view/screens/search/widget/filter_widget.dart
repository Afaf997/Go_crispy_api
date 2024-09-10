import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/search_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FilterWidget extends StatelessWidget {
  final double? maxValue;
  const FilterWidget({Key? key, required this.maxValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Consumer<SearchProvider>(
        builder: (context, searchProvider, child) => SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with close and reset buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.close, size: 18, color: ColorResources.getGreyBunkerColor(context)),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      getTranslated('filter', context)!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        fontWeight: FontWeight.w600,
                        color: ColorResources.getGreyBunkerColor(context),
                      ),
                    ),
                  ),
                  Text(
                    getTranslated('reset', context)!,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ColorResources.kOrangeColor),
                  ),
                ],
              ),

              // Price filter section
              Text(
                getTranslated('price', context)!,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              RadioListTile<int>(
                title: Text(getTranslated('low to high', context)!,
                style: const TextStyle(fontSize: 14,),
                ),
                value: 2,
                groupValue: searchProvider.filterIndex,
                onChanged: (int? value) {
                  if (value != null) {
                    searchProvider.setFilterIndex(value);
                  }
                },
                activeColor: ColorResources.kOrangeColor,
              ),
              RadioListTile<int>(
                title: Text(getTranslated('high to low', context)!,
                style: const TextStyle(fontSize: 14,),
                ),
                value: 1,
                groupValue: searchProvider.filterIndex,
                onChanged: (int? value) {
                  if (value != null) {
                    searchProvider.setFilterIndex(value);
                  }
                },
                activeColor: ColorResources.kOrangeColor,
              ),

              const SizedBox(height: 20),
                Text(
                getTranslated('rating', context)!,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
                   const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SizedBox(
                  height: 30,
                  child: ListView.builder(
                    itemCount: 5,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Icon(
                          searchProvider.rating < (index + 1) ? Icons.star_border : Icons.star,
                          size: 20,
                          color: searchProvider.rating < (index + 1) ? Theme.of(context).hintColor.withOpacity(0.7) :ColorResources.kOrangeColor
                        ),
                        onTap: () => searchProvider.setRating(index + 1),
                      );
                    },
                  ),
                ),
              ),
                 const SizedBox(height: 15),
              Text(
                getTranslated('category', context)!,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 13),

              Consumer<CategoryProvider>(
                builder: (context, category, child) {
                  return category.categoryList != null
                      ? GridView.builder(
                          itemCount: category.categoryList!.length,
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : 3,
                              childAspectRatio: 3.0,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 12),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                category.updateSelectCategory(index);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: category.selectCategory == index
                                          ? ColorResources.klgreyColor
                                          : ColorResources.klgreyColor),
                                  borderRadius: BorderRadius.circular(7.0),
                                  color: category.selectCategory == index
                                      ? ColorResources.kOrangeColor
                                      : ColorResources.kColorgrey),
                                child: Text(
                                  category.categoryList![index].name!,
                                  textAlign: TextAlign.center,
                                  style: rubikMedium.copyWith(
                                    fontSize: ResponsiveHelper.isDesktop(context)
                                        ? Dimensions.fontSizeDefault
                                        : Dimensions.fontSizeExtraSmall,
                                    color: category.selectCategory == index
                                        ? Colors.white
                                        : ColorResources.getHintColor(context)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          },
                        )
                      : const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 30),

              CustomButton(
                btnTxt: getTranslated('apply', context),
                onTap: () {
                  searchProvider.sortSearchList(
                    Provider.of<CategoryProvider>(context, listen: false).selectCategory,
                    Provider.of<CategoryProvider>(context, listen: false).categoryList,
                  );

                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
