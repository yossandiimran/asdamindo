// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:asdamindo/detailProduk.dart';
import 'package:asdamindo/helper/global.dart';
import 'package:asdamindo/homeWidgetKat.dart';
import 'package:asdamindo/homeWidgetLegal.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key, required this.title});
  final String title;
  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List products = [];
  @override
  void initState() {
    getListProduct();
    super.initState();
  }

  Future<void> getListProduct() async {
    await pb.collection('view_produk_join_user').getFullList().then((value) {
      products = jsonDecode(value.toString());
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
        floatingActionButton: GestureDetector(
          onTap: () async {
            var text = '';
            final encodedText = Uri.encodeComponent(text);
            final url = 'https://wa.me/6282295246660?text=${encodedText}';
            await launchUrlString(
              url,
              mode: LaunchMode.externalApplication,
            );
          },
          child: Container(
            width: global.getWidth(context) / 2.5,
            padding: EdgeInsets.all(15),
            decoration: global.decCont2(defGreen, 10, 10, 10, 10),
            child: Row(
              children: [
                Spacer(),
                Icon(Icons.message, color: defWhite, size: 12),
                Spacer(),
                Text("Hubungi Via Whatsapp", style: global.styleText5(12, defWhite)),
                Spacer(),
              ],
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          height: global.getHeight(context),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                // Container(
                //   width: global.getWidth(context),
                //   padding: EdgeInsets.all(20),
                //   margin: EdgeInsets.symmetric(horizontal: 8),
                //   decoration: global.decCont(defWhite, 20, 20, 20, 20),
                //   child: Row(
                //     children: [
                //       Text("Cari Produk..."),
                //       Spacer(),
                //       Icon(Icons.search_rounded),
                //     ],
                //   ),
                // ),
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return HomeWidgetKat(title: "Air Minum");
                          }));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          width: global.getWidth(context) * 0.35,
                          decoration: global.decCont(defWhite, 10, 10, 10, 10),
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: [
                              Icon(Icons.water, color: defBlue),
                              Text("Air Minum"),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return HomeWidgetKat(title: "Air Gunung");
                          }));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          width: global.getWidth(context) * 0.35,
                          decoration: global.decCont(defWhite, 10, 10, 10, 10),
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: [
                              Icon(Icons.water_drop_rounded, color: defBlue),
                              Text("Air Gunung"),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return HomeWidgetKat(title: "Alat Depot");
                          }));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          width: global.getWidth(context) * 0.35,
                          decoration: global.decCont(defWhite, 10, 10, 10, 10),
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: [
                              Icon(Icons.bubble_chart_rounded, color: defBlue),
                              Text("Alat Depot"),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return HomeWidgetLegal();
                          }));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          width: global.getWidth(context) * 0.35,
                          decoration: global.decCont(defWhite, 10, 10, 10, 10),
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: [
                              Icon(Icons.verified_user_rounded, color: defBlue),
                              Text("Legalitas"),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: products.map((element) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return DetailBarang(obj: element);
                        }));
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: defWhite,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          image: DecorationImage(
                            image: NetworkImage(
                              "${global.baseIp}/api/files/${element["collectionId"]}/${element["id"]}/${element["foto_produk"]}",
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: global.decCont(
                                        defWhite,
                                        // Color.fromRGBO(0, 162, 232, 1)
                                        //     .withOpacity(0.8),
                                        10,
                                        10,
                                        0,
                                        0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          element["nama_produk"]!,
                                          style: global.styleText5(12, defBlack1),
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                          element["owner"]!,
                                          style: global.styleText6(10, defBlack1),
                                          textAlign: TextAlign.start,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              global.formatRupiah(double.parse(element["harga"]!)),
                                              style: global.styleText5(11, defOrange),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.more_horiz,
                                              color: defBlack1,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: kToolbarHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
