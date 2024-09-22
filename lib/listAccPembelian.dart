// ignore_for_file: deprecated_member_use, prefer_const_declarations
import 'dart:convert';
import 'package:asdamindo/helper/global.dart';
import 'package:asdamindo/listTransaksiDetail.dart';
import 'package:asdamindo/ListAccPembelianFormPembayaran.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class ListAccPembelian extends StatefulWidget {
  const ListAccPembelian({super.key});
  @override
  ListAccPembelianState createState() => ListAccPembelianState();
}

class ListAccPembelianState extends State<ListAccPembelian> {
  TextEditingController searchKey = TextEditingController();
  List listOrder = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getDashboardData();
  }

  Future<void> getDashboardData() async {
    // var filter = "status = 'verification'" + '&& nama ~ "${searchKey.text}"';
    var filter =
        "" + 'nama ~ "${searchKey.text}"' + '|| id ~ "${searchKey.text}"';
    await pb
        .collection('transaksi_join_user')
        .getFullList(filter: filter)
        .then((value) {
      listOrder = jsonDecode(value.toString());
      setState(() {});
    }).catchError((err) {
      try {
        ClientException error = err;
        print(error);
        Navigator.pop(context);
        var dynamicData = error.response["data"];
        for (var key in dynamicData.keys) {
          var valueList = dynamicData[key]!;
          return global.alertWarning(context, valueList["message"].toString());
        }
        return global.alertWarning(context, "Data kosong !");
      } catch (err2) {
        Navigator.pop(context);
        print(err2);
      }
    });
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
          appBar: AppBar(
            title: Text(
              'Daftar Transaksi',
              style: global.styleText5(15, defBlack1),
            ),
          ),
          backgroundColor: Colors.blueGrey.shade50,
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
            onRefresh: () async => getDashboardData(),
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Container(
                      width: global.getWidth(context),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: global.decCont(defWhite, 20, 20, 20, 20),
                      child: TextField(
                        controller: searchKey,
                        onChanged: (val) {
                          getDashboardData();
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          alignLabelWithHint: true,
                          hintText: "Cari Nama / Nomor Transaksi",
                          suffixIcon: Icon(Icons.search, color: defBlack1),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    for (var i = 0; i < listOrder.length; i++)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        margin:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        decoration: global.decCont(defWhite, 10, 10, 10, 10),
                        child: Column(children: [
                          Row(
                            children: [
                              getIconStatus(listOrder[i]),
                              gettextStatus(listOrder[i]),
                              Spacer(),
                              Text(
                                listOrder[i]["id"].toString(),
                                style: global.styleText6(14, defBlack1),
                              ),
                            ],
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: [
                              Text("Tanggal",
                                  style: global.styleText5(12, defBlack1)),
                              Spacer(),
                              Text(
                                listOrder[i]["created"].toString(),
                                style: global.styleText5(12, defGrey),
                              ),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     Text("Catatan", style: global.styleText5(12, defBlack1)),
                          //     Spacer(),
                          //     Text(
                          //       listOrder[i]["catatan"].toString(),
                          //       style: global.styleText5(12, defGrey),
                          //     ),
                          //   ],
                          // ),
                          Row(
                            children: [
                              Text("Pembeli",
                                  style: global.styleText5(12, defBlack1)),
                              Spacer(),
                              Text(
                                listOrder[i]["nama"],
                                style: global.styleText5(12, defGrey),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Keterangan",
                                  style: global.styleText5(12, defBlack1)),
                              Spacer(),
                              Text(
                                listOrder[i]["keterangan"],
                                style: global.styleText5(12, defGrey),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              listOrder[i]["status"] == 'verification'
                                  ? GestureDetector(
                                      onTap: () async {
                                        Map objParam = {
                                          'id': listOrder[i]["id"],
                                          "keterangan": listOrder[i]
                                              ["keterangan"],
                                          "catatan": listOrder[i]["catatan"],
                                          "info": listOrder[i],
                                        };
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ListAccPembelianFormPembayaran(
                                              objParam: objParam);
                                        })).then((value) async {
                                          await getDashboardData();
                                          setState(() {});
                                        });
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        decoration: global.decCont(
                                            defWhite, 10, 10, 10, 10),
                                        child: Row(
                                          children: [
                                            Icon(Icons.arrow_back_ios_new,
                                                color: defPurple, size: 10),
                                            Text("    Verifikasi Pembayaran",
                                                style: global.styleText5(
                                                    12, defPurple)),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Map objParam = {
                                    'id': listOrder[i]["id"],
                                    "keterangan": listOrder[i]["keterangan"],
                                    "catatan": listOrder[i]["catatan"],
                                    "info": listOrder[i],
                                  };
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ListTransaksiDetail(
                                        objParam: objParam);
                                  })).then((value) async {
                                    await getDashboardData();
                                    setState(() {});
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration:
                                      global.decCont(defWhite, 10, 10, 10, 10),
                                  child: Row(
                                    children: [
                                      Text("Detail    ",
                                          style:
                                              global.styleText5(12, defOrange)),
                                      Icon(Icons.arrow_forward_ios_rounded,
                                          color: defOrange, size: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    SizedBox(height: 10),
                    SizedBox(height: 200),
                  ],
                )),
          ),
        ),
      ],
    );
  }

  Icon getIconStatus(data) {
    Icon icon = Icon(Icons.access_time_rounded, color: defOrange, size: 14);
    if (data["status"] == "new")
      return Icon(Icons.access_time_rounded, color: defPurple, size: 14);
    if (data["status"] == "verification")
      return Icon(Icons.verified_rounded, color: defOrange, size: 14);
    if (data["status"] == "cancel")
      return Icon(Icons.cancel_outlined, color: defRed, size: 14);
    if (data["status"] == "pay")
      return Icon(Icons.payment, color: defGreen, size: 14);
    if (data["status"] == "deliver")
      return Icon(Icons.local_shipping_rounded, color: defOrange, size: 14);
    if (data["status"] == "succes")
      return Icon(Icons.check_circle_outline_rounded,
          color: defGreen, size: 14);
    return icon;
  }

  Text gettextStatus(data) {
    Text text = Text("  Menunggu", style: global.styleText6(14, defOrange));
    if (data["status"] == "new")
      return Text("  Menunggu Pembayaran",
          style: global.styleText6(14, defPurple));
    if (data["status"] == "verification")
      return Text("  Proses Verifikasi",
          style: global.styleText6(14, defOrange));
    if (data["status"] == "cancel")
      return Text("  Gagal / Dibatalkan", style: global.styleText6(14, defRed));
    if (data["status"] == "pay")
      return Text("  Dibayar", style: global.styleText6(14, defGreen));
    if (data["status"] == "deliver")
      return Text("  Pengiriman", style: global.styleText6(14, defOrange));
    if (data["status"] == "succes")
      return Text("  Selesai", style: global.styleText6(14, defGreen));
    return text;
  }
}
