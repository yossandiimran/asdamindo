// ignore_for_file: prefer_typing_uninitialized_variables, no_logic_in_create_state

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
    await pb.collection('transaksi_detail').getFullList(filter: "id_transaksi = '${objParam["id"]}'").then((value) {
      var listOrderDetail = jsonDecode(value.toString());
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
                Container(
                  child: ListTile(
                    title: Text("Note"),
                    subtitle: Text(noteController),
                  ),
                ),
                Container(
                  child: ListTile(
                    title: Text("Total Belanja"),
                    subtitle: Text(global.formatRupiah(grandTotal.toDouble())),
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
