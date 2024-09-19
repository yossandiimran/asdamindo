import 'dart:convert';

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
    var filter = "";
    if (preference.getData("is_member") == "true") {
      filter = "id_user = '${preference.getData("id")}'";
    }
    await pb.collection('view_produk_join_user').getFullList(filter: filter).then((value) {
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          ),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios, color: defWhite)),
        title: Text('Daftar Produk', style: global.styleText5(global.getWidth(context) / 18, defWhite)),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(0, 162, 232, 1),
      ),
      body: ListView(
        children: [
          SizedBox(height: 10),
          for (var i = 0; i < products.length; i++) getChildList(products[i]),
          SizedBox(height: kToolbarHeight * 2)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: defBlue,
        onPressed: _navigateToAddProductScreen,
        child: Icon(Icons.add_circle_outline_rounded, color: defWhite),
      ),
    );
  }

  Widget getChildList(product) {
    Widget widget = Container(
      decoration: global.decCont2(defWhite, 10, 10, 10, 10),
      margin: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
      child: ListTile(
        leading: product["foto_produk"] != []
            ? Image.network(
                "${global.baseIp}/api/files/${product["collectionId"]}/${product["id"]}/${product["foto_produk"][0]}",
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : Icon(Icons.image, size: 50),
        title: Text(product["nama_produk"]),
        subtitle: Text(
          '${global.formatRupiah(double.parse(product["harga"]))}\nOwner : ${product["owner"]}',
        ),
        trailing: IconButton(onPressed: () {}, icon: Icon(Icons.delete, color: defRed)),
      ),
    );
    return widget;
  }
}
