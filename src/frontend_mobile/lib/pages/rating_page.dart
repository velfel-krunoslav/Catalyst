import 'package:Kotarica/models/usersModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config.dart';
import '../models/ordersModel.dart';
import '../models/reviewsModel.dart';
import '../pages/rating.dart';
import 'package:provider/provider.dart';
import '../internals.dart';
import '../widgets.dart';

class RatingPage extends StatefulWidget {
  int productId;
  String assetUrl;
  String name;
  Function newReviewCallback;
  RatingPage(this.productId, this.name, this.assetUrl, this.newReviewCallback);

  @override
  _RatingPage createState() =>
      _RatingPage(productId, name, assetUrl, newReviewCallback);
}

class _RatingPage extends State<RatingPage> {
  int _rating;
  String desc = "";
  ReviewsModel reviewsModel;
  OrdersModel ordersModel;
  String assetUrl;
  String name;
  int productId;
  Function newReviewCallback;
  bool isLiked = false, isDisliked = false;
  _RatingPage(this.productId, this.name, this.assetUrl, this.newReviewCallback);
  @override
  Widget build(BuildContext context) {
    reviewsModel = Provider.of<ReviewsModel>(context);
    ordersModel = Provider.of<OrdersModel>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(BACKGROUND),
      appBar: AppBar(
        backgroundColor: Color(BACKGROUND),
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/ArrowLeft.svg", color: Color(FOREGROUND)),
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Color(FOREGROUND),
                          ),
                          child: Image.network(
                            assetUrl,
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    name, // TODO SUBSTR IF NAME TOO LONG
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(FOREGROUND)),
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
                          fontSize: 16,
                          fontFamily: 'Inter',
                          color: Color(BACKGROUND)),
                      fillColor: Color(LIGHT_GREY),
                      filled: true,
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Inter',
                          color: Color(DARK_GREY)),
                      counterStyle: TextStyle(
                        color: Color(FOREGROUND),
                        fontSize: 16,
                        fontFamily: 'Inter',
                      )),
                  // obscureText: false,
                  maxLength: 240,
                  maxLines: 7,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                color: Color(LIGHT_GREY),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text("Ocenite prodavca",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(FOREGROUND)),),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                isLiked ? isLiked = false : isLiked = true;
                                isDisliked = false;
                              });
                            },
                              child: Icon(Icons.thumb_up_alt_outlined,size: 35, color: isLiked ? Colors.green : Colors.black,)
                          ),
                          SizedBox(width: 20,),
                          InkWell(
                            onTap: (){
                              setState(() {
                                isDisliked ? isDisliked = false : isDisliked = true;
                                isLiked = false;
                              });
                            },
                              child: Icon(Icons.thumb_down_alt_outlined,size: 35, color: isDisliked ? Colors.deepOrangeAccent : Colors.black)
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: Column(
                  children: [
                    SizedBox(height: 15.0),
                    ButtonFill(
                      text: 'Dodaj recenziju',
                      onPressed: () {
                        if (_rating != null) {
                          reviewsModel
                              .checkForReview(usr.id, productId)
                              .then((value2) {
                            if (value2 == false) {
                              int r;
                              if (isLiked)
                                r = 1;
                              else if (isDisliked)
                                r = 0;
                              else
                                r = -1;
                              newReviewCallback(_rating, desc, r);
                              int count = 0;
                              Navigator.of(context)
                                  .popUntil((_) => count++ >= 2);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Već ste ostavili recenziju')));
                            }
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Niste ostavili ocenu')));
                        }
                      },
                    ),
                    SizedBox(height: 15.0),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
