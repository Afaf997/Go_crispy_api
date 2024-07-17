import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/search_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_container.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/filter_button_widget.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/base/wish_button.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_web_card_shimmer.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_widget_web.dart';
import 'package:flutter_restaurant/view/screens/search/widget/filter_widget.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatefulWidget {
  final String? searchString;

  const SearchResultScreen({Key? key, required this.searchString}) : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _type = 'all';

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchString!.replaceAll('-', ' ');
    Provider.of<SearchProvider>(context, listen: false).saveSearchAddress(_searchController.text);
    Provider.of<SearchProvider>(context, listen: false).searchProduct(_searchController.text, context);
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      backgroundColor: ColorResources.kWhite,
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: WebAppBar(),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Center(
                child: SizedBox(
                  width: 1170,
                  child: Row(
                    children: [
                      ResponsiveHelper.isDesktop(context)
                          ? SizedBox()
                          : Expanded(
                              child: CustomTextField(
                                hintText: getTranslated('search_items_here', context),
                                isShowBorder: true,
                                isShowSuffixIcon: true,
                                suffixIconUrl: Images.filter,
                                controller: _searchController,
                                isShowPrefixIcon: false,
                                prefixIconUrl: Images.search,
                                inputAction: TextInputAction.search,
                                isIcon: true,
                                onSubmit: (value) {
                                  searchProvider.saveSearchAddress(value);
                                  searchProvider.searchProduct(value, context);
                                },
                                onSuffixTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      List<double?> prices = [];
                                      for (var product in searchProvider.filterProductList!) {
                                        prices.add(product.price);
                                      }
                                      prices.sort();
                                      double? maxValue = prices.isNotEmpty ? prices[prices.length - 1] : 1000;
                                      return Dialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                        child: SizedBox(width: 550, child: FilterWidget(maxValue: maxValue)),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                      SizedBox(width: 12),
                      ResponsiveHelper.isDesktop(context)
                          ? SizedBox()
                          : InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (searchProvider.searchProductList != null && searchProvider.searchProductList!.isNotEmpty)
                Center(
                  child: SizedBox(
                    width: 1170,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${searchProvider.searchProductList!.length} ${getTranslated('product_found', context)}',
                          
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                List<double?> prices = [];
                                for (var product in searchProvider.filterProductList!) {
                                  prices.add(product.price);
                                }
                                prices.sort();
                                double? maxValue = prices.isNotEmpty ? prices.last : 1000;
                                return Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                  child: SizedBox(width: 550, child: FilterWidget(maxValue: maxValue)),
                                );
                              },
                            );
                          },
                          child: Image.asset(Images.filter),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 13),
              IgnorePointer(
                ignoring: searchProvider.searchProductList == null,
                child: FilterButtonWidget(
                  type: _type,
                  items: Provider.of<ProductProvider>(context).productTypeList,
                  onSelected: (selected) {
                    setState(() {
                      _type = selected;
                    });
                    searchProvider.searchProduct(_searchController.text, context, type: _type, isUpdate: true);
                  },
                ),
              ),
              Expanded(
                child: searchProvider.searchProductList != null
                    ? searchProvider.searchProductList!.isNotEmpty
                        ? ListView.builder(
                            itemCount: searchProvider.searchProductList!.length,
                            padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                            itemBuilder: (context, index) {
                              final product = searchProvider.searchProductList![index];
                              return ProductWidgetContainer(product: product);
                            },
                          )
                        : NoDataScreen()
                    : Center(
                        child: SizedBox(
                          width: 1170,
                          child: GridView.builder(
                            itemCount: 1,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 5,
                              childAspectRatio: ResponsiveHelper.isDesktop(context) ? 0.7 : 3,
                              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 3 : 1,
                            ),
                            itemBuilder: (context, index) => ResponsiveHelper.isDesktop(context)
                                ? Image.asset(Images.gif,width: 150,height: 150,)
                                :  Image.asset(Images.gif,width: 150,height: 150,)
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
