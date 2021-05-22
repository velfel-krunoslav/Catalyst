import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config.dart';
import '../models/ordersModel.dart';
import '../widgets.dart';
import '../internals.dart';
import 'package:provider/provider.dart';
import 'blank_page.dart';
import '../models/productsModel.dart';

String customerAddress = usr.homeAddress;
String desc = usr.privateKey;

class ConsumerCart extends StatefulWidget {
  VoidCallback initiateRefresh;
  VoidCallback incrementCart;
  VoidCallback decrementCart;
  Future<ProductEntry> Function(int id) getProductByIdCallback;
  Function showInSnackBar;
  ConsumerCart(this.getProductByIdCallback, this.initiateRefresh,
      this.showInSnackBar, this.incrementCart, this.decrementCart);
  @override
  _ConsumerCartState createState() => _ConsumerCartState(getProductByIdCallback,
      initiateRefresh, showInSnackBar, incrementCart, decrementCart);
}

class _ConsumerCartState extends State<ConsumerCart> {
  bool isEmpty = true;
  double shipping = 500.0;
  double subtotal = 0;
  double total;
  VoidCallback initiateRefresh;

  bool paymentInProcess = false;

  VoidCallback incrementCart;
  VoidCallback decrementCart;
  String method, paymentMethod;
  ProductsModel productsModel;
  Function showInSnackBar;
  List<CartProduct> products = [];
  List<int> quantities = [];
  List<int> indices = [];
  List<List<String>> ids = [];
  Future<ProductEntry> Function(int id) getProductByIdCallback;
  OrdersModel ordersModel;
  _ConsumerCartState(this.getProductByIdCallback, this.initiateRefresh,
      this.showInSnackBar, this.incrementCart, this.decrementCart);
  @override
  void initState() {
    super.initState();
    Prefs.instance.containsKey('cartProducts').then((hasKey) {
      Prefs.instance.getStringValue('cartProducts').then((value) {
        if (hasKey == false || (hasKey == true && value.compareTo('') == 0)) {
          isEmpty = true;
        } else {
          isEmpty = false;
        }
        if (!isEmpty) {
          setState(() {
            total = shipping;
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
            setState(() {
              indices = List<int>.generate(tmp.length, (index) {
                return index;
              });
            });

            for (int i = 0; i < ids.length; i++) {
              getProductByIdCallback(int.parse(ids[i][0])).then((pr) {
                CartProduct p = CartProduct(
                    id: pr.id,
                    vendorId: pr.sellerId,
                    name: pr.name,
                    photoUrl: pr.assetUrls,
                    price: (pr.discountPercentage == 0)
                        ? pr.price
                        : pr.price * (1 - pr.discountPercentage / 100),
                    cartQuantity: int.parse(ids[i][1]),
                    classification: pr.classification,
                    quantifier: pr.quantifier);
                setState(() {
                  products.add(p);
                  quantities.add(int.parse(ids[i][1]));
                  subtotal += (p.price * p.cartQuantity);
                  total += (p.price * p.cartQuantity);
                });
              });
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ordersModel = Provider.of<OrdersModel>(context);
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
            : ((paymentInProcess)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LinearProgressIndicator(),
                      Text('Transakcija u obradi...',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(DARK_GREY))),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.3)
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        Container(
                            child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                          child: Column(
                              children: List.generate(products.length, (index) {
                            return Padding(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Row(children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      products[index].photoUrl[0],
                                      height: 90,
                                      width: 90,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
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
                                            '(' +
                                                products[index]
                                                    .quantifier
                                                    .toString() +
                                                ' ' +
                                                ((products[index]
                                                            .classification ==
                                                        Classification.Volume)
                                                    ? 'ml'
                                                    : ((products[index]
                                                                .classification ==
                                                            Classification
                                                                .Weight)
                                                        ? 'gr'
                                                        : 'kom')) +
                                                ')',
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 16,
                                                color: Color(DARK_GREY)))
                                      ]),
                                      Row(children: [
                                        Text(
                                            '${products[index].price.toStringAsFixed(2)}$CURRENCY',
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
                                                    total = subtotal + shipping;
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
                                            style:
                                                TextStyle(fontFamily: 'Inter')),
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
                                            child: new TextButton(
                                                style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    elevation: 3),
                                                child: SvgPicture.asset(
                                                    'assets/icons/Trash.svg',
                                                    height: INSET_ICON_SIZE),
                                                onPressed: () {
                                                  setState(() {
                                                    Prefs.instance
                                                        .getStringValue(
                                                            'cartProducts')
                                                        .then((value) {
                                                      String finalCart = '';
                                                      subtotal -= products[
                                                              indices[index]]
                                                          .price;
                                                      total -= products[
                                                              indices[index]]
                                                          .price;
                                                      products.removeAt(
                                                          indices[index]);
                                                      ids.removeAt(
                                                          indices[index]);
                                                      for (int i = index + 1;
                                                          i < indices.length;
                                                          i++) {
                                                        indices[i]--;
                                                      }
                                                      for (var t in ids) {
                                                        finalCart +=
                                                            "${t[0]},${t[1]};";
                                                      }
                                                      if (finalCart.length !=
                                                          0) {
                                                        finalCart =
                                                            finalCart.substring(
                                                                0,
                                                                finalCart
                                                                        .length -
                                                                    1);
                                                      } else {
                                                        isEmpty = true;
                                                      }

                                                      Prefs.instance
                                                          .setStringValue(
                                                              'cartProducts',
                                                              finalCart);
                                                    });
                                                  });
                                                  Prefs.instance
                                                      .getStringValue(
                                                          'cartProducts')
                                                      .then((value) {
                                                    decrementCart();
                                                  });
                                                })),
                                      ])
                                    ]),
                                  )
                                ]));
                          }).toList()),
                        )),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
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
                                        Text('Adresa',
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                color: Color(BLACK)))
                                      ]),
                                      Row(children: [
                                        Text(
                                            (customerAddress.length > 32)
                                                ? customerAddress.substring(
                                                        0, 32) +
                                                    '...'
                                                : customerAddress,
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
                                                            const EdgeInsets
                                                                .all(8.0),
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
                                                                    fontSize:
                                                                        18)),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15.0),
                                                          child: TextField(
                                                            onChanged:
                                                                (String value) {
                                                              setState(() {
                                                                customerAddress =
                                                                    value;
                                                              });
                                                            },
                                                          )),
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
                                                              color: Color(
                                                                  LIGHT_GREY),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  'Primeni',
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
                                        Text('Način plaćanja',
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                color: Color(BLACK)))
                                      ]),
                                      Row(children: [
                                        Text(
                                            (desc.length > 24)
                                                ? desc.substring(0, 24) + '...'
                                                : desc,
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
                                                    child: Column(children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                'Odabir načina plaćanja',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        DARK_GREY),
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        18)),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(50.0),
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                        width:
                                                                            280,
                                                                        height:
                                                                            36,
                                                                        child: Text(
                                                                            'Plaćanje pouzećem',
                                                                            style: TextStyle(
                                                                                fontFamily: 'Inter',
                                                                                fontSize: 16,
                                                                                color: Color(LIGHT_BLACK)))),
                                                                    SizedBox(
                                                                        height:
                                                                            36,
                                                                        child: GestureDetector(
                                                                            onTap: () {
                                                                              setState(() {
                                                                                paymentMethod = customerAddress;
                                                                                desc = "Plaćanje pouzećem";
                                                                              });
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: Text('->', style: TextStyle(fontFamily: 'Inter', fontSize: 18, color: Color(LIGHT_BLACK)))))
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 20,
                                                                    width: 200),
                                                                Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      SizedBox(
                                                                          width:
                                                                              280,
                                                                          height:
                                                                              36,
                                                                          child: Text(
                                                                              'Plaćanje putem e-novčanika',
                                                                              style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: Color(LIGHT_BLACK)))),
                                                                      SizedBox(
                                                                          height:
                                                                              36,
                                                                          child: GestureDetector(
                                                                              onTap: () {
                                                                                showModalBottomSheet(
                                                                                    isScrollControlled: true,
                                                                                    context: context,
                                                                                    builder: (context) {
                                                                                      return Container(
                                                                                          height: 250,
                                                                                          child: Column(children: [
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text('Unos privatnog ključa', style: TextStyle(color: Color(DARK_GREY), fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 18)),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Padding(
                                                                                                padding: const EdgeInsets.all(15.0),
                                                                                                child: TextField(
                                                                                                    onChanged: (String value) {
                                                                                                      setState(() {
                                                                                                        desc = value;
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
                                                                                                            borderSide: BorderSide.none)))),
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                              children: [
                                                                                                SizedBox(),
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.all(10.0),
                                                                                                  child: Container(
                                                                                                    width: 280,
                                                                                                    height: 36,
                                                                                                    child: Text("Trenutni privatni ključ je $desc", textAlign: TextAlign.center, style: TextStyle(color: Color(BLACK), fontFamily: 'Inter', fontSize: 16)),
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(),
                                                                                              ],
                                                                                            ),
                                                                                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                              SizedBox(
                                                                                                  width: 100,
                                                                                                  height: 50,
                                                                                                  child: FlatButton(
                                                                                                    color: Color(LIGHT_GREY),
                                                                                                    onPressed: () {
                                                                                                      setState(() {
                                                                                                        paymentMethod = desc;
                                                                                                        method = "Plaćanje putem e-novčanika";
                                                                                                      });
                                                                                                      Navigator.pop(context);
                                                                                                    },
                                                                                                    child: Text('Potvrdi', style: TextStyle(color: Color(BLACK), fontFamily: 'Inter', fontSize: 16)),
                                                                                                  ))
                                                                                            ])
                                                                                          ]));
                                                                                    });
                                                                              },
                                                                              child: Text('->', style: TextStyle(fontFamily: 'Inter', fontSize: 18, color: Color(LIGHT_BLACK)))))
                                                                    ])
                                                              ]))
                                                    ]));
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
                                    child: Column(children: [
                                  Align(
                                      child: Text(
                                          '${total.toStringAsFixed(2)}$CURRENCY',
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
                                      'Potvrdi kupovinu (${total.toStringAsFixed(2)}$CURRENCY)',
                                  onPressed: () {
                                    setState(() {
                                      paymentInProcess = true;
                                    });
                                    Prefs.instance
                                        .getStringValue('privateKey')
                                        .then((privateKey) {
                                      if (desc.compareTo('Plaćanje pouzećem') ==
                                          0) {
                                        DateTime date = new DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day);
                                        List<Order> orders = [];
                                        print(usr.id);
                                        for (int i = 0;
                                            i < products.length;
                                            i++) {
                                          orders.add(Order(
                                              id: 0,
                                              amount: quantities[i],
                                              date: date,
                                              status: 0,
                                              sellerId: products[i].vendorId,
                                              buyerId: usr.id,
                                              paymentType: (desc.compareTo(
                                                          'Plaćanje pouzećem') ==
                                                      0)
                                                  ? 0
                                                  : 1,
                                              deliveryAddress: customerAddress,
                                              productId: products[i].id,
                                              price: products[i].price));
                                        }
                                        ordersModel.addOrders(orders).then((a) {
                                          Prefs.instance
                                              .removeValue('cartProducts');
                                          initiateRefresh();
                                          showInSnackBar(
                                              "Kupovina je uspešno obavljena.");
                                          Navigator.pop(context);
                                        });
                                      } else {
                                        BigInt totalWei =
                                            BigInt.parse("4000000000000") *
                                                BigInt.parse(
                                                    total.toInt().toString());
                                        performPayment(privateKey, PUBLIC_KEY,
                                                wei: totalWei)
                                            .then((success) {
                                          if (success) {
                                            DateTime date = new DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day);
                                            List<Order> orders = [];
                                            print(usr.id);
                                            for (int i = 0;
                                                i < products.length;
                                                i++) {
                                              orders.add(Order(
                                                  id: 0,
                                                  amount: quantities[i],
                                                  date: date,
                                                  status: 0,
                                                  sellerId:
                                                      products[i].vendorId,
                                                  buyerId: usr.id,
                                                  paymentType: (desc.compareTo(
                                                              'Plaćanje pouzećem') ==
                                                          0)
                                                      ? 0
                                                      : 1,
                                                  deliveryAddress:
                                                      customerAddress,
                                                  productId: products[i].id,
                                                  price: products[i].price));
                                            }
                                            ordersModel
                                                .addOrders(orders)
                                                .then((a) {
                                              Prefs.instance
                                                  .removeValue('cartProducts');
                                              initiateRefresh();
                                              showInSnackBar(
                                                  "Kupovina je uspešno obavljena.");
                                              Navigator.pop(context);
                                            });
                                          } else {
                                            setState(() {
                                              paymentInProcess = false;
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: new Text(
                                                        "Nemate dovoljno sredstava na računu.")));
                                          }
                                        });
                                      }
                                    });
                                  })
                            ],
                          ),
                        )
                      ]))));
  }
}

/*
                            
*/
