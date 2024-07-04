import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerView extends StatefulWidget {
  const BannerView({Key? key}) : super(key: key);

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 15),
        Consumer<BannerProvider>(
          builder: (context, bannerProvider, child) {
            final bannerList = bannerProvider.bannerList;

            if (bannerList == null || bannerList.isEmpty) {
              return Center(
                child: Shimmer(
                  duration: const Duration(milliseconds: 800),
                  interval: const Duration(milliseconds: 300),
                  enabled: Provider.of<CategoryProvider>(context).categoryList == null,
                  color: Colors.grey[300]!,
                  direction: ShimmerDirection.fromLeftToRight(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 145,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Theme.of(context).shadowColor,
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: [
                CarouselSlider.builder(
                  itemCount: bannerList.length,
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                    final bannerItem = bannerList[itemIndex];
                    return InkWell(
                      onTap: () {
                        if (bannerItem.productId != null) {
                          // Handle product tap
                        } else if (bannerItem.categoryId != null) {
                          final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
                          final category = categoryProvider.categoryList?.firstWhere(
                            (category) => category.id == bannerItem.categoryId,
                            orElse: () => CategoryModel(),
                          );

                          if (category != null) {
                            RouterHelper.getCategoryRoute(category);
                          }
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(
                              bannerItem.image != null
                                  ? (bannerItem.image!.startsWith('http')
                                      ? bannerItem.image!
                                      : '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}/${bannerItem.image}')
                                  : Images.placeholderBanner,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 145,
                    viewportFraction: 1.0,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: bannerList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => setState(() {
                        _currentIndex = entry.key;
                      }),
                      child: Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == entry.key
                              ? const Color.fromRGBO(0, 0, 0, 0.9)
                              : const Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
