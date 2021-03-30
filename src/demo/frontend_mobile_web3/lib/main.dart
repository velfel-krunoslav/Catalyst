import 'package:flutter/material.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/pages/consumer_home.dart';
import 'package:frontend_mobile/pages/welcome.dart';
import 'package:frontend_mobile/productsModel.dart';
import 'package:provider/provider.dart';
import 'Products.dart';
import 'pages/product_entry_listing.dart';

void main() {
  //runApp(MaterialApp(home: Products()));
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductsModel(),
      child: MaterialApp(
        title: "blabla",
        home: ConsumerHomePage(),
      ),
    );
  }
}
