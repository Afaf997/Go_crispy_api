import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/filter_button_widget.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/wish_button.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';

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
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 0,
      vsync: this,
    );

    _selectedIndex = int.parse(widget.categoryId);

    _loadData();
  }

  void _loadData() async {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.getSubCategoryList(widget.categoryId);

    categoryProvider.getCategoryProductList(widget.categoryId, type: _type);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onCategorySelected(int index, CategoryProvider category) {
    setState(() {
      _selectedIndex = index + 1;
    });

    Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryProductList(category.categoryList![index].id!.toString(), type: _type);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorResources.kWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('All Categories',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Consumer<CategoryProvider>(
            builder: (context, category, child) {
              if (category.isLoading || category.categoryList == null) {
                return const Center(
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 33,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: category.categoryList!.length,
                        itemBuilder: (context, index) {
                          var subCategory = category.categoryList![index];
                          bool isSelected = index == _selectedIndex - 1;
                          return GestureDetector(
                            onTap: () {
                              _onCategorySelected(index, category);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? ColorResources.kOrangeColor : ColorResources.kColorgrey,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: ColorResources.klgreyColor),
                              ),
                              child: Text(
                                subCategory.name ?? '',
                                style: TextStyle(
                                  color: isSelected ? Colors.white : ColorResources.korgGrey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, category, child) {
          if (category.isLoading || category.categoryProductList == null) {
            return Center(
              child: Image.asset(
                Images.gif,
                width: 200,
                height: 200,
              ),
            );
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
                                type: _type,
                              );
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
                                  : NoDataScreen(isFooter: false)
                              : _productGridShimmer(context),
                        ),
                      ),
                      if (ResponsiveHelper.isDesktop(context)) FooterView(),
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
    return ListView.builder(
      shrinkWrap: true,
      itemCount: category.categoryProductList!.length,
      physics: NeverScrollableScrollPhysics(),
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

       return InkWell(
  onTap: () {
    _addToCart(context, product);
  },
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
          width: 326, // Width of the image
          height: 116, 
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorResources.kallcontainer),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 139, // Width of the image
            height: 116, // Height of the image
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      WishButton(
                        product: product,
                        edgeInset: EdgeInsets.zero,
                        iconSize: 16,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: ColorResources.kstarYellow, size: 16),
                      Text(
                        ' $rating',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 8, color: ColorResources.kIncreasedColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 14,
                      color: ColorResources.kredcolor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);

      },
    );
  }

  void _addToCart(BuildContext context, product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (con) => CartBottomSheet(
        product: product,
        callback: (CartModel cartModel) {
          showCustomSnackBar('Added to cart', isError: false);
        },
      ),
    );
  }

  Widget _productGridShimmer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade300,
      ),
    );
  }
}
