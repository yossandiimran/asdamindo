import 'dart:convert';

import 'package:asdamindo/detailProduk.dart';
import 'package:asdamindo/helper/global.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class HomeWidgetKat extends StatefulWidget {
  const HomeWidgetKat({super.key, required this.title});
  final String title;
  @override
  State<HomeWidgetKat> createState() => _HomeWidgetKatState();
}

class _HomeWidgetKatState extends State<HomeWidgetKat> {
  Color bgColor = Color.fromRGBO(0, 162, 232, 1);
  TextEditingController searchKey = TextEditingController();
  List products = [];
  @override
  void initState() {
    getListProduct();
    super.initState();
  }

  Future<void> getListProduct() async {
    await pb
        .collection('view_produk_asdamindo')
        .getFullList(
            filter:
                'nama_produk ~ "${searchKey.text}" && kategori = "${widget.title == 'Air Minum' ? '1' : '2'}" ')
        .then((value) {
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
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: bgColor,
          centerTitle: true,
          title: Text(widget.title,
              style:
                  global.styleText5(global.getWidth(context) / 20, defWhite)),
        ),
        backgroundColor: Colors.blueGrey.shade50,
        body: Container(
          padding: EdgeInsets.all(10),
          height: global.getHeight(context),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  width: global.getWidth(context),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: global.decCont(defWhite, 20, 20, 20, 20),
                  child: TextField(
                    controller: searchKey,
                    onChanged: (val) {
                      getListProduct();
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search, color: defBlack1),
                    ),
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          element["nama_produk"]!,
                                          style:
                                              global.styleText5(12, defBlack1),
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                          element["owner"]!,
                                          style:
                                              global.styleText6(10, defBlack1),
                                          textAlign: TextAlign.start,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              global.formatRupiah(double.parse(
                                                  element["harga"]!)),
                                              style: global.styleText5(
                                                  11, defOrange),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
