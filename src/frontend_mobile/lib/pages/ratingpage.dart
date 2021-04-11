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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/ArrowLeft.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: SafeArea(
          child: Center(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(
                      "assets/avatars/vendor_adrew_ballantyne_cc_by.jpg"),
                ),
                Text(
                  "Petar Nikolic",
                  style: TextStyle(fontWeight: FontWeight.w800),
                )
              ],
            ),
          ),
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
            SizedBox(
              height: 40,
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: "Unesi komentar",
                  // labelText: "Dodaj komentar",
                  labelStyle: TextStyle(
                      fontSize: 16, fontFamily: 'Inter', color: Color(BLACK)),
                  border: InputBorder.none,
                  //border: OutlineInputBorder(),
                  fillColor: Color(LIGHT_GREY),
                  filled: true),
              // obscureText: false,
              maxLength: 240,
              maxLines: 6,
            ),
            SizedBox(
              height: 120,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  SizedBox(height: 15.0),
                  ButtonFill(
                    text: 'Dodaj recenziju',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new RatingPage()),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
