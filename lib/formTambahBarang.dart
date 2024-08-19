import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  XFile? _image;

  final ImagePicker _picker = ImagePicker();

  void _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
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
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama Produk'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama produk tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
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
                controller: _descriptionController,
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
                  _image == null
                      ? Text('Belum ada foto')
                      : Image.file(
                          File(_image!.path),
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
                    if (_formKey.currentState!.validate()) {
                      // Proses data form di sini
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Form disubmit')),
                      );
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
}
