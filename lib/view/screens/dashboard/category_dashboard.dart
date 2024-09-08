import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/network_info.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/view/base/third_party_chat_widget.dart';
import 'package:flutter_restaurant/view/screens/cart/cart_screen.dart';
import 'package:flutter_restaurant/view/screens/home/home_screen.dart';
import 'package:flutter_restaurant/view/screens/menu/menu_screen.dart';
import 'package:flutter_restaurant/view/screens/order/order_screen.dart';
import 'package:flutter_restaurant/view/screens/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

class CategoryDashboard extends StatefulWidget {
  final int pageIndex;
  
  const CategoryDashboard({Key? key, required this.pageIndex}) : super(key: key);

  @override
  State<CategoryDashboard> createState() => _CategoryDashboardState();
}

class _CategoryDashboardState extends State<CategoryDashboard> {
  PageController? _pageController;
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    final splashProvider = Provider.of<SplashProvider>(context, listen: false);

    if (splashProvider.policyModel == null) {
      splashProvider.getPolicyPage();
    }
    HomeScreen.loadData(false);

    Provider.of<OrderProvider>(context, listen: false).changeStatus(true);
    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(false),
      const CartScreen(),
      const OrderScreen(),
      const WishListScreen(),
      MenuScreen(onTap: (int pageIndex) {
        _setPage(pageIndex);
      }),
    ];

    if (ResponsiveHelper.isMobilePhone()) {
      NetworkInfo.checkConnectivity(_scaffoldKey);
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: !ResponsiveHelper.isDesktop(context) && _pageIndex == 0
            ? const ThirdPartyChatWidget()
            : null,
        bottomNavigationBar: !ResponsiveHelper.isDesktop(context)
            ? CustomBottomNavBar(
                selectedIndex: _pageIndex,
                onItemTapped: _setPage,
              )
            : const SizedBox(),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController!.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(31, 58, 57, 57),
            blurRadius: 10,
            spreadRadius: 5,
          )
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.sentiment_satisfied_outlined,
            index: 0,
            isSelected: selectedIndex == 0,
            onTap: onItemTapped,
            label: getTranslated('home', context),
          ),
          _buildNavItem(
            icon: Icons.shopping_cart,
            index: 1,
            isSelected: selectedIndex == 1,
            onTap: onItemTapped,
            label: getTranslated('cart', context),
            cartCount: Provider.of<CartProvider>(context).cartList.length,
          ),
          _buildNavItem(
            icon: Icons.shopping_bag_outlined,
            index: 2,
            isSelected: selectedIndex == 2,
            onTap: onItemTapped,
            label: getTranslated('order', context),
          ),
          _buildNavItem(
            icon: Icons.favorite_outline_rounded,
            index: 3,
            isSelected: selectedIndex == 3,
            onTap: onItemTapped,
            label: getTranslated('favourite', context),
          ),
          _buildNavItem(
            icon: Icons.filter_list_outlined,
            index: 4,
            isSelected: selectedIndex == 4,
            onTap: onItemTapped,
            label: getTranslated('menu', context),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required bool isSelected,
    required ValueChanged<int> onTap,
    required String? label,
    int cartCount = 0,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          isSelected
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: ColorResources.kOrangeColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        label!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : Icon(
                  icon,
                  color: Colors.grey,
                ),
          if (index == 1 && cartCount > 0)
            Positioned(
              top: -7,
              right: -7,
              child: Container(
                padding: const EdgeInsets.all(4),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Text(
                  cartCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
