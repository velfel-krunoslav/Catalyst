import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/pages/consumer_home.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'blank_page.dart';

class ConsumerCart extends StatefulWidget {
  @override
  _ConsumerCartState createState() => _ConsumerCartState();
}

class _ConsumerCartState extends State<ConsumerCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Korpa',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(DARK_GREY))),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/ArrowLeft.svg',
                height: ICON_SIZE,
                width: ICON_SIZE,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Blank()),
                );
              },
            )),
        body: Center(
          child: SingleChildScrollView(
              child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Column(children: [
                    /*Row(
                  children: [
                    Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/Back.svg',
                          width: ICON_SIZE,
                          height: ICON_SIZE
                        )
                      ]
                    ),

                    Column(
                      children: [
                        Text(
                          'Korpa',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(DARK_GREY)
                          )
                        )
                      ]
                    )
                  ]
                ),

                SizedBox(height: 20),*/

                    Row(children: [
                      Expanded(
                          flex: 3,
                          child: Image.asset(
                              'assets/product_listings/martin_cathrae_by_sa.jpg',
                              height: 90,
                              width: 90)),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 8,
                        child: Column(children: [
                          Row(children: [
                            Text('Pasirani paradajz',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(BLACK)))
                          ]),
                          Row(children: [
                            Text(
                                '2.40$CURRENCY', // should not be hardcoded; solve in dot net
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    color: Color(DARK_GREY)))
                          ]),
                          Row(children: [
                            Expanded(
                                flex: 7,
                                child: Column(children: [
                                  Align(
                                      child: SvgPicture.asset(
                                          'assets/icons/Quantity.svg',
                                          height: ICON_SIZE),
                                      alignment: Alignment.centerLeft)
                                ])),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Align(
                                      child: IconButton(
                                          icon: SvgPicture.asset(
                                              'assets/icons/Trash.svg',
                                              height: ICON_SIZE),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Blank()),
                                            );
                                          }),
                                      alignment: Alignment.centerRight),
                                ],
                              ),
                            )
                          ])
                        ]),
                      )
                    ]),

                    //SizedBox(height: 20),

                    Row(children: [
                      Expanded(
                        flex: 3,
                        child: Image.asset(
                            'assets/product_listings/honey_shawn_caza_cc_by_sa.jpg',
                            height: 90,
                            width: 90),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 8,
                        child: Column(children: [
                          Row(children: [
                            Text('Domaći med',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(BLACK)))
                          ]),
                          Row(
                            children: [
                              Text(
                                  '15$CURRENCY', // should not be hardcoded; solve in dot net
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Color(DARK_GREY)))
                            ],
                          ),
                          Row(children: [
                            Expanded(
                              flex: 7,
                              child: Column(children: [
                                Align(
                                    child: SvgPicture.asset(
                                        'assets/icons/Quantity.svg',
                                        height: ICON_SIZE),
                                    alignment: Alignment.centerLeft)
                              ]),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Align(
                                      child: IconButton(
                                          icon: SvgPicture.asset(
                                              'assets/icons/Trash.svg',
                                              height: ICON_SIZE),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Blank()),
                                            );
                                          }),
                                      alignment: Alignment.centerRight)
                                ],
                              ),
                            )
                          ])
                        ]),
                      )
                    ]),

                    SizedBox(height: 20),

                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Detalji porudžbine',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(DARK_GREY)))),

                    SizedBox(height: 20),

                    Row(children: [
                      Expanded(
                          flex: 1,
                          child: SvgPicture.asset('assets/icons/MapPin.svg')),
                      Expanded(
                          flex: 9,
                          child: Column(children: [
                            Row(children: [
                              Text('Kralja Aleksandra I Karađorđevića 36',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(BLACK)))
                            ]),
                            Row(children: [
                              Text('Kragujevac, Srbija',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Color(DARK_GREY)))
                            ])
                          ])),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                              icon: SvgPicture.asset(
                                  'assets/icons/ArrowRight.svg',
                                  height: ICON_SIZE,
                                  color: Color(DARK_GREY)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Blank()),
                                );
                              }))
                    ]),

                    SizedBox(height: 20),

                    Row(children: [
                      Expanded(
                          flex: 1,
                          child:
                              SvgPicture.asset('assets/icons/CreditCard.svg')),
                      Expanded(
                          flex: 9,
                          child: Column(children: [
                            Row(children: [
                              Text('Bitcoin novčanik',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(BLACK)))
                            ]),
                            Row(children: [
                              Text('1BvBMSEYstWetqTFn5Au4m4G',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Color(DARK_GREY)))
                            ])
                          ])),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                              icon: SvgPicture.asset(
                                  'assets/icons/ArrowRight.svg',
                                  height: ICON_SIZE,
                                  color: Color(DARK_GREY)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Blank()),
                                );
                              }))
                    ]),

                    SizedBox(height: 20),

                    Row(children: [
                      Expanded(
                        flex: 7,
                        child: Column(children: [
                          Align(
                              child: Text('Iznos',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Color(DARK_GREY))),
                              alignment: Alignment.centerLeft),
                          Align(
                              child: Text('Dostava',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Color(DARK_GREY))),
                              alignment: Alignment.centerLeft)
                        ]),
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(children: [
                          Align(
                              child: Text('17.40$CURRENCY',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800)),
                              alignment: Alignment.centerRight),
                          Align(
                              child: Text('5.00$CURRENCY',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800)),
                              alignment: Alignment.centerRight)
                        ]),
                      )
                    ]),

                    SizedBox(height: 20),

                    Row(children: [
                      Expanded(
                          flex: 8,
                          child: Column(children: [
                            Align(
                                child: Text('Ukupan iznos',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 18,
                                        color: Color(DARK_GREY))),
                                alignment: Alignment.centerLeft)
                          ])),
                      Expanded(
                          flex: 3,
                          child: Column(children: [
                            Align(
                                child: Text(
                                    '22.40$CURRENCY', // this should show the total of selected items, should not be hardcoded; solve in dot net
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800)),
                                alignment: Alignment.centerRight)
                          ]))
                    ]),

                    SizedBox(height: 20),

                    ButtonFill(
                        text:
                            'Potvrdi kupovinu (22.40$CURRENCY)', // should be showing the purchase total saved in a variable, for example
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Blank()));
                        })
                  ]))),
        ));
  }
}
