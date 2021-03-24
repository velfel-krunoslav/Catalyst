import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import './internals.dart';
import './config.dart';

List<String> items = [
  'washed_rind_cheese_paul_asman_jill_lenoble_by.jpg',
  'martin_cathrae_by_sa.jpg',
  'honey_shawn_caza_cc_by_sa.jpg'
];

class ProductEntryListing extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductEntryListing();
  }
}

class _ProductEntryListing extends State<ProductEntryListing> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
        home: Stack(
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
                      items: items.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Image.asset(
                              'assets/product_listings/$i',
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
                            children: items.map((assetUrl) {
                              int index = items.indexOf(assetUrl);
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
                          'Kamamber',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontFamily: 'Inter',
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w800),
                        ),
                        Text(
                          '29.90€ (500g)',
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
                          'Meki sir od kravljeg mleka obložen belom plesni specifičnog ukusa. Specifične je arome i mekane do pastozne konzistencije, s tvrdom koricom spolja. Njegovo zrenje traje od jednog do dva meseca. Priprema se od punomasnog kravljeg mleka. Uz beli zreli sir, kakav je kamamber, preporučuju se mlada crvena voćna vina. ',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SvgPicture.asset('assets/icons/StarFilled.svg'),
                            SvgPicture.asset('assets/icons/StarFilled.svg'),
                            SvgPicture.asset('assets/icons/StarFilled.svg'),
                            SvgPicture.asset('assets/icons/StarFilled.svg'),
                            SvgPicture.asset('assets/icons/StarOutline.svg'),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '(6)',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.black,
                                  fontSize: 14),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Sve ocene ->',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Color(CYAN),
                              fontSize: 14),
                        ),
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
                                      'assets/avatars/vendor_andrew_ballantyne_cc_by.jpg',
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
                                        Text('Puniša Radojević',
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
                                                    '356',
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
                                                    '0',
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
                                    onPressed: () => {},
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
                    onPressed: () {},
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
    ));
  }
}
