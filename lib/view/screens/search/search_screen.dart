import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/search_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
// import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/base/wish_button.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late int _selectedIndex = 0; // Initialize _selectedIndex
  late String _type = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<SearchProvider>(context, listen: false).initHistoryList();
    _type = Provider.of<ProductProvider>(context, listen: false).productTypeList.isNotEmpty
        ? Provider.of<ProductProvider>(context, listen: false).productTypeList[0]
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.kWhite,
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: WebAppBar(),
            )
          : null,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 1170,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: _buildSearchContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchContent() {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  prefixIconUrl: Images.search,
                  isShowPrefixIcon: true,
                  onTap: () {
                    _performSearch(searchProvider);
                  },
                  hintText: getTranslated('search_items_here', context),
                  isShowBorder: true,
                  controller: _searchController,
                  inputAction: TextInputAction.search,
                  isIcon: true,
                  onSubmit: (text) {
                    _performSearch(searchProvider);
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  getTranslated('cancel', context)!,
                  style: TextStyle(fontSize: 15)
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          _buildCategoryGridView(searchProvider),
          const SizedBox(height: 10),
          Expanded(
            child: Consumer<CategoryProvider>(
              builder: (context, category, child) {
                if (category.isLoading || category.categoryProductList == null) {
                  return Center(child: Image.asset(Images.gif,width: 150,height: 150,));
                } else {
                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height < 600
                                ? MediaQuery.of(context).size.height
                                : MediaQuery.of(context).size.height - 600,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: category.categoryProductList != null
                                ? category.categoryProductList!.isNotEmpty
                                    ? _productGrid(category, context)
                                    : NoDataScreen(isFooter: false)
                                : NoDataScreen(isFooter: false)
                          ),
                        ),
                      ),
                      if (ResponsiveHelper.isDesktop(context)) FooterView(),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGridView(SearchProvider searchProvider) {
    return Consumer<CategoryProvider>(
      builder: (context, category, child) {
        return category.categoryList != null && category.categoryList!.isNotEmpty
            ? Container(
                height: 33,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: category.categoryList!.length,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (context, index) {
                    var subCategory = category.categoryList![index];
                    bool isSelected = index == _selectedIndex;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                        // Assuming updateSelectCategory does something related to category selection
                        category.updateSelectCategory(index);

                        // Trigger logic to fetch or display items associated with the selected category
                        // Example:
                        // Assuming getCategoryProductList fetches products associated with the selected category
                        Provider.of<CategoryProvider>(context, listen: false)
                            .getCategoryProductList(
                              category.categoryList![index].id.toString(),
                              type: _type,
                            );

                        // Optionally, you can also clear the search field or perform any other action here
                        _searchController.clear();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorResources.kOrangeColor
                              : ColorResources.kColorgrey,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: ColorResources.klgreyColor),
                        ),
                        child: Text(
  category.categoryList![index].name!,
  textAlign: TextAlign.center,
  maxLines: 2, // Set maxLines to 2 to limit the text to two lines
  overflow: TextOverflow.ellipsis, // Use ellipsis to indicate overflow
),

                      ),
                    );
                  },
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget _productGrid(CategoryProvider category, BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: category.categoryProductList!.length,
      physics: const NeverScrollableScrollPhysics(),
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
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
            child: Container(
              decoration: BoxDecoration(
                color: ColorResources.kcontainergrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 139,
                    height: 116,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures title and WishButton are spaced apart
          children: [
            Flexible( // Use Flexible to handle title length
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            WishButton(
              product: product,
              edgeInset: EdgeInsets.zero,
              iconSize: 20,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.star, color: ColorResources.kstarYellow, size: 16),
            Text(
              ' $rating',
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(
            fontSize: 8, 
            color: ColorResources.kIncreasedColor,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
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
),

                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _performSearch(SearchProvider searchProvider, {String? searchString}) {
    final String searchText = searchString ?? _searchController.text.trim();
    if (searchText.isNotEmpty) {
      searchProvider.saveSearchAddress(searchText);
      searchProvider.searchProduct(searchText, context);
      RouterHelper.getSearchResultRoute(searchText.replaceAll(' ', '-'));
    }
  }

  void _addToCart(BuildContext context, Product product) {
    // Add your logic to handle adding product to cart here
    // Example:
    // Provider.of<CartProvider>(context, listen: false).addToCart(product);
  }
}
