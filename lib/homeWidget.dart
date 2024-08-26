import 'dart:convert';

import 'package:asdamindo/detailProduk.dart';
import 'package:asdamindo/helper/global.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

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
    await pb.collection('produk').getFullList().then((value) {
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
        body: Container(
          padding: EdgeInsets.all(5),
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
                        margin: EdgeInsets.all(10),
                        decoration: global.decCont(Color.fromRGBO(143, 148, 251, 1).withOpacity(0.2), 10, 10, 10, 10),
                        child: Stack(
                          children: [
                            element["foto_produk"] != []
                                ? Container(
                                    padding: EdgeInsets.all(5),
                                    child: Image.network(
                                      "${global.baseIp}/api/files/${element["collectionId"]}/${element["id"]}/${element["foto_produk"][0]}",
                                    ),
                                  )
                                : Icon(Icons.image, size: 50),
                            Container(
                              child: Column(
                                children: [
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration:
                                        global.decCont(Color.fromRGBO(143, 148, 251, 1).withOpacity(0.8), 10, 10, 0, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          element["nama_produk"]!,
                                          style: global.styleText5(12, Colors.white),
                                          textAlign: TextAlign.start,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              global.formatRupiah(double.parse(element["harga"]!)),
                                              style: global.styleText6(11, Colors.white),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.shopping_bag_rounded,
                                              color: defWhite,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
