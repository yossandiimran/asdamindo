// ignore_for_file: prefer_typing_uninitialized_variables, no_logic_in_create_state, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:io';
import 'package:asdamindo/helper/global.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ListTransaksiFormPembayaran extends StatefulWidget {
  final objParam;
  const ListTransaksiFormPembayaran({super.key, required this.objParam});
  @override
  _ListTransaksiFormPembayaranState createState() =>
      _ListTransaksiFormPembayaranState(objParam);
}

class _ListTransaksiFormPembayaranState
    extends State<ListTransaksiFormPembayaran> {
  final formKey = GlobalKey<FormState>();
  var nameController = "";
  var noteController = "";
  var descriptionController = "";
  var grandTotal = 0;
  XFile? imageFile;

  final ImagePicker _picker = ImagePicker();
  final objParam;
  _ListTransaksiFormPembayaranState(this.objParam);

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
          'Upload Bukti Pembayaran',
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
                    title: Text("Keterangan"),
                    subtitle: Text(descriptionController),
                  ),
                ),
                // Card(
                //   child: ListTile(
                //     title: Text("Note"),
                //     subtitle: Text(noteController),
                //   ),
                // ),
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
                        title: Text("Total Yang Harus Dibayar"),
                        subtitle: Text(global.formatRupiah(
                            grandTotal.toDouble() +
                                (grandTotal.toDouble() * 0.10))),
                      ),
                    ),
                    Text(
                      "Pembayaran harap melalui no rek\nBCA 639-573-5184\na/n. Erik Garnadi",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: defBlack1,
                        fontSize: 12,
                      ),
                    ),
                  ],
                )),
                SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    imageFile == null
                        ? Text('Belum ada foto')
                        : Image.file(
                            File(imageFile!.path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Pilih Foto'),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        processFormCreate();
                      }
                    },
                    child: Text('Kirim'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> processFormCreate() async {
    try {
      pb.collection('transaksi').update(
        objParam["id"],
        body: {'status': "verification"},
        files: [
          await http.MultipartFile.fromPath('bukti_transaksi', imageFile!.path),
        ],
      ).then((record) {
        Navigator.pop(context);
        global.alertSuccess(
          context,
          "Berhasil Mengupload Bukti Bayar, mohon untuk melakukan konfirmasi kepada admin asdamindo",
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
