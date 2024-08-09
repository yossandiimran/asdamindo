import 'package:asdamindo/helper/global.dart';
import 'package:flutter/material.dart';

class SearchProduk extends StatefulWidget {
  const SearchProduk({super.key, required this.title});
  final String title;
  @override
  State<SearchProduk> createState() => _SearchProdukState();
}

var product = [
  {"nama_produk": "Galon A", "harga": "20.000"},
  {"nama_produk": "Galon B", "harga": "20.000"},
  {"nama_produk": "Galon C", "harga": "13.000"},
  {"nama_produk": "Galon D", "harga": "4.000"},
  {"nama_produk": "Galon E", "harga": "5.000"},
  {"nama_produk": "Galon F", "harga": "7.000"},
  {"nama_produk": "Galon G", "harga": "14.000"},
  {"nama_produk": "Galon H", "harga": "32.000"},
  {"nama_produk": "Galon I", "harga": "44.000"},
  {"nama_produk": "Galon J", "harga": "50.000"},
  {"nama_produk": "Galon GG", "harga": "50.000"},
  {"nama_produk": "Galon DD", "harga": "50.000"},
  {"nama_produk": "Galon FG", "harga": "50.000"},
  {"nama_produk": "Galon AS", "harga": "50.000"},
  {"nama_produk": "Galon FF", "harga": "50.000"},
  {"nama_produk": "Galon HE", "harga": "50.000"},
  {"nama_produk": "Galon GE", "harga": "50.000"},
];

class _SearchProdukState extends State<SearchProduk> {
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
                SizedBox(height: 20),
                Container(
                  width: global.getWidth(context),
                  padding: EdgeInsets.all(22),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: global.decCont(defWhite, 20, 20, 20, 20),
                  child: Row(
                    children: [
                      Text("Cari Produk..."),
                      Spacer(),
                      Icon(Icons.search_rounded),
                    ],
                  ),
                ),
                SizedBox(height: 200),
                Text("Whoops, sayangnya barang yang anda cari tidak ditemukan ....")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
