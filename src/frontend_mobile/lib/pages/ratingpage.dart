//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/pages/rating.dart';

import '../widgets.dart';

class RatingPage extends StatefulWidget {
  @override
  _RatingPage createState() => _RatingPage();
}

class _RatingPage extends State<RatingPage> {
  int _rating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/ArrowLeft.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Rating((rating) {
              setState(() {
                _rating = rating;
              });
            }),
            TextField(
              decoration: InputDecoration(
                  hintText: "Unesi komentar",
                  labelText: "Dodaj komentar",
                  labelStyle: TextStyle(
                      fontSize: 16, fontFamily: 'Inter', color: Color(BLACK)),
                  // border: InputBorder.none,
                  border: OutlineInputBorder(),
                  fillColor: Color(LIGHT_GREY),
                  filled: true),
              // obscureText: false,
              maxLength: 240,
              //maxLines: 6,
            ),
            /* SizedBox(
              height: 60,
            ),*/
            ButtonFill(
              text: 'Dodaj recenziju',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => new RatingPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
