import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:flutter_restaurant/provider/set_menu_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';

class SetMenuView extends StatelessWidget {
  const SetMenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SetMenuProvider>(
      builder: (context, setMenu, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Text(getTranslated(
                'menu',context)!,
                style:const TextStyle(fontSize: 20.0,
          fontWeight: FontWeight.w900,
          color: ColorResources.kblack,),),
            ),
            SizedBox(
              height: 140,
              child: setMenu.setMenuList != null
                  ? setMenu.setMenuList!.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: setMenu.setMenuList!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Center(
                                child: Container(
                                  width: 78,
                                  height: 78,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Center(
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholderRectangle,
                                      width: 53,
                                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${setMenu.setMenuList![index].image}',
                                      imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                                        Images.placeholderRectangle,
                                        width: 53,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      :const Center(child: Text('No Set Menu Available'))
                  : const SetMenuShimmer(),
            ),
          ],
        );
      },
    );
  }
}

class SetMenuShimmer extends StatelessWidget {
  const SetMenuShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          width: 78,
          height: 78,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300]!,
                blurRadius: Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                spreadRadius: Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
              )
            ],
          ),
          child: Shimmer(
            duration: const Duration(seconds: 1),
            interval: const Duration(seconds: 1),
            enabled: Provider.of<SetMenuProvider>(context).setMenuList == null,
            child: Container(
              color: Theme.of(context).shadowColor,
            ),
          ),
        );
      },
    );
  }
}
