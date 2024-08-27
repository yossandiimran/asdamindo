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
  Color colorSelect = Color.fromARGB(255, 116, 120, 124);
  Color color = Color.fromARGB(255, 0, 0, 0);
  Color color2 = Colors.white;
  Color bgColor = Color.fromRGBO(0, 162, 232, 1);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return global.alertConfirmExit(context);
      },
      child: Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: bgColor,
          centerTitle: true,
          title: Text(widget.title, style: global.styleText5(global.getWidth(context) / 20, defWhite)),
        ),
        body: getIndex(),
        bottomNavigationBar: BottomBarInspiredInside(
          items: items,
          backgroundColor: Colors.white,
          color: defBlack1,
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
