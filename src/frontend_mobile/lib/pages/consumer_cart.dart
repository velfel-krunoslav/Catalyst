import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:provider/provider.dart';
import 'blank_page.dart';

import '../models/productsModel.dart';

String customerAddress = 'Kralja Aleksandra I Karađorđevića 36';
String walletKey = '1BvBMSEYstWetqTFn5Au4m4G';

final _textController = new TextEditingController();

class ConsumerCart extends StatefulWidget {
  @override
  _ConsumerCartState createState() => _ConsumerCartState();
}

class _ConsumerCartState extends State<ConsumerCart> {
  bool isEmpty = true;
  List<int> quantities = [];
  double shipping = 5.0;
  double subtotal;
  double total;

  var productsModel;

  List<CartProduct> products = [];

  @override
  void initState() {
    super.initState();

    Prefs.instance.containsKey('cartProducts').then((value) {
      if (value == false) {
        isEmpty = true;
      } else {
        isEmpty = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    productsModel = Provider.of<ProductsModel>(context);
    List<List<String>> ids = [];
    Prefs.instance.getStringValue('cartProducts').then((value) {
      print('cartProducts contents: $value');
    });
    if (!isEmpty) {
      Prefs.instance.getStringValue('cartProducts').then((value) {
        List<String> tmp;
        if (value.contains(';')) {
          tmp = value.split(';');
        } else {
          tmp = [value];
        }

        for (int i = 0; i < tmp.length; i++) {
          List<String> t = [tmp[i].split(',')[0], tmp[i].split(',')[1]];
          ids.add(t);
        }

        print('ids CONTENTS: ${ids.toString()}');
        for (int i = 0; i < ids.length; i++) {
          productsModel.getProductById(int.parse(ids[i][0])).then((value) {
            CartProduct p = CartProduct(
                id: value.id,
                name: value.name,
                photoUrl: value.assetUrls,
                price: value.price,
                cartQuantity: int.parse(ids[i][1]));

            products.add(p);

            quantities.add(int.parse(ids[i][1]));
          });
        }
        print(products);
        subtotal = 0;
        total = 0;
        for (var e in products) {
          subtotal += e.price * e.cartQuantity;
        }
        total = subtotal + shipping;
      });
    }

    return Scaffold(
        backgroundColor: Colors.white,
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
                Navigator.pop(context);
              },
            )),
        body: (isEmpty == true)
            ? Center(
                child: Text('Korpa je prazna.',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(DARK_GREY))))
            : SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Column(
                                children:
                                    List.generate(products.length, (index) {
                              return Padding(
                                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Row(children: [
                                    Expanded(
                                        flex: 3,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.asset(
                                            products[index].photoUrl[0],
                                            height: 90,
                                            width: 90,
                                            fit: BoxFit.fill,
                                          ),
                                        )),
                                    SizedBox(width: 10),
                                    Expanded(
                                      flex: 8,
                                      child: Column(children: [
                                        Row(children: [
                                          Text(products[index].name,
                                              style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                  color: Color(BLACK)))
                                        ]),
                                        Row(children: [
                                          Text(
                                              '${products[index].price.toStringAsFixed(2)}$CURRENCY', // should not be hardcoded; solve in dot net
                                              style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 16,
                                                  color: Color(DARK_GREY)))
                                        ]),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Row(children: [
                                          SizedBox(
                                            width: 36,
                                            height: 36,
                                            child: TextButton(
                                                style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Color(LIGHT_GREY)),
                                                onPressed: () {
                                                  setState(() {
                                                    if (quantities[index] > 1) {
                                                      quantities[index] -= 1;

                                                      subtotal -=
                                                          products[index].price;

                                                      total =
                                                          subtotal + shipping;
                                                    }
                                                  });
                                                },
                                                child: Text('-',
                                                    style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        color: Color(BLACK)))),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text('${quantities[index]}',
                                              style: TextStyle(
                                                  fontFamily: 'Inter')),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: 36,
                                            height: 36,
                                            child: TextButton(
                                                style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Color(LIGHT_GREY)),
                                                onPressed: () {
                                                  setState(() {
                                                    quantities[index] += 1;
                                                    subtotal +=
                                                        products[index].price;
                                                    total = subtotal + shipping;
                                                  });
                                                },
                                                child: Text('+',
                                                    style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        color: Color(BLACK)))),
                                          ),
                                          Spacer(),
                                          SizedBox(
                                              width: 42,
                                              height: 42,
                                              child: TextButton(
                                                  style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.white,
                                                      elevation: 3),
                                                  child: SvgPicture.asset(
                                                      'assets/icons/Trash.svg',
                                                      height: INSET_ICON_SIZE),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Blank()),
                                                    );
                                                  })),
                                        ])
                                      ]),
                                    )
                                  ]));
                            }).toList()),
                          ),
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
                            SvgPicture.asset('assets/icons/MapPin.svg'),
                            SizedBox(width: 6),
                            Expanded(
                                flex: 9,
                                child: Column(children: [
                                  Row(children: [
                                    Text(
                                        (customerAddress.length > 32)
                                            ? customerAddress.substring(0, 32) +
                                                '...'
                                            : customerAddress,
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Color(BLACK)))
                                  ]),
                                  Row(children: [
                                    Text('Kragujevac, Srbija', // TODO
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
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            'Promena adrese za dostavu',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    DARK_GREY),
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 18)),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                                width: 280,
                                                                height: 36,
                                                                child: TextField(
                                                                    controller: _textController,
                                                                    onChanged: (String value) async {
                                                                      setState(
                                                                          () {
                                                                        customerAddress =
                                                                            _textController.text;
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
                                                                            borderSide: BorderSide.none))))
                                                          ])),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      SizedBox(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Container(
                                                          width: 280,
                                                          height: 36,
                                                          child: Text(
                                                              "Trenutna adresa za dostavu je $customerAddress",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      BLACK),
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontSize:
                                                                      16)),
                                                        ),
                                                      ),
                                                      SizedBox(),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 100,
                                                        height: 50,
                                                        child: FlatButton(
                                                          color:
                                                              Color(LIGHT_GREY),
                                                          onPressed: () {},
                                                          child: Text('Primeni',
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      BLACK),
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontSize:
                                                                      16)),
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
                            SvgPicture.asset('assets/icons/CreditCard.svg'),
                            SizedBox(width: 6),
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
                                    Text(
                                        (walletKey.length > 24)
                                            ? walletKey.substring(0, 24) + '...'
                                            : walletKey,
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
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            'Promena javnog ključa novčanika',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    DARK_GREY),
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 18)),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                                width: 280,
                                                                height: 36,
                                                                child: TextField(
                                                                    controller: _textController,
                                                                    onChanged: (String value) async {
                                                                      setState(
                                                                          () {
                                                                        customerAddress =
                                                                            _textController.text;
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
                                                                            borderSide: BorderSide.none))))
                                                          ])),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      SizedBox(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Container(
                                                          width: 280,
                                                          height: 36,
                                                          child: Text(
                                                              "Trenutni ključ je $walletKey",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      BLACK),
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontSize:
                                                                      16)),
                                                        ),
                                                      ),
                                                      SizedBox(),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 100,
                                                        height: 50,
                                                        child: FlatButton(
                                                          color:
                                                              Color(LIGHT_GREY),
                                                          onPressed: () {},
                                                          child: Text('Primeni',
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      BLACK),
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontSize:
                                                                      16)),
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
                          /* SizedBox(height: 20),
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
                                    child: Text(
                                        '${subtotal.toStringAsFixed(2)}$CURRENCY',
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800)),
                                    alignment: Alignment.centerRight),
                                Align(
                                    child: Text(
                                        '${shipping.toStringAsFixed(2)}$CURRENCY',
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
                                          '${total.toStringAsFixed(2)}$CURRENCY', // this should show the total of selected items, should not be hardcoded; solve in dot net
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
                                  'Potvrdi kupovinu (${total.toStringAsFixed(2)}$CURRENCY)', // should be showing the purchase total saved in a variable, for example
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Blank()));
                              })
                         */
                        ])),
              ));
  }
}
