//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/models/reviewsModel.dart';
import 'package:frontend_mobile/pages/blank_page.dart';
import 'package:frontend_mobile/pages/product_reviews.dart';
import 'package:frontend_mobile/pages/rating.dart';
import 'package:provider/provider.dart';

import '../widgets.dart';

class RatingPage extends StatefulWidget {
  int productId;
  Function newReviewCallback;
  RatingPage(this.productId, this.newReviewCallback);

  @override
  _RatingPage createState() => _RatingPage(productId, newReviewCallback);
}

class _RatingPage extends State<RatingPage> {
  int _rating;
  String desc;
  ReviewsModel reviewsModel;
  int productId;
  Function newReviewCallback;
  _RatingPage(this.productId, this.newReviewCallback);
  @override
  Widget build(BuildContext context) {
    reviewsModel = Provider.of<ReviewsModel>(context);
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
            child: Text(
              'Nova recenzija',
              style: TextStyle(
                  color: Color(DARK_GREY),
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(
                      "assets/avatars/vendor_andrew_ballantyne_cc_by.jpg"),
                ),
                Text(
                  "Petar Nikolic",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
            Rating((rating) {
              setState(() {
                _rating = rating;
              });
            }),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                onChanged: (text) {
                  desc = text;
                },
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
                maxLines: 7,
              ),
            ),
            SizedBox(
              height: 150,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Column(
                children: [
                  SizedBox(height: 15.0),
                  ButtonFill(
                    text: 'Dodaj recenziju',
                    onPressed: () {
                      //reviewsModel.addReview(productId, _rating, desc, 0);
                      newReviewCallback(_rating, desc);
                      int count = 0;
                      Navigator.of(context).popUntil((_) => count++ >= 2);
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
