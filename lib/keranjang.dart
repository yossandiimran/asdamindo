import 'dart:convert';

import 'package:asdamindo/detailProduk.dart';
import 'package:asdamindo/helper/global.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class Keranjang extends StatefulWidget {
  const Keranjang({super.key});
  @override
  KeranjangState createState() => KeranjangState();
}

class KeranjangState extends State<Keranjang> {
  List listCart = [];
  bool isLoading = true;
  num grandTotal = 0;
  TextEditingController ketController = TextEditingController(text: "");
  @override
  void initState() {
    super.initState();
    getDashboardData();
  }

  Future<void> getDashboardData() async {
    isLoading = true;
    listCart.clear();
    var tempCart = await preference.getData("cart");
    if (tempCart != null) {
      listCart = jsonDecode(utf8.decode(base64.decode(tempCart)))["cart"];
    }

    countTotal();

    setState(() {});
  }

  countTotal() {
    grandTotal = 0;
    for (var i = 0; i < listCart.length; i++) {
      grandTotal = grandTotal + (int.parse(listCart[i]["harga"]) * listCart[i]["qty"]);
    }
    setState(() {});
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
          top: 10,
          left: 0,
          bottom: 0,
          right: 0,
          child: RefreshIndicator(
            onRefresh: () async => getDashboardData(),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  for (var i = 0; i < listCart.length; i++)
                    Dismissible(
                      key: Key(listCart[i]['id']),
                      onDismissed: (direction) {
                        grandTotal = grandTotal - (double.parse(listCart[i]["harga"]) * listCart[i]["qty"]);
                        global.addToCart(listCart[i], context, 0);
                        setState(() => listCart.removeAt(i));
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return DetailBarang(obj: listCart[i]);
                          })).then(
                            (value) {
                              countTotal();
                              setState(() {});
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          decoration: global.decCont(defWhite, 0, 0, 0, 0),
                          child: ListTile(
                            leading: SizedBox(
                              width: 60,
                              child: Image.network(
                                "${global.baseIp}/api/files/${listCart[i]["collectionId"]}/${listCart[i]["id"]}/${listCart[i]["foto_produk"][0]}",
                              ),
                            ),
                            title: Text(listCart[i]["nama_produk"], style: global.styleText4(13)),
                            subtitle: Row(
                              children: [
                                Text("${listCart[i]["qty"]}", style: global.styleText5(13, defGrey)),
                                Text(" x ", style: global.styleText5(13, defGrey)),
                                Text(listCart[i]["harga"], style: global.styleText5(13, defGrey)),
                                Spacer(),
                                Text(
                                  global.formatRupiah(double.parse(listCart[i]["harga"]) * listCart[i]["qty"]),
                                  style: global.styleText5(13, defBlack1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    decoration: global.decCont(defWhite, 10, 10, 0, 0),
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
                              global.formatRupiah(grandTotal.toDouble()).toString(),
                              style: global.styleText5(14, defBlack1),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          child: TextField(
                            textInputAction: TextInputAction.done,
                            controller: ketController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                              hintText: 'Keterangan',
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                global.alertConfirmation(
                                    context: context,
                                    action: () {
                                      preference.remove("cart");
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      global.alertSuccess(context, "Keranjang berhasil dihapus");
                                    },
                                    message: "Hapus semua barang yang ada di keranjang ?");
                              },
                              child: Container(
                                width: global.getWidth(context) / 3,
                                padding: EdgeInsets.all(5),
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
                              onTap: () {
                                global.alertConfirmation(
                                  context: context,
                                  action: orderAction,
                                  message: "Apakah anda yakin?",
                                );
                              },
                              child: Container(
                                width: global.getWidth(context) / 3,
                                padding: EdgeInsets.all(5),
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

  Future<void> orderAction() async {
    Navigator.pop(context);
    global.loadingAlert(context, "Mohon tunggu ... ", false);
    pb.collection('transaksi').create(
      body: {
        "id_user_pembeli": preference.getData("id"),
        "id_user_penjual": null,
        "total_harga": grandTotal,
        "keterangan": ketController.text,
        "catatan": null,
        "alamat_pengiriman": preference.getData("alamat"),
        "status": "new"
      },
    ).then((record) {
      var vals = record.toJson();
      for (var i = 0; i < listCart.length; i++) {
        pb.collection('transaksi_detail').create(body: {
          "id_transaksi": vals["id"],
          "id_barang": listCart[i]["id"],
          "qty": listCart[i]["qty"],
          "harga_satuan": listCart[i]["harga"],
          "total_harga": (double.parse(listCart[i]["harga"]) * listCart[i]["qty"])
        });
      }
      Navigator.pop(context);
      preference.remove("cart");
      getDashboardData();
      ketController.text = "";
      grandTotal = 0;
      global.alertSuccess(context, "Transaksi berhasil dibuat");
      setState(() {});
    }).catchError((err) {
      print(err);
      try {
        ClientException error = err;
        print(error);
        Navigator.pop(context);
        var dynamicData = error.response["data"];
        for (var key in dynamicData.keys) {
          var valueList = dynamicData[key]!;
          return global.alertWarning(context, valueList["message"].toString());
        }
        return global.alertWarning(context, "Username / Email & Password salah");
      } catch (err2) {
        Navigator.pop(context);
        print(err2);
      }
    });
  }
}
