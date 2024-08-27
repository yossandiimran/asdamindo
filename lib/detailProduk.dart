// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:asdamindo/helper/global.dart';
import 'package:flutter/material.dart';

class DetailBarang extends StatefulWidget {
  final obj;
  const DetailBarang({super.key, required this.obj});

  @override
  DetailBarangState createState() => DetailBarangState();
}

class DetailBarangState extends State<DetailBarang> {
  var listPengajuan = [], isLoading = true, obj = {}, cntCart = 0;

  @override
  void initState() {
    obj = widget.obj;
    cntCart = int.parse(obj["qty"] != null ? obj["qty"].toString() : "0");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blueGrey.shade50,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: global.decCont2(defWhite, 5, 5, 5, 5),
              margin: EdgeInsets.all(10),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: defGrey,
              ),
            ),
          ),
          actions: [
            // GestureDetector(
            //   onTap: () {
            //     Navigator.pushNamed(context, '/keranjangBelanja');
            //   },
            //   child: Container(
            //     decoration: global.decCont2(defWhite, 5, 5, 5, 5),
            //     margin: EdgeInsets.all(10),
            //     padding: EdgeInsets.all(5),
            //     child: Icon(
            //       Icons.shopping_cart_rounded,
            //       color: defGrey,
            //     ),
            //   ),
            // ),
          ],
        ),
        body: getBodyView(),
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
          child: Column(
            children: [
              Container(
                height: global.getHeight(context),
                decoration: BoxDecoration(
                  color: defBlack2,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: kToolbarHeight * 1.6,
          left: 15,
          bottom: 0,
          right: 15,
          child: Column(
            children: [
              Container(
                height: global.getHeight(context) / 3,
                width: global.getWidth(context),
                decoration: global.decCont2(Colors.transparent, 25, 25, 25, 25),
                child: Image.network(
                  "${global.baseIp}/api/files/${widget.obj["collectionId"]}/${widget.obj["id"]}/${widget.obj["foto_produk"][0]}",
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          right: 0,
          child: RefreshIndicator(
            onRefresh: () async {},
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          right: 0,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: kToolbarHeight * 7),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: global.decCont2(defWhite, 0, 0, 15, 15),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          widget.obj["nama_produk"],
                          style: global.styleText5(18, defBlack1),
                        ),
                        subtitle: Text(
                          global.formatRupiah(double.parse(widget.obj["harga"])),
                          style: global.styleText5(14, defGrey),
                        ),
                      ),
                      SizedBox(
                        width: global.getWidth(context),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                if (cntCart != 0) {
                                  cntCart = cntCart - 1;
                                }
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: global.decCont(defWhite, 10, 10, 10, 10),
                                child: Icon(Icons.remove, color: defRed),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(cntCart.toString(), style: global.styleText5(20, defBlack1)),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                cntCart = cntCart + 1;
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: global.decCont(defWhite, 10, 10, 10, 10),
                                child: Icon(Icons.add_rounded, color: defBlue),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: addToCart,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: global.decCont(defWhite, 10, 10, 10, 10),
                                child: Row(
                                  children: [
                                    Icon(Icons.add_shopping_cart_rounded, color: defOrange),
                                    Text("Tambah ke keranjang", style: global.styleText5(12, defOrange)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        visualDensity: VisualDensity(vertical: -4),
                        subtitle: Text(
                          'Seller : ' + widget.obj["owner"],
                          style: global.styleText4(15),
                        ),
                      ),
                      ListTile(
                        visualDensity: VisualDensity(vertical: -4),
                        subtitle: Text(
                          "${widget.obj["keterangan"]}",
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(height: global.getHeight(context) - (kToolbarHeight * 5.8)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> addToCart() async {
    var checkCart = await preference.getData("cart"), msg = "menambahkan";
    widget.obj["qty"] = cntCart;

    var tempCarts = await preference.getData("cart");
    var listCart = [];
    if (tempCarts != null) {
      listCart = jsonDecode(utf8.decode(base64.decode(tempCarts)))["cart"];
    }

    if (listCart.where((element) => element["owner"] != widget.obj["owner"]).isNotEmpty) {
      return global.alertWarning(
        context,
        "Barang yang anda masukan di keranjang harus melalui seller yang sama, untuk order barang dari seller berbeda mohon checkout keranjang anda atau kosongkan terlebih dahulu, terimakasih.",
      );
    }

    if (cntCart < 1) {
      return global.alertWarning(context, "Barang tidak boleh kurang dari 1");
    }
    Map tempCart;
    if (checkCart == null) {
      tempCart = {
        "cart": [widget.obj]
      };
    } else {
      tempCart = jsonDecode(utf8.decode(base64.decode(checkCart)));
      Map<String, dynamic>? targetElemen = tempCart['cart'].firstWhere(
        (elemen) => elemen['id'] == widget.obj["id"],
        orElse: () => null,
      );
      if (targetElemen != null) {
        targetElemen["qty"] = cntCart;
        msg = "mengupdate";
      } else {
        tempCart["cart"].add(widget.obj);
      }
    }
    preference.setString("cart", base64Encode(utf8.encode(jsonEncode(tempCart))));
    Navigator.pop(context);
    global.alertSuccess(context, "Berhasil $msg ke keranjang");
  }
}
