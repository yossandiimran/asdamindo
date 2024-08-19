// ignore_for_file: deprecated_member_use

import 'package:asdamindo/helper/global.dart';
import 'package:asdamindo/homeWidget.dart';
import 'package:asdamindo/keranjang.dart';
import 'package:asdamindo/profileWidget.dart';
import 'package:asdamindo/searchProduk.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<TabItem> items = [
    TabItem(
      icon: Icons.home,
      title: 'Home',
    ),
    TabItem(
      icon: Icons.search_sharp,
      title: 'Search',
    ),
    TabItem(
      icon: Icons.shopping_cart_outlined,
      title: 'Cart',
    ),
    TabItem(
      icon: Icons.account_box,
      title: 'profile',
    ),
  ];

  int visit = 0;
  double height = 30;
  Color colorSelect = const Color(0XFF0686F8);
  Color color = const Color(0XFF7AC0FF);
  Color color2 = Colors.white;
  Color bgColor = Color.fromRGBO(143, 148, 251, 1);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return global.alertConfirmExit(context);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(widget.title),
        ),
        body: getIndex(),
        bottomNavigationBar: BottomBarInspiredInside(
          items: items,
          backgroundColor: bgColor,
          color: Colors.white,
          colorSelected: Colors.white,
          indexSelected: visit,
          onTap: (int index) => setState(() {
            visit = index;
          }),
          animated: false,
          chipStyle: const ChipStyle(isHexagon: false, convexBridge: true),
          itemStyle: ItemStyle.circle,
        ),
      ),
    );
  }

  getIndex() {
    if (visit == 0) {
      return HomeWidget(title: '');
    } else if (visit == 1) {
      return SearchProduk(title: '');
    } else if (visit == 2) {
      return Keranjang();
    } else if (visit == 3) {
      return ProfileWidget(title: '');
    }
  }
}
