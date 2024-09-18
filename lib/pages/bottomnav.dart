import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hutech_cateen/pages/Order.dart';
import 'package:hutech_cateen/pages/Profile.dart';
import 'package:hutech_cateen/pages/home.dart';
import 'package:hutech_cateen/pages/setting.dart';
import 'package:hutech_cateen/pages/shoppingcart.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;
  late Home homePage;
  late Order order;
  late Profile profile;
  late ShoppingCart shoppingCart;
  late Setting setting;
  int currentTabIndex = 0;

  @override
  void initState() {
    homePage = Home();
    order = Order();
    profile = Profile();
    shoppingCart = ShoppingCart();
    setting = Setting();
    pages = [homePage, order, shoppingCart, profile, setting];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 65,
          backgroundColor: Colors.white,
          index: 2,
          color: Color.fromARGB(255, 245, 177, 76),
          animationDuration: Duration(milliseconds: 500),
          onTap: (int index) {
            setState(() {
              currentTabIndex = index;
            });
          },
          items: [
            Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.shopping_bag_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            Icon(
              Icons.person_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ]),
      body: pages[currentTabIndex],
    );
  }
}
