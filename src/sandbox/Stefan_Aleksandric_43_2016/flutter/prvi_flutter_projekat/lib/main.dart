import 'package:flutter/material.dart';

void main() {
  ///home(Center)->child(Text)
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[900],
        title: Center(child: Text("Moja prva flutter aplikacija")),
      ),
      body: Stack(
        children: <Widget>[
          Image.asset('images/one_piece.jpg'),
          Text(
            'Djesi svete',
            style: TextStyle(
              fontFamily: 'DEADLY_FINISHER',
              fontSize: 50,
              color: Colors.red,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.purple[100],
    ),
  ));
}
