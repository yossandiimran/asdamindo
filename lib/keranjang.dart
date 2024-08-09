// ignore_for_file: deprecated_member_use, avoid_returning_null_for_void

import 'package:asdamindo/helper/global.dart';
import 'package:flutter/material.dart';

class Keranjang extends StatefulWidget {
  const Keranjang({super.key});
  @override
  KeranjangState createState() => KeranjangState();
}

class KeranjangState extends State<Keranjang> {
  static const List listCart = [
    {"nama_produk": "Galon A", "qty": "2", "harga_jual": "20.000"},
    {"nama_produk": "Galon B", "qty": "5", "harga_jual": "20.000"},
    {"nama_produk": "Galon C", "qty": "1", "harga_jual": "13.000"},
    {"nama_produk": "Galon D", "qty": "1", "harga_jual": "4.000"},
  ];
  bool isLoading = true;
  num grandTotal = 0;
  TextEditingController ketController = TextEditingController(text: "");
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.blueGrey.shade50,
          extendBodyBehindAppBar: true,
          body: getBodyView(),
        ),
      ),
    );
  }

  Widget getBodyView() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          right: 0,
          child: RefreshIndicator(
            onRefresh: () async => null,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  for (var i = 0; i < listCart.length; i++)
                    Dismissible(
                      key: Key(listCart[i]['nama_produk']),
                      onDismissed: (direction) {
                        grandTotal = grandTotal - (double.parse(listCart[i]["harga_jual"]) * listCart[i]["qty"]);
                        setState(() => listCart.removeAt(i));
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/detailBarang', arguments: listCart[i]).then(
                            (value) {
                              setState(() {});
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: global.decCont(defWhite, 20, 20, 20, 20),
                          child: ListTile(
                            leading: Image.asset('assets/images/clock.png'),
                            title: Text(listCart[i]["nama_produk"], style: global.styleText5(13, defBlack1)),
                            subtitle: Row(
                              children: [
                                Text("QTY: ${listCart[i]["qty"]}", style: global.styleText5(13, defGrey)),
                                Spacer(),
                                Text(
                                  "20.000",
                                  style: global.styleText5(13, defBlack1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    decoration: global.decCont(defWhite, 20, 20, 20, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              "*) Swipe barang untuk menghapus",
                              style: TextStyle(fontStyle: FontStyle.italic, color: defRed, fontSize: 11),
                            ),
                            Spacer(),
                            Text("Total Harga", style: TextStyle(fontStyle: FontStyle.italic)),
                          ],
                        ),
                        Divider(thickness: 3),
                        Row(
                          children: [
                            Spacer(),
                            Text(
                              "40.000",
                              style: global.styleText5(14, defBlack1),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () async {},
                              child: Container(
                                width: global.getWidth(context) / 3,
                                padding: EdgeInsets.all(10),
                                decoration: global.decCont2(defRed, 10, 10, 10, 10),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Icon(Icons.delete, color: defWhite),
                                    SizedBox(width: 10),
                                    Text("Kosongkan", style: global.styleText5(12, defWhite)),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: global.getWidth(context) / 3,
                                padding: EdgeInsets.all(10),
                                decoration: global.decCont2(defGreen, 10, 10, 10, 10),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Text("Checkout", style: global.styleText5(12, defWhite)),
                                    SizedBox(width: 10),
                                    Icon(Icons.shopping_cart_checkout_rounded, color: defWhite),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
