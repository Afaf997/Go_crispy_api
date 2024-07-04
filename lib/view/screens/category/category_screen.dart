import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/filter_button_widget.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/wish_button.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_web_card_shimmer.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_widget_web.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryId;
  final String? categoryName;
  final String? categoryBannerImage;

  const CategoryScreen({
    Key? key,
    required this.categoryId,
    this.categoryName,
    this.categoryBannerImage,
  }) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _tabIndex = 0;
  String _type = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 1,
      vsync: this,
    );
    _loadData();
  }

  void _loadData() async {
    Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryList(false);
    Provider.of<CategoryProvider>(context, listen: false)
        .getSubCategoryList(widget.categoryId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorResources.kWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:const Text('All Categories',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),), // Setting the title of AppBar
        centerTitle: true, 
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            width: ResponsiveHelper.isDesktop(context) ? 1170 : MediaQuery.of(context).size.width,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              unselectedLabelColor: Theme.of(context).hintColor.withOpacity(0.7),
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: _tabs(context), // Using the _tabs method to generate tabs
              onTap: (int index) {
                setState(() {
                  _type = 'all';
                  _tabIndex = index;
                });
                if (index == 0) {
                  Provider.of<CategoryProvider>(context, listen: false)
                      .getCategoryProductList(widget.categoryId);
                } else {
                  Provider.of<CategoryProvider>(context, listen: false)
                      .getCategoryProductList(
                          Provider.of<CategoryProvider>(context, listen: false)
                              .subCategoryList![index - 1]
                              .id
                              .toString());
                }
              },
            ),
          ),
        ),
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, category, child) {
          if (category.isLoading || category.categoryList == null) {
            return const Center(child:  CircularProgressIndicator(color: ColorResources.kOrangeColor,));
          } else {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FilterButtonWidget(
                        type: _type,
                        items: Provider.of<ProductProvider>(context).productTypeList,
                        onSelected: (selected) {
                          setState(() {
                            _type = selected;
                          });
                          Provider.of<CategoryProvider>(context, listen: false)
                              .getCategoryProductList(
                                  Provider.of<CategoryProvider>(context, listen: false)
                                      .selectedSubCategoryId,
                                  type: _type);
                        },
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: size.height < 600 ? size.height : size.height - 600,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: category.categoryProductList != null
                              ? category.categoryProductList!.isNotEmpty
                                  ? _productGrid(category, context)
                                  : const NoDataScreen(isFooter: false)
                              : _productGridShimmer(context),
                        ),
                      ),
                      if (ResponsiveHelper.isDesktop(context)) const FooterView(),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _productGrid(CategoryProvider category, BuildContext context) {
    if (category.categoryProductList == null ||
        category.categoryProductList!.isEmpty) {
      return const NoDataScreen(isFooter: false);
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: category.categoryProductList!.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      itemBuilder: (context, index) {
        final product = category.categoryProductList![index];
        String? productImage = product.image != null
            ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${product.image}'
            : null;
        final title = product.name ?? 'Unknown';
        final description = product.description ?? 'No description available';
        final price = product.price?.toString() ?? 'N/A';
        final rating = product.rating != null && product.rating!.isNotEmpty
            ? double.parse(product.rating![0].average ?? '0')
            : 0.0;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: ColorResources.kallcontainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 136,
                      height: 108,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: productImage != null
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(productImage),
                              )
                            : const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(Images.placeholderImage),
                              ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              WishButton(
                                product: product,
                                edgeInset: const EdgeInsets.all(5),
                                iconSize: 15,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: ColorResources.kstarYellow, size: 12),
                              Text(
                                ' $rating',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
                              ),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            child: Text(
                              description,
                              style: const TextStyle(fontSize: 9),
                            ),
                          ),
                          Text(
                            price,
                            style: const TextStyle(
                              fontSize: 14,
                              color: ColorResources.kredcolor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _productGridShimmer(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 10,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: ResponsiveHelper.isDesktop(context) ? 0.7 : 4,
        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 2 : 1,
      ),
      itemBuilder: (context, index) {
        return ResponsiveHelper.isDesktop(context)
            ? const ProductWidgetWebShimmer()
            : ProductShimmer(isEnabled: true);
      },
    );
  }

  
  List<Tab> _tabs(BuildContext context) {
    final category = Provider.of<CategoryProvider>(context, listen: false);
    List<Tab> tabList = [const Tab(text: 'All')];
    for (var subCategory in category.categoryList!) {
      tabList.add(Tab(text: subCategory.name));
    }
    return tabList;
  }
}
