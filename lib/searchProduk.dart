import 'dart:convert';

import 'package:asdamindo/detailProduk.dart';
import 'package:asdamindo/helper/global.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class SearchProduk extends StatefulWidget {
  const SearchProduk({super.key, required this.title});
  final String title;
  @override
  State<SearchProduk> createState() => _SearchProdukState();
}

class _SearchProdukState extends State<SearchProduk> {
  TextEditingController searchKey = TextEditingController();
  var products = [];
  @override
  void initState() {
    super.initState();
  }

  getListProduct() async {
    await pb
        .collection('view_produk_join_user')
        .getFullList(filter: 'nama_produk ~ "${searchKey.text}" || owner ~ "${searchKey.text}"')
        .then((value) {
      products = jsonDecode(value.toString());
      setState(() {});
      print(products);
    }).catchError((err) {
      try {
        ClientException error = err;
        print(error);
        var dynamicData = error.response["data"];
        for (var key in dynamicData.keys) {
          var valueList = dynamicData[key]!;
          return global.alertWarning(context, valueList["message"].toString());
        }
        return global.alertWarning(context, "Data kosong !");
      } catch (err2) {
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
                Container(
                  width: global.getWidth(context),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: global.decCont(defWhite, 20, 20, 20, 20),
                  child: TextField(
                    controller: searchKey,
                    onChanged: (val) {
                      getListProduct();
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search, color: defBlack1),
                      hintText: 'Cari Produk /  Penjual',
                    ),
                  ),
                ),
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                            image: NetworkImage(
                              "${global.baseIp}/api/files/${element["collectionId"]}/${element["id"]}/${element["foto_produk"]}",
                            ),
                            fit: BoxFit.cover,
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
                                    decoration:
                                        global.decCont(Color.fromRGBO(0, 162, 232, 1).withOpacity(0.8), 10, 10, 0, 0),
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
