import 'package:flutter/material.dart';
import 'package:flutter_application_1/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login page',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        textSelectionColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Homepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

