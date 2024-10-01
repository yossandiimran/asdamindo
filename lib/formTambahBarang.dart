// ignore_for_file:

import 'dart:io';
import 'package:asdamindo/helper/global.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

class ProductForm extends StatefulWidget {
  final product;
  const ProductForm({super.key, required this.product});
  @override
  _ProductFormState createState() => _ProductFormState(product);
}

class _ProductFormState extends State<ProductForm> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  XFile? imageFile;
  String dropdownValue = 'Lainnya';

  final ImagePicker _picker = ImagePicker();

  final product;
  _ProductFormState(this.product);

  @override
  void initState() {
    getInit();
    super.initState();
  }

  getInit() async {
    if (product != null) {
      nameController.text = product["nama_produk"];
      priceController.text = product["harga"];
      descriptionController.text = product["keterangan"];
      dropdownValue = product["kategori"] == "1"
          ? "Air Minum"
          : product["kategori"] == "2"
              ? "Air Gunung"
              : product["kategori"] == "4"
                  ? "Alat Depot"
                  : "Lainnya";
    }
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
      appBar: AppBar(
        title: Text(product == null ? 'Input Produk' : "Edit Produk"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama Produk'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama produk tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Keterangan'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Keterangan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: dropdownValue,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  border: UnderlineInputBorder(),
                ),
                items: <String>['Air Minum', 'Air Gunung', 'Lainnya', 'Alat Depot']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                // Callback when the selected item changes
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  imageFile == null
                      ? product != null
                          ? Image.network(
                              "${global.baseIp}/api/files/${product["collectionId"]}/${product["id"]}/${product["foto_produk"]}",
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Text('Belum ada foto')
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
                      // // Proses data form di sini
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(content: Text('Form disubmit')),
                      // );
                      processFormCreate();
                    }
                  },
                  child: Text(product == null ? 'Kirim' : 'update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> processFormCreate() async {
    if (product == null) {
      print(imageFile!.path);
      pb.collection('produk').create(
        body: {
          'id_user': preference.getData("id"),
          'nama_produk': nameController.text,
          'harga': priceController.text,
          'keterangan': descriptionController.text,
          'kategori': dropdownValue == "Air Minum"
              ? "1"
              : dropdownValue == "Air Gunung"
                  ? "2"
                  : dropdownValue == "Alat Depot"
                      ? "4"
                      : "3",
          'status': false,
        },
        files: [
          await http.MultipartFile.fromPath('foto_produk', imageFile!.path),
        ],
      ).then((record) {
        Navigator.pop(context);
        global.alertSuccess(context, "Berhasil menambahkan produk");
      }).catchError((err) {
        print(err);
        try {
          ClientException error = err;
          print(error);
          Navigator.pop(context);
          var dynamicData = error.response["data"];
          for (var key in dynamicData.keys) {
            var valueList = dynamicData[key]!;
            return global.alertWarning(context, valueList["message"].toString());
          }
          return global.alertWarning(context, "Username / Email & Password salah");
        } catch (err2) {
          Navigator.pop(context);
          print(err2);
        }
      });
    } else {
      pb.collection('produk').update(
        product['id'],
        body: {
          'nama_produk': nameController.text,
          'harga': priceController.text,
          'keterangan': descriptionController.text,
          'status': false,
          'kategori': dropdownValue == "Air Minum"
              ? "1"
              : dropdownValue == "Air Gunung"
                  ? "2"
                  : dropdownValue == "Alat Depot"
                      ? "4"
                      : "3",
        },
        files: [
          imageFile != null
              ? await http.MultipartFile.fromPath('foto_produk', imageFile!.path)
              : http.MultipartFile.fromBytes(
                  'foto_produk',
                  (await http.get(Uri.parse(
                    "${global.baseIp}/api/files/${product["collectionId"]}/${product["id"]}/${product["foto_produk"]}",
                  )))
                      .bodyBytes,
                  filename: "existing_file.jpg",
                ),
        ],
      ).then((record) {
        Navigator.pop(context);
        global.alertSuccess(context, "Berhasil Mengupdate produk");
      }).catchError((err) {
        print(err);
        try {
          ClientException error = err;
          print(error);
          Navigator.pop(context);
          var dynamicData = error.response["data"];
          for (var key in dynamicData.keys) {
            var valueList = dynamicData[key]!;
            return global.alertWarning(context, valueList["message"].toString());
          }
          return global.alertWarning(context, "Username / Email & Password salah");
        } catch (err2) {
          Navigator.pop(context);
          print(err2);
        }
      });
    }
  }
}
