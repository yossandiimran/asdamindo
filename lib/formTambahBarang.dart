import 'dart:io';
import 'package:asdamindo/helper/global.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  XFile? imageFile;

  final ImagePicker _picker = ImagePicker();

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
        title: Text('Input Barang'),
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
                      // // Proses data form di sini
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(content: Text('Form disubmit')),
                      // );
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
    );
  }

  Future<void> processFormCreate() async {
    print(imageFile!.path);
    pb.collection('produk').create(
      body: {
        'id_user': preference.getData("id"),
        'nama_produk': nameController.text,
        'harga': priceController.text,
        'keterangan': descriptionController.text,
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
  }
}
