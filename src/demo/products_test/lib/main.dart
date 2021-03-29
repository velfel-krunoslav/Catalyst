import 'package:flutter/material.dart';
import 'package:products_test/ProductsModel.dart';
import 'package:provider/provider.dart';

import 'Products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductsModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        
        home: Products(),
      ),
    );
  }
}
