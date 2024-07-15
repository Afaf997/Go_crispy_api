import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/screens/home/widget/category_pop_up.dart';
import 'package:provider/provider.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, category, child) {
        if (category.categoryList == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (category.categoryList!.isEmpty) {
          return Center(child: Text(getTranslated('no_category_available', context) ?? 'No category available'));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: TitleWidget(title: getTranslated('menu', context)),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 100, // Adjusted to provide extra space for the text
                      child: ListView.builder(
                        itemCount: category.categoryList!.length,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          String name = category.categoryList![index].name != null && category.categoryList![index].name!.length > 15
                              ? '${category.categoryList![index].name!.substring(0, 15)} ...'
                              : category.categoryList![index].name ?? '';

                          return Padding(
                            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                            child: InkWell(
                              onTap: () => RouterHelper.getCategoryRoute(category.categoryList![index]),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholderImage,
                                      width: 78,
                                      height: 78,
                                      fit: BoxFit.cover,
                                      image: Provider.of<SplashProvider>(context, listen: false).baseUrls != null
                                          ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}/${category.categoryList![index].image}'
                                          : '',
                                      imageErrorBuilder: (c, o, s) =>
                                          Image.asset(Images.placeholderImage, width: 78, height: 78, fit: BoxFit.cover),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (!ResponsiveHelper.isMobile())
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (con) => const Dialog(
                                child: SizedBox(height: 550, width: 600, child: CategoryPopUp()),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                            child: Container(
                              width: 78,
                              height: 78,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  getTranslated('view_all', context) ?? 'View all',
                                  style: const TextStyle(fontSize: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
