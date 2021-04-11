import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend_mobile/models/reviewsModel.dart';
import 'package:frontend_mobile/pages/product_reviews.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:frontend_mobile/pages/inbox.dart';
import '../internals.dart';
import '../config.dart';
import 'inbox.dart';

class ProductEntryListing extends StatefulWidget {
  ProductEntryListingPage _data;
  ProductEntryListing(ProductEntryListingPage productData) {
    this._data = productData;
  }

  @override
  State<StatefulWidget> createState() {
    return _ProductEntryListing(this._data);
  }
}

class _ProductEntryListing extends State<ProductEntryListing> {
  int _current = 0;
  ProductEntryListingPage _data;
  var reviewsModel;
  _ProductEntryListing(ProductEntryListingPage _data) {
    this._data = _data;
  }
  @override
  Widget build(BuildContext context) {
    reviewsModel = Provider.of<ReviewsModel>(context);
    _data.averageReviewScore = reviewsModel.average;
    _data.numberOfReviews = reviewsModel.reviewsCount;
    return MaterialApp(
        home: SafeArea(
            child: Stack(
      children: [
        Stack(
          children: [
            Container(
                height: 240,
                width: double.infinity,
                child: Stack(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                          height: 240,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          }),
                      items: _data.assetUrls.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Image.asset(
                              '$i',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        );
                      }).toList(),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _data.assetUrls.map((assetUrl) {
                              int index = _data.assetUrls.indexOf(assetUrl);
                              return Padding(
                                padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                                child: SvgPicture.asset(
                                  _current == index
                                      ? 'assets/icons/CarouselActivePage.svg'
                                      : 'assets/icons/CarouselInctivePage.svg',
                                ),
                              );
                            }).toList()),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    )
                  ],
                )),
            Card(
                margin: EdgeInsets.fromLTRB(0, 235, 0, 0),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: double.infinity),
                        Text(
                          _data.name,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontFamily: 'Inter',
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w800),
                        ),
                        Text(
                          _data.price.toStringAsFixed(2) +
                              ' €' +
                              ' (' +
                              _data.quantifier.toString() +
                              ' ' +
                              ((_data.classification == Classification.Volume)
                                  ? 'ml'
                                  : ((_data.classification ==
                                          Classification.Weight)
                                      ? 'gr'
                                      : 'kom')) +
                              ')',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 28,
                              fontFamily: 'Inter',
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _data.description,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(height: 10),
                        reviewsModel.isLoading
                            ? Row(
                                children: [
                                  JumpingDotsProgressIndicator(
                                    fontSize: 20.0,
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Row(
                                    children: List<int>.generate(
                                        _data.averageReviewScore.round(),
                                        (i) => i + 1).map((e) {
                                      return SvgPicture.asset(
                                          'assets/icons/StarFilled.svg');
                                    }).toList(),
                                  ),
                                  Row(
                                    children: List<int>.generate(
                                        5 - _data.averageReviewScore.round(),
                                        (i) => i + 1).map((e) {
                                      return SvgPicture.asset(
                                          'assets/icons/StarOutline.svg');
                                    }).toList(),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '(' +
                                        _data.numberOfReviews.toString() +
                                        ')',
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Colors.black,
                                        fontSize: 14),
                                  )
                                ].toList(),
                              ),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                            onTap: () {
                              //print(_data.id.toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new ChangeNotifierProvider(
                                            create: (context) =>
                                                ReviewsModel(_data.id),
                                            child: ProductReviews())),
                              );
                            },
                            child: Text(
                              'Sve ocene ->',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Color(CYAN),
                                  fontSize: 17),
                            )),
                      ]),
                )),
            Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.asset(
                                      _data.userInfo.profilePictureAssetUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover),
                                ),
                                SizedBox(width: 10),
                                Container(
                                    constraints: BoxConstraints(minHeight: 60),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(_data.userInfo.fullName,
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w800,
                                                fontSize: 18,
                                                color: Colors.black)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                constraints: BoxConstraints(
                                                    minWidth: 24),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: Color(
                                                            GREEN_SUCCESSFUL))),
                                                child: Padding(
                                                  padding: EdgeInsets.all(3),
                                                  child: Center(
                                                      child: Text(
                                                    _data.userInfo
                                                        .reputationPositive
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize: 14,
                                                        color: Color(
                                                            GREEN_SUCCESSFUL)),
                                                  )),
                                                )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                                constraints: BoxConstraints(
                                                    minWidth: 24),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: Color(
                                                            RED_ATTENTION))),
                                                child: Padding(
                                                  padding: EdgeInsets.all(3),
                                                  child: Center(
                                                      child: Text(
                                                    _data.userInfo
                                                        .reputationNegative
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize: 14,
                                                        color: Color(
                                                            RED_ATTENTION)),
                                                  )),
                                                )),
                                          ],
                                        )
                                      ],
                                    )),
                                Spacer(),
                                TextButton(
                                    onPressed: () => {
                                          /*Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Inbox(
                                                      ChatUsers(
                                                          name: _data.userInfo
                                                              .fullName,
                                                          imageURL: _data
                                                              .userInfo
                                                              .profilePictureAssetUrl))))*/
                                        },
                                    child: SvgPicture.asset(
                                        'assets/icons/Envelope.svg',
                                        width: 38,
                                        height: 38,
                                        color: Color(DARK_GREY)),
                                    style: TextButton.styleFrom(
                                        backgroundColor: Color(LIGHT_GREY),
                                        minimumSize: Size(60, 60))),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextButton(
                                onPressed: () => {},
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.all(0),
                                    minimumSize: Size(double.infinity, 60)),
                                child: Ink(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(MINT),
                                          const Color(TEAL),
                                        ],
                                        stops: [0.0, 1.0],
                                        tileMode: TileMode.clamp,
                                      ),
                                      shape: BoxShape.rectangle,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Container(
                                    margin: EdgeInsets.zero,
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        SvgPicture.asset(
                                          'assets/icons/ShoppingBag.svg',
                                          color: Colors.white,
                                          width: 36,
                                          height: 36,
                                        ),
                                        SizedBox(
                                          width: 6,
                                          height: 60,
                                        ),
                                        Text('Dodaj u korpu',
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                color: Colors.white)),
                                        Spacer()
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        )),
                  ],
                ))
          ],
        ),
        Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 20),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset('assets/icons/ArrowLeft.svg',
                        color: Colors.black),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(36, 36))),
                Spacer(),
                TextButton(
                    onPressed: () {},
                    child: SvgPicture.asset(
                        'assets/icons/DotsThreeVertical.svg',
                        color: Colors.black),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(36, 36))),
                SizedBox(width: 20),
              ],
            ),
          ],
        ),
      ],
    )));
  }
}
