//import 'dart:html';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend_mobile/models/reviewsModel.dart';
import 'package:frontend_mobile/models/usersModel.dart';
import 'package:frontend_mobile/pages/product_reviews.dart';
import '../sizer_helper.dart'
    if (dart.library.html) '../sizer_web.dart'
    if (dart.library.io) '../sizer_io.dart';
import 'package:frontend_mobile/widgets.dart';
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
  final sizer = getSizer();
  int _current = 0;
  bool _stateChange = false;
  ProductEntryListingPage _data;
  var reviewsModel;

  void newReviewCallback2(int productId, int rating, String desc, int userId){
    reviewsModel.addReview(productId, rating, desc, usr.id);
  }

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
                height: sizer.getImageHeight(),
                width: double.infinity,
                child: Stack(
                  children: [
                    GestureDetector(
                        child: CarouselSlider(
                      options: CarouselOptions(
                          autoPlay: false,
                          height: sizer.getImageHeight(),
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          }),
                      items: _data.assetUrls.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              child: Image.asset(
                                '$i',
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            new FullscreenSlider(
                                                widget._data)));
                              },
                            );
                          },
                        );
                      }).toList(),
                    )),
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
                margin:
                    EdgeInsets.fromLTRB(0, sizer.getImageHeight() - 5, 0, 0),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    new MultiProvider(providers: [
                                      ChangeNotifierProvider<ReviewsModel>(
                                          create: (_) => ReviewsModel(_data.id)),
                                      ChangeNotifierProvider<UsersModel>(
                                          create: (_) => UsersModel()),
                                    ], child: ProductReviews(_data.id, newReviewCallback2))),
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
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(_data.vendor.photoUrl),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                    constraints: BoxConstraints(minHeight: 60),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(_data.vendor.name + " " + _data.vendor.surname,
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
                                                      child: Text(    //TODO dodati reputaciju za vendora
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
                            ButtonFill(
                                iconPath: 'assets/icons/ShoppingBag.svg',
                                text: 'Dodaj u korpu',
                                onPressed: () {
                                  Prefs.instance
                                      .containsKey('cartProducts')
                                      .then((exists) {
                                    Prefs.instance
                                        .getStringValue('cartProducts')
                                        .then((value) {
                                      if (exists == true &&
                                          (value.compareTo('') != 0)) {
                                        List<String> tmp = value.split(';');
                                        bool existsInCart = false;

                                        for (var e in tmp) {
                                          existsInCart =
                                              (int.parse(e.split(',')[0]) ==
                                                  _data.id);
                                        }

                                        if (!existsInCart) {
                                          Prefs.instance.setStringValue(
                                              'cartProducts',
                                              '$value;${_data.id},1');
                                        } else {
                                          //TODO THROW NOTIFICATION
                                        }
                                      } else {
                                        Prefs.instance.setStringValue(
                                            'cartProducts', '${_data.id},1');
                                      }
                                    });
                                  });
                                  Navigator.pop(context);
                                }),
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

class FullscreenSlider extends StatelessWidget {
  int _current = 0;
  ProductEntryListingPage _data;

  FullscreenSlider(ProductEntryListingPage _data) {
    this._data = _data;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                Builder(
                  builder: (context) {
                    final double height = MediaQuery.of(context).size.height;
                    return CarouselSlider(
                      options: CarouselOptions(
                        height: height,
                        viewportFraction: 1.0,
                        enlargeCenterPage: false,
                        // autoPlay: false,
                      ),
                      items: _data.assetUrls
                          .map((item) => Container(
                                child: Center(
                                    child: Image.asset(
                                  item,
                                  fit: BoxFit.cover,
                                  //height: height,
                                )),
                              ))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset('assets/icons/ArrowLeft.svg',
                            color: Colors.black),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: Size(36, 36)))
                  ],
                )
              ],
            )
          ],
        ));
  }
}
