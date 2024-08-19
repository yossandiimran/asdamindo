import 'dart:io';

import 'package:asdamindo/formTambahBarang.dart';
import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;
  final String description;
  final File? image;

  Product({
    required this.name,
    required this.price,
    required this.description,
    this.image,
  });
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final List<Product> _products = [];

  void _addProduct(Product product) {
    setState(() {
      _products.add(product);
    });
  }

  void _navigateToAddProductScreen() async {
    final newProduct = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductForm(),
      ),
    );

    if (newProduct != null) {
      _addProduct(newProduct as Product);
    }
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
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ListTile(
            leading: product.image != null
                ? Image.file(
                    product.image!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.image, size: 50),
            title: Text(product.name),
            subtitle: Text(
              '${product.price.toStringAsFixed(2)} - ${product.description}',
            ),
          );
        },
      ),
    );
  }
}
