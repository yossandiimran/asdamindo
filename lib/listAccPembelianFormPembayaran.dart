// ignore_for_file: prefer_typing_uninitialized_variables, no_logic_in_create_state

import 'dart:convert';
import 'package:asdamindo/helper/global.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ListAccPembelianFormPembayaran extends StatefulWidget {
  final objParam;
  const ListAccPembelianFormPembayaran({super.key, required this.objParam});
  @override
  _ListAccPembelianFormPembayaranState createState() =>
      _ListAccPembelianFormPembayaranState(objParam);
}

class _ListAccPembelianFormPembayaranState
    extends State<ListAccPembelianFormPembayaran> {
  final formKey = GlobalKey<FormState>();
  var nameController = "";
  var noteController = "";
  var descriptionController = "";
  var grandTotal = 0;
  XFile? imageFile;

  final ImagePicker _picker = ImagePicker();
  final objParam;
  _ListAccPembelianFormPembayaranState(this.objParam);

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
        .collection('transaksi_detail')
        .getFullList(filter: "id_transaksi = '${objParam["id"]}'")
        .then((value) {
      var listOrderDetail = jsonDecode(value.toString());
      grandTotal = 0;
      for (var i = 0; i < listOrderDetail.length; i++) {
        grandTotal = grandTotal +
            (int.parse(listOrderDetail[i]["harga_satuan"]) *
                int.parse(listOrderDetail[i]["qty"]));
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

  void _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(
          'Verifikasi Pembayaran',
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
                  child: ListTile(
                    title: Text("Id Transaksi"),
                    subtitle: Text(nameController),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text("Pembeli"),
                    subtitle: Text(objParam["info"]["nama"]),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text("Keterangan"),
                    subtitle: Text(descriptionController),
                  ),
                ),
                Card(
                    child: Column(
                  children: [
                    Container(
                      child: ListTile(
                        subtitle: Text(
                          "Belanja : " +
                              global.formatRupiah(grandTotal.toDouble()) +
                              "\nBiaya Penanganan (10%) : " +
                              global.formatRupiah(grandTotal.toDouble() * 0.10),
                        ),
                      ),
                    ),
                    Container(
                      child: ListTile(
                        title: Text("Total Yang Dibayarkan"),
                        subtitle: Text(global.formatRupiah(
                            grandTotal.toDouble() +
                                (grandTotal.toDouble() * 0.10))),
                      ),
                    ),
                  ],
                )),
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: global.getWidth(context),
                  child: Image.network(
                    "${global.baseIp}/api/files/${objParam["info"]["collectionId"]}/${objParam["info"]["id"]}/${objParam["info"]["bukti_transaksi"]}",
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Spacer(),
                    Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.green),
                        ),
                        onPressed: () {
                          global.alertConfirmation(
                            context: context,
                            action: () {
                              processFormCreate("pay");
                            },
                            message: "Yakin untuk Acc?",
                          );
                        },
                        child: Text('  Acc  ',
                            style: global.styleText5(14, defWhite)),
                      ),
                    ),
                    SizedBox(width: 20),
                    Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.red),
                        ),
                        onPressed: () {
                          global.alertConfirmation(
                            context: context,
                            action: () {
                              processFormCreate("cancel");
                            },
                            message: "Tolak pembayaran?",
                          );
                        },
                        child: Text('Tolak',
                            style: global.styleText5(14, defWhite)),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> processFormCreate(status) async {
    global.loadingAlert(context, "Mohon tunggu...", false);
    try {
      pb.collection('transaksi').update(
        objParam["id"],
        body: {'status': status},
      ).then((record) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        global.alertSuccess(
          context,
          "Berhasil memproses transaksi !",
        );
      }).catchError((err) {
        print(err);
        try {
          Navigator.pop(context);
          return global.alertWarning(context, "Koneksi internet tidak stabil");
        } catch (err2) {
          Navigator.pop(context);
          return global.alertWarning(context, "Koneksi internet tidak stabil");
        }
      });
    } catch (err) {
      return global.alertWarning(context, "Foto wajib diupload!");
    }
  }
}
