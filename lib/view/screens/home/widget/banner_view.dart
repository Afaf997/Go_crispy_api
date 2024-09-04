import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:provider/provider.dart';

class BannerView extends StatefulWidget {
  const BannerView({Key? key}) : super(key: key);

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  int _currentIndex = 0;
  final CarouselController _controller = CarouselController();

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
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 165,
                  // margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: SizedBox(
                      height: 165,
                      width: double.infinity,
                      child: Image.asset(Images.gif),
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: [
                CarouselSlider.builder(
                  carouselController: _controller,
                  itemCount: bannerList.length,
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                    final bannerItem = bannerList[itemIndex];
                    final imageUrl = bannerItem.image != null
                        ? (bannerItem.image!.startsWith('http')
                            ? bannerItem.image!
                            : '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}/${bannerItem.image}')
                        : Images.placeholderBanner;

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
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            height: 165,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return SizedBox(
                                  height: 165,
                                  
                                  width: double.infinity,
                                  child: Center(
                                    child: Image.asset(Images.gif), // Replace with your GIF path
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 170,
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
                      onTap: () => _controller.animateToPage(entry.key),
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
