import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/search_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late int _selectedIndex = 0; // Initialize _selectedIndex

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<SearchProvider>(context, listen: false).initHistoryList();
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
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: ColorResources.getGreyBunkerColor(context),
                      ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          _buildCategoryGridView(),
          const SizedBox(height: 10),
          // Expanded(
          //   // child: _buildRecentSearchSection(searchProvider),
          // ),
        ],
      ),
    );
  }

  Widget _buildCategoryGridView() {
    return Consumer<CategoryProvider>(
      builder: (context, category, child) {
        return category.categoryList != null && category.categoryList!.isNotEmpty
            ? Container(
                height:33, 
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
                        // searchProvider.fetchItemsByCategory(category.categoryList![index].id); // Adjust as per your provider logic
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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

  void _performSearch(SearchProvider searchProvider, {String? searchString}) {
    final String searchText = searchString ?? _searchController.text.trim();
    if (searchText.isNotEmpty) {
      searchProvider.saveSearchAddress(searchText);
      searchProvider.searchProduct(searchText, context);
      RouterHelper.getSearchResultRoute(searchText.replaceAll(' ', '-'));
    }
  }
}
