/*import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/pages/blank_page.dart';
//import 'package:rate_my_app/rate_my_app.dart';
//import '../internals.dart';
//import '../config.dart';
//import '../widgets.dart';
import 'package:flutter/rendering.dart';
//import 'package:frontend_mobile/models/reviewsModel.dart';
//import 'package:frontend_mobile/pages/product_reviews.dart';
//import 'package:progress_indicators/progress_indicators.dart';
//import 'package:provider/provider.dart';
//import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddReviews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Row(
                children: [
                  IconButton(
                      icon: SvgPicture.asset("assets/icons/ArrowLeft.svg"),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          maxRadius: 36,
                          child: CircleAvatar(
                            radius: 36,
                            backgroundImage: AssetImage(
                              "assets/avatars/vendor_adrew_ballantyne_cc_by.jpg",
                            ),
                          ),
                        ),
                        Text("Petar Nikolic",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Inter'))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(children: [
              /*ButtonFill(
                  text: 'Dodaj recenziju',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => new Blank()));
                  }),*/
            ]),
            /* RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            )*/
          ],
        ));
  }
}*/
/*
class Blank extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
*/
