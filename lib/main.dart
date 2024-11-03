import 'package:flutter/material.dart';
import 'screens/product_list_screen.dart';

void main() {
  runApp(ProductListApp());
}

class ProductListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
      theme: ThemeData(
        primaryColor: Color(0xFF005960),
        scaffoldBackgroundColor: Color(0xFFF7F3E9),
      ),
      home: ProductListScreen(),
    );
  }
}
