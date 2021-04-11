import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/pages/consumer_home.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../internals.dart';
import 'blank_page.dart';
import 'consumer_home.dart';

String customerAddress = 'Kralja Aleksandra I Karađorđevića 36';
String walletKey = '1BvBMSEYstWetqTFn5Au4m4G';
String paymentMethod = "Odaberite način plaćanja";
String method = "Odaberite način plaćanja";

int quantityFirst = 1;
int quantitySecond = 1;

double priceFirst = 2.40;
double priceSecond = 13.90;
double shipping = 5.00;

double subtotal = quantityFirst * priceFirst + quantitySecond * priceSecond;
double total = subtotal + shipping;

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
                Navigator.pop(
                  context
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
                                priceFirst.toStringAsFixed(2) + '€', // should not be hardcoded; solve in dot net
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    color: Color(DARK_GREY)))
                          ]),
                          Row(children: [
                            Expanded(
                                flex: 1,
                                child: Align(
                                    child: SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: FlatButton(
                                          onPressed: () {
                                            if(quantityFirst > 1) {
                                              setState(() {
                                                quantityFirst -= 1;
                                                subtotal -= priceFirst;
                                                total = subtotal + shipping;
                                              });
                                            }
                                          },
                                          child: Text(
                                              '-',
                                              style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14,
                                                  color: Color(LIGHT_BLACK)
                                              )
                                          ),
                                          padding: EdgeInsets.all(5.0),
                                          color: Color(LIGHT_GREY),
                                        )
                                    ),
                                    alignment: Alignment.centerLeft
                                )
                            ),
                            Expanded(
                                flex: 1,
                                child: Align(
                                    child: Text(
                                        '  $quantityFirst  ',
                                        style: TextStyle(fontFamily: 'Inter')
                                    ),
                                    alignment: Alignment.centerLeft)
                            ),
                            Expanded(
                                flex: 1,
                                child: Align(
                                  child: SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          quantityFirst += 1;
                                          subtotal += priceFirst;
                                          total = subtotal + 5;
                                        });
                                      },
                                      child: Text(
                                          '+',
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 14,
                                              color: Color(LIGHT_BLACK)
                                          )
                                      ),
                                      padding: EdgeInsets.all(5.0),
                                      color: Color(LIGHT_GREY),
                                    ),
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
                                            ); // TODO - REMOVE THE PRODUCT FROM CART
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
                                    priceSecond.toStringAsFixed(2) + '€', // should not be hardcoded; solve in dot net
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
                                      child: SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: FlatButton(
                                          onPressed: () {
                                            if(quantitySecond > 1) {
                                              setState(() {
                                                quantitySecond -= 1;
                                                subtotal -= priceSecond;
                                                total = subtotal + 5;
                                              });
                                            }},
                                          child: Text(
                                              '-',
                                              style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14,
                                                  color: Color(LIGHT_BLACK)
                                              )
                                          ),
                                          padding: EdgeInsets.all(5.0),
                                          color: Color(LIGHT_GREY),
                                        ),
                                      ),
                                      alignment: Alignment.centerLeft
                                  )
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Align(
                                      child: Text(
                                          '  $quantitySecond  ',
                                          style: TextStyle(fontFamily: 'Inter')
                                      ),
                                      alignment: Alignment.centerLeft)
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Align(
                                    child: SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: FlatButton(
                                        onPressed: () {
                                          setState(() {
                                            quantitySecond += 1;
                                            subtotal += priceSecond;
                                            total = subtotal + 5;
                                          });
                                        },
                                        child: Text(
                                            '+',
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 14,
                                                color: Color(LIGHT_BLACK)
                                            )
                                        ),
                                        padding: EdgeInsets.all(5.0),
                                        color: Color(LIGHT_GREY),
                                      ),
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
                                                  ); // TODO - REMOVE THE PRODUCT FROM CART
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

                    Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Column(
                          children: [
                            SvgPicture.asset('assets/icons/MapPin.svg')
                          ]
                      ),
                      //Spacer(),
                      Column(
                          children: [
                            Column(children: [
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                Text('$customerAddress',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(BLACK)))
                                  ]),
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                Text('Kragujevac, Srbija',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        color: Color(DARK_GREY)))
                              ])
                          ])]),
                      //Spacer(),
                      Column(
                          children: [IconButton(
                              icon: SvgPicture.asset(
                                  'assets/icons/ArrowRight.svg',
                                  height: ICON_SIZE,
                                  width: ICON_SIZE,
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
                                //Navigator.pop(context);
                              })]
                      )
                    ]
                    ),

                    SizedBox(height: 20),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Column(
                          children: [
                          SvgPicture.asset('assets/icons/CreditCard.svg')
                      ]),
                      //Spacer(),
                      Column(
                          children: [ Column(children: [
                              Text('$method',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(BLACK))
                              ),
                            Text('$paymentMethod',
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          color: Color(DARK_GREY))
                            )
                          ])]),
                      //Spacer(),
                      Column(
                          children: [IconButton(
                              icon: SvgPicture.asset(
                                  'assets/icons/ArrowRight.svg',
                                  height: ICON_SIZE,
                                  width: ICON_SIZE,
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
                                                  Text('Odabir načina plaćanja',
                                                      style: TextStyle(
                                                          color: Color(DARK_GREY),
                                                          fontFamily: 'Inter',
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 18)),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.all(50.0),
                                                child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          SizedBox(
                                                            width: 280,
                                                            height: 36,
                                                            child: Text(
                                                              'Plaćanje pouzećem',
                                                              style: TextStyle(
                                                                fontFamily: 'Inter',
                                                                fontSize: 16,
                                                                color: Color(LIGHT_BLACK)
                                                              )
                                                            )
                                                          ),
                                                          SizedBox(
                                                            height: 36,
                                                            child: GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    paymentMethod = customerAddress;
                                                                    method = "Plaćanje pouzećem";
                                                                  });
                                                                  Navigator.pop(context);
                                                                },
                                                              child: Text(
                                                                '->',
                                                                style: TextStyle(
                                                                  fontFamily: 'Inter',
                                                                  fontSize: 18,
                                                                  color: Color(LIGHT_BLACK)
                                                                )
                                                              )
                                                            )
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(height: 20, width: 200),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          SizedBox(
                                                            width: 280,
                                                            height: 36,
                                                              child: Text(
                                                                  'Plaćanje putem e-novčanika',
                                                                  style: TextStyle(
                                                                      fontFamily: 'Inter',
                                                                      fontSize: 16,
                                                                      color: Color(LIGHT_BLACK)
                                                                  )
                                                              )
                                                          ),
                                                          SizedBox(
                                                            height: 36,
                                                            child: GestureDetector(
                                                              onTap: () {
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
                                                                                Text('Unos privatnog ključa',
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
                                                                                                hintText: 'Unesite privatni ključ',
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
                                                                                      "Trenutni privatni ključ je $walletKey",
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
                                                                                  onPressed: () {
                                                                                    paymentMethod = walletKey;
                                                                                    method = "Plaćanje preko e-novčanika";
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text('Potvrdi',
                                                                                      style: TextStyle(
                                                                                          color: Color(BLACK),
                                                                                          fontFamily: 'Inter',
                                                                                          fontSize: 16)),
                                                                                )
                                                                              )
                                                                            ]
                                                                          )
                                                                        ]
                                                                      )
                                                                    );
                                                                  });
                                                                //Navigator.pop(context);
                                                                },
                                                              child: Text(
                                                                '->',
                                                                style: TextStyle(
                                                                  fontFamily: 'Inter',
                                                                  fontSize: 18,
                                                                  color: Color(LIGHT_BLACK)
                                                                ))
                                                            )
                                                          )
                                                        ]
                                                      )
                                                    ]
                                                )
                                            )
                                          ]
                                        )
                                      );
                                    });
                              })])
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
                              child: Text(subtotal.toStringAsFixed(2) + '€',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800)),
                              alignment: Alignment.centerRight),
                          Align(
                              child: Text(shipping.toStringAsFixed(2) + '€',
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
                                    total.toStringAsFixed(2) + '€', // this should show the total of selected items, should not be hardcoded; solve in dot net
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
                        'Potvrdi kupovinu ' + total.toStringAsFixed(2) + '€', // should be showing the purchase total saved in a variable, for example
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Blank()));
                        })
                  ]))),
        ));
  }
}
