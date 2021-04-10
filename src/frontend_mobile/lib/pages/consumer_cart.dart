import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/pages/consumer_home.dart';
import 'package:frontend_mobile/pages/product_reviews.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../internals.dart';
import 'blank_page.dart';
import 'consumer_home.dart';

String customerAddress = 'Kralja Aleksandra I Karađorđevića 36';
String walletKey = '1BvBMSEYstWetqTFn5Au4m4G';

int quantityFirst = 1;
int quantitySecond = 1;

double priceFirst = 2.40;
double priceSecond = 13.90;

double subtotal = quantityFirst * priceFirst + quantitySecond * priceSecond;
double total = subtotal + 5;

final _textController = new TextEditingController();

List<CartProduct> products = [
  new CartProduct(
    photoUrl: <String>['assets/product_listings/honey_shawn_caza_cc_by_sa.jpg'],
    name: 'Domaći med',
    price: 13.9,
    cartQuantity: 1
  ),
  new CartProduct(
    photoUrl: <String>['assets/product_listings/martin_cathrae_by_sa.jpg'],
    name: 'Pasirani paradajz',
    price: 2.4,
    cartQuantity: 1
  )
];

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
                  MaterialPageRoute(builder: (context) => ConsumerHomePage()),
                );
              },
            )),
        body: Center(
          child: SingleChildScrollView(
              child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Column(children: [
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
                                '$priceFirst$CURRENCY', // should not be hardcoded; solve in dot net
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    color: Color(DARK_GREY)))
                          ]),
                          Row(children: [
                            Expanded(
                                flex: 1,
                                child: Align(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        quantityFirst -= 1;
                                      });
                                      setState(() {
                                        subtotal -= priceFirst;
                                      });
                                      setState(() {
                                        total = subtotal + 5;
                                    });
                                    },
                                    child: Text(
                                      ' - ',
                                      style: TextStyle(
                                        backgroundColor: Color(LIGHT_GREY),
                                        fontFamily: 'Inter',
                                        color: Color(BLACK)
                                      )
                                    )
                                  ),
                                  alignment: Alignment.centerLeft
                                )
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                child: Text(
                                  ' $quantityFirst ',
                                  style: TextStyle(fontFamily: 'Inter')
                                ),
                                alignment: Alignment.centerLeft)
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      quantityFirst += 1;
                                    });
                                    setState(() {
                                        subtotal += priceFirst;
                                    });
                                    setState(() {
                                        total = subtotal + 5;
                                    });
                                  },
                                  child: Text(
                                    ' + ',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      backgroundColor: Color(LIGHT_GREY),
                                      color: Color(BLACK)
                                    )
                                  )
                                ),
                                alignment: Alignment.centerLeft,
                              )
                            ),
                            Expanded(
                              flex: 6,
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
                                              builder: (context) => Blank()),
                                          );
                                        }),
                                      alignment: Alignment.centerRight
                                  )
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
                                color: Color(BLACK)
                              )
                            )
                          ]),
                          Row(
                            children: [
                              Text(
                                '$priceSecond$CURRENCY', // should not be hardcoded; solve in dot net
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  color: Color(DARK_GREY)
                                )
                              )
                            ],
                          ),
                          Row(children: [
                            Expanded(
                                flex: 1,
                                child: Align(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        quantitySecond -= 1;
                                      });
                                      setState(() {
                                        subtotal -= priceSecond;
                                      });
                                      setState(() {
                                        total = subtotal + 5;
                                    });
                                    },
                                    child: Text(
                                      ' - ',
                                      style: TextStyle(
                                        backgroundColor: Color(LIGHT_GREY),
                                        fontFamily: 'Inter',
                                        color: Color(BLACK)
                                      )
                                    )
                                  ),
                                  alignment: Alignment.centerLeft
                                )
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                child: Text(
                                  ' $quantitySecond ',
                                  style: TextStyle(fontFamily: 'Inter')
                                ),
                                alignment: Alignment.centerLeft)
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      quantitySecond += 1;
                                    });
                                    setState(() {
                                        subtotal += priceSecond;
                                    });
                                    setState(() {
                                        total = subtotal + 5;
                                    });
                                  },
                                  child: Text(
                                    ' + ',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      backgroundColor: Color(LIGHT_GREY),
                                      color: Color(BLACK)
                                    )
                                  )
                                ),
                                alignment: Alignment.centerLeft,
                              )
                            ),
                            Expanded(
                              flex: 6,
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
                                            builder: (context) => Blank()),
                                        );
                                      }),
                                    alignment: Alignment.centerRight
                                  )
                                ]
                              )
                            )
                          ])
                        ])
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
                              Text('$customerAddress',
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
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: 250,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text('Promena adrese za dostavu',
                                                  style: TextStyle(
                                                    color: Color(DARK_GREY),
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18)),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 280,
                                                  height: 36,
                                                  child: TextField(
                                                    controller: _textController,
                                                    onChanged: (String value) async {
                                                      setState(() {
                                                        customerAddress = _textController.text;
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: 'Izmeni adresu',
                                                      filled: true,
                                                      fillColor: Color(LIGHT_GREY),
                                                      border: new OutlineInputBorder(
                                                        borderRadius: const BorderRadius.all(
                                                          const Radius.circular(5.0),
                                                        ),
                                                        borderSide: BorderSide.none)
                                                    )
                                                  )
                                                )
                                              ]
                                            )
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(),
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Container(
                                                  width: 280,
                                                  height: 36,
                                                  child: Text(
                                                      "Trenutna adresa za dostavu je $customerAddress",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: Color(BLACK),
                                                          fontFamily: 'Inter',
                                                          fontSize: 16)),
                                                ),
                                              ),
                                              SizedBox(),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                height: 50,
                                                child: FlatButton(
                                                  color: Color(LIGHT_GREY),
                                                  onPressed: () {},
                                                  child: Text('Primeni',
                                                      style: TextStyle(
                                                          color: Color(BLACK),
                                                          fontFamily: 'Inter',
                                                          fontSize: 16)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                          })
                      )
                    ]
                  ),

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
                              Text('Novčanik',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(BLACK)))
                            ]),
                            Row(children: [
                              Text('$walletKey',
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
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: 250,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text('Promena javnog ključa novčanika',
                                                  style: TextStyle(
                                                    color: Color(DARK_GREY),
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18)),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 280,
                                                  height: 36,
                                                  child: TextField(
                                                    controller: _textController,
                                                    onChanged: (String value) async {
                                                      setState(() {
                                                        customerAddress = _textController.text;
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: 'Unesi nov ključ',
                                                      filled: true,
                                                      fillColor: Color(LIGHT_GREY),
                                                      border: new OutlineInputBorder(
                                                        borderRadius: const BorderRadius.all(
                                                          const Radius.circular(5.0),
                                                        ),
                                                        borderSide: BorderSide.none)
                                                    )
                                                  )
                                                )
                                              ]
                                            )
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(),
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Container(
                                                  width: 280,
                                                  height: 36,
                                                  child: Text(
                                                      "Trenutni ključ je $walletKey",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: Color(BLACK),
                                                          fontFamily: 'Inter',
                                                          fontSize: 16)),
                                                ),
                                              ),
                                              SizedBox(),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                height: 50,
                                                child: FlatButton(
                                                  color: Color(LIGHT_GREY),
                                                  onPressed: () {},
                                                  child: Text('Primeni',
                                                      style: TextStyle(
                                                          color: Color(BLACK),
                                                          fontFamily: 'Inter',
                                                          fontSize: 16)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  });
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
                              child: Text('$subtotal$CURRENCY',
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
                                    '$total$CURRENCY', // this should show the total of selected items, should not be hardcoded; solve in dot net
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
                            'Potvrdi kupovinu ($total$CURRENCY)', // should be showing the purchase total saved in a variable, for example
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Blank()));
                        })
                  ]))),
        ));
  }
}
