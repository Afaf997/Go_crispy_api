import 'package:flutter/material.dart';
import 'package:flutter_restaurant/view/screens/cart/cart_screen.dart';
import 'package:flutter_restaurant/view/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_restaurant/view/screens/home/home_screen.dart';
import 'package:flutter_restaurant/view/screens/menu/menu_screen.dart';
import 'package:flutter_restaurant/view/screens/order/order_screen.dart';
import 'package:flutter_restaurant/view/screens/wishlist/wishlist_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentNavIndex = 0;

  // Function to get the current screen based on the selected index
  Widget _getCurrentScreen() {
    switch (_currentNavIndex) {
      case 0:
        return const HomeScreen(false); // HomeScreen
      case 1:
        return const CartScreen(); // CartScreen
      case 2:
        return const OrderScreen(); // OrderScreen
      case 3:
        return const WishListScreen(); // WishListScreen
      case 4:
        return const MenuScreen(); // MenuScreen
      default:
        return const HomeScreen(false); // Default to HomeScreen
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentNavIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getCurrentScreen(), // Display the current screen
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _currentNavIndex,
        onItemTapped: _onNavItemTapped,
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Wishlist',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Menu',
        ),
      ],
    );
  }
}
