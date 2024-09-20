// ignore_for_file: prefer_typing_uninitialized_variables, no_logic_in_create_state, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:asdamindo/helper/global.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ListTransaksiDetail extends StatefulWidget {
  final objParam;
  const ListTransaksiDetail({super.key, required this.objParam});
  @override
  _ListTransaksiDetailState createState() => _ListTransaksiDetailState(objParam);
}

class _ListTransaksiDetailState extends State<ListTransaksiDetail> {
  final formKey = GlobalKey<FormState>();
  var nameController = "";
  var noteController = "";
  var descriptionController = "";
  var grandTotal = 0;
  XFile? imageFile;
  var listOrderDetail = [];

  final objParam;
  _ListTransaksiDetailState(this.objParam);

  @override
  void initState() {
    super.initState();
    getInitState();
  }

  getInitState() async {
    nameController = objParam["id"];
    descriptionController = objParam["keterangan"];
    noteController = objParam["catatan"];
    await pb
        .collection('transaksi_detail_view')
        .getFullList(filter: "id_transaksi = '${objParam["id"]}'")
        .then((value) {
      listOrderDetail = jsonDecode(value.toString());
      grandTotal = 0;
      for (var i = 0; i < listOrderDetail.length; i++) {
        grandTotal =
            grandTotal + (int.parse(listOrderDetail[i]["harga_satuan"]) * int.parse(listOrderDetail[i]["qty"]));
      }
      setState(() {});
      setState(() {});
    }).catchError((err) {
      try {
        print(err);
        Navigator.pop(context);
        return global.alertWarning(context, "Data kosong !");
      } catch (err2) {
        Navigator.pop(context);
        print(err2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(
          'Detail Order',
          style: global.styleText5(15, defBlack1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  child: Column(
                    children: [
                      Container(
                        child: ListTile(
                          title: Text("Id Transaksi"),
                          subtitle: Text(nameController),
                        ),
                      ),
                      Container(
                        child: ListTile(
                          title: Text("Keterangan"),
                          subtitle: Text(descriptionController),
                        ),
                      ),
                      // Container(
                      //   child: ListTile(
                      //     title: Text("Note"),
                      //     subtitle: Text(noteController),
                      //   ),
                      // ),
                      Container(
                        child: ListTile(
                          title: Text("Belanja"),
                          subtitle: Text(
                            "Total : " +
                                global.formatRupiah(grandTotal.toDouble()) +
                                "\nBiaya Penanganan (10%) : " +
                                global.formatRupiah(grandTotal.toDouble() * 0.10),
                          ),
                        ),
                      ),
                      Container(
                        child: ListTile(
                          title: Text("Total Belanja + Biaya Penanganan"),
                          subtitle: Text(global.formatRupiah(grandTotal.toDouble() + (grandTotal.toDouble() * 0.10))),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Container(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("List Barang yang di order :")),
                Divider(),
                for (var i = 0; i < listOrderDetail.length; i++)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: global.decCont(defWhite, 0, 0, 0, 0),
                    child: ListTile(
                      leading: SizedBox(
                        width: 60,
                        child: Image.network(
                          "${global.baseIp}/api/files/${listOrderDetail[i]["collectionId"]}/${listOrderDetail[i]["id"]}/${listOrderDetail[i]["foto_produk"]}",
                        ),
                      ),
                      title: Text(listOrderDetail[i]["nama_produk"], style: global.styleText4(13)),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Seller : " + listOrderDetail[i]["penjual"], style: global.styleText4(13)),
                          Row(
                            children: [
                              Text("${listOrderDetail[i]["qty"]}", style: global.styleText5(13, defGrey)),
                              Text(" x ", style: global.styleText5(13, defGrey)),
                              Text(global.formatRupiah(double.parse(listOrderDetail[i]["harga_satuan"])),
                                  style: global.styleText5(13, defGrey)),
                              Spacer(),
                              Text(
                                global.formatRupiah(double.parse(listOrderDetail[i]["harga_satuan"].toString()) *
                                    double.parse(listOrderDetail[i]["qty"])),
                                style: global.styleText5(13, defBlack1),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
