import 'dart:io';

import 'package:asdamindo/formTambahBarang.dart';
import 'package:asdamindo/helper/global.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List products = [];

  @override
  void initState() {
    getFullList();
    super.initState();
  }

  Future<void> getFullList() async {
    await pb.collection('produk').getFullList(filter: "id_user = '${preference.getData("id")}'").then((value) {
      print(value);
      products = value;
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

  void _navigateToAddProductScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductForm(),
      ),
    ).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Produk Anda'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navigateToAddProductScreen,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          print(product.nama_produk);
          return ListTile(
              // leading: product.foto_produk != []
              //     ? Image.file(
              //         product.foto_produk[0],
              //         width: 50,
              //         height: 50,
              //         fit: BoxFit.cover,
              //       )
              //     : Icon(Icons.image, size: 50),
              // title: Text(product.nama_produk),
              // subtitle: Text(
              //   '${product.harga.toStringAsFixed(2)} - ${product.keterangan}',
              // ),
              );
        },
      ),
    );
  }
}
