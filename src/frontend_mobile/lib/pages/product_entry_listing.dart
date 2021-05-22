import 'dart:convert';
import 'dart:ui';
import 'package:Kotarica/pages/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/ordersModel.dart';
import '../models/reviewsModel.dart';
import '../models/usersModel.dart';
import '../pages/product_reviews.dart';
import 'package:numberpicker/numberpicker.dart';
import '../sizer_helper.dart'
    if (dart.library.html) '../sizer_web.dart'
    if (dart.library.io) '../sizer_io.dart';
import '../widgets.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import '../internals.dart';
import '../config.dart';
import 'inbox.dart';

class ProductEntryListing extends StatefulWidget {
  ProductEntryListingPage _data;
  VoidCallback refreshInitiator;
  Function setSale;
  Function removeProduct;
  ProductEntryListing(
      ProductEntryListingPage productData, VoidCallback refreshInitiator,
      {void Function(int productId, int percentage) setSale,
      void Function(int productId) removeProduct}) {
    this._data = productData;
    this.refreshInitiator = refreshInitiator;
    this.setSale = setSale;
    this.removeProduct = removeProduct;
  }
  @override
  State<StatefulWidget> createState() {
    return _ProductEntryListing(
        _data, refreshInitiator, setSale, removeProduct);
  }
}

class _ProductEntryListing extends State<ProductEntryListing> {
  final sizer = getSizer();
  int _current = 0;
  bool _stateChange = false;
  VoidCallback refreshInitiator;
  ProductEntryListingPage _data;
  var reviewsModel;
  Function setSale;
  Function removeProduct;
  void newReviewCallback2(int productId, int rating, String desc, int userId) {
    reviewsModel.addReview(productId, rating, desc, usr.id, DateTime.now());
  }

  void refreshPage(int discountPercentage) {
    setState(() {
      _data.discountPercentage = discountPercentage;
    });
  }

  _ProductEntryListing(ProductEntryListingPage _data,
      VoidCallback refreshInitiator, Function setSale, Function removeProduct) {
    this._data = _data;
    this.refreshInitiator = refreshInitiator;
    this.setSale = setSale;
    this.removeProduct = removeProduct;
  }
  bool toggle = false;
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
                              child: Image.network(
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
                              CURRENCY +
                              ((_data.discountPercentage != 0)
                                  ? ""
                                  : ' (' +
                                      _data.quantifier.toString() +
                                      ' ' +
                                      ((_data.classification ==
                                              Classification.Volume)
                                          ? 'ml'
                                          : ((_data.classification ==
                                                  Classification.Weight)
                                              ? 'gr'
                                              : 'kom')) +
                                      ')'),
                          textAlign: TextAlign.left,
                          style: (_data.discountPercentage != 0)
                              ? TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 28,
                                  fontFamily: 'Inter',
                                  decoration: TextDecoration.lineThrough,
                                )
                              : TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 28,
                                  fontFamily: 'Inter',
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w800),
                        ),
                        (_data.discountPercentage == 0)
                            ? SizedBox(
                                height: 0,
                              )
                            : Text(
                                (_data.price *
                                            (1 -
                                                _data.discountPercentage / 100))
                                        .toStringAsFixed(2) +
                                    CURRENCY +
                                    ' (' +
                                    _data.quantifier.toString() +
                                    ' ' +
                                    ((_data.classification ==
                                            Classification.Volume)
                                        ? 'ml'
                                        : ((_data.classification ==
                                                Classification.Weight)
                                            ? 'gr'
                                            : 'kom')) +
                                    ')',
                                style: TextStyle(
                                    color: Color(RED_ATTENTION),
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
                                    builder: (context) => new MultiProvider(
                                            providers: [
                                              ChangeNotifierProvider<
                                                      ReviewsModel>(
                                                  create: (_) =>
                                                      ReviewsModel(_data.id)),
                                              ChangeNotifierProvider<
                                                      UsersModel>(
                                                  create: (_) => UsersModel()),
                                              ChangeNotifierProvider<
                                                      OrdersModel>(
                                                  create: (_) =>
                                                      OrdersModel.check(
                                                          usr.id, _data.id)),
                                            ],
                                            child: ProductReviews(
                                                _data.id, newReviewCallback2))),
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
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                        ),
                                        child: Image.network(
                                          _data.vendor.photoUrl,
                                          fit: BoxFit.fill,
                                        )),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                    constraints: BoxConstraints(minHeight: 60),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // TODO SUBSTR IF NAME TOO LONG
                                        Text(
                                            _data.vendor.name +
                                                " " +
                                                _data.vendor.surname,
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
                                                    // TODO ADD VENDOR REP
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
                                (usr.id != _data.vendor.id)
                                    ? TextButton(
                                        onPressed: () => {
                                              addChat(
                                                      idReceiver:
                                                          _data.vendor.id,
                                                      idSender: usr.id)
                                                  .then((value) {
                                                print(
                                                    'addChat body: ${value.body}');
                                                int tmpchatID =
                                                    ChatInfo.fromJson(
                                                            jsonDecode(value
                                                                .body
                                                                .toString()))
                                                        .id;

                                                if (tmpchatID == -1) {
                                                  requestChatID(usr.id,
                                                          _data.vendor.id)
                                                      .then((number) {
                                                    int chatID =
                                                        int.parse(number);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => ChatScreen(
                                                                user: ChatUser(
                                                                    chatID:
                                                                        chatID,
                                                                    id: _data
                                                                        .vendor
                                                                        .id,
                                                                    photoUrl: _data
                                                                        .vendor
                                                                        .photoUrl,
                                                                    name: _data
                                                                        .vendor
                                                                        .name,
                                                                    surname: _data
                                                                        .vendor
                                                                        .surname),
                                                                me: ChatUser(
                                                                    chatID:
                                                                        chatID,
                                                                    id: usr.id,
                                                                    photoUrl: usr
                                                                        .photoUrl,
                                                                    name: usr
                                                                        .name,
                                                                    surname: usr
                                                                        .surname),
                                                                chatID: chatID)));
                                                  });
                                                } else {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => ChatScreen(
                                                              user: ChatUser(
                                                                  chatID:
                                                                      tmpchatID,
                                                                  id: _data
                                                                      .vendor
                                                                      .id,
                                                                  photoUrl: _data
                                                                      .vendor
                                                                      .photoUrl,
                                                                  name: _data
                                                                      .vendor
                                                                      .name,
                                                                  surname: _data
                                                                      .vendor
                                                                      .surname),
                                                              me: ChatUser(
                                                                  chatID:
                                                                      tmpchatID,
                                                                  id: usr.id,
                                                                  photoUrl: usr
                                                                      .photoUrl,
                                                                  name:
                                                                      usr.name,
                                                                  surname: usr
                                                                      .surname),
                                                              chatID: tmpchatID)));
                                                }
                                              })
                                            },
                                        child: SvgPicture.asset(
                                            'assets/icons/Envelope.svg',
                                            width: 38,
                                            height: 38,
                                            color: Color(DARK_GREY)),
                                        style: TextButton.styleFrom(
                                            backgroundColor: Color(LIGHT_GREY),
                                            minimumSize: Size(60, 60)))
                                    : SizedBox.shrink()
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            (_data.vendor.id != usr.id)
                                ? ButtonFill(
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
                                                'cartProducts',
                                                '${_data.id},1');
                                          }
                                        });
                                      });

                                      refreshInitiator();
                                      Navigator.pop(context);
                                    })
                                : Container(),
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
                setSale == null
                    ? Container()
                    : TextButton(
                        onPressed: () {
                          if (toggle == false) {
                            setState(() {
                              toggle = true;
                            });
                          } else {
                            setState(() {
                              toggle = false;
                            });
                          }
                        },
                        child: SvgPicture.asset(
                            'assets/icons/DotsThreeVertical.svg',
                            color: Colors.black),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: Size(36, 36))),
                SizedBox(width: 20),
              ],
            ),
            toggle
                ? Material(
                    color: Color(0x00000000),
                    child: Row(
                      children: [
                        Spacer(),
                        Container(
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 18,
                              ),
                              _data.discountPercentage == 0
                                  ? DropdownOption(
                                      text: "Postavi na akciju",
                                      onPressed: () {
                                        _setSalePressed(
                                            _data.price, setSale, _data.id);
                                      },
                                    )
                                  : DropdownOption(
                                      text: "Ukloni sa akcije",
                                      onPressed: () {
                                        setSale(_data.id, 0);
                                        setState(() {
                                          toggle = false;
                                          refreshPage(0);
                                        });
                                      },
                                    ),
                              DropdownOption(
                                text: "Ukloni proizvod",
                                onPressed: () {
                                  removeProduct(_data.id);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ],
    )));
  }

  void _setSalePressed(double _price, Function setSale, int id) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) {
            return Picker(_price, setSale, id, refreshPage);
          });
        });
  }
}

class Picker extends StatefulWidget {
  double price;
  Function setSale;
  int productId;
  Function refreshPage;
  Picker(this.price, this.setSale, this.productId, this.refreshPage);

  @override
  _PickerState createState() =>
      _PickerState(price, setSale, productId, refreshPage);
}

class _PickerState extends State<Picker> {
  int _currentValue = 10;
  double price;
  Function setSale;
  int productId;
  Function refreshPage;
  _PickerState(this.price, this.setSale, this.productId, this.refreshPage);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Text(
            "Izaberite snizenje:",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 17,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
              ),
              NumberPicker(
                value: _currentValue,
                minValue: 5,
                maxValue: 95,
                step: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black26),
                ),
                onChanged: (value) => setState(() => _currentValue = value),
              ),
              SizedBox(
                width: 10,
              ),
              Text("%",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                  )),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Nova cena: ' +
                (price * (1 - _currentValue / 100)).toStringAsFixed(2) +
                ' $CURRENCY',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 17,
            ),
          ),
          SizedBox(height: 25),
          SizedBox(
            height: 50,
            width: 150,
            child: ButtonOutline(
              iconPath: 'assets/icons/Check.svg',
              buttonType: type.GREEN,
              text: 'Potvrdi',
              onPressed: () {
                setSale(productId, _currentValue);
                refreshPage(_currentValue);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DropdownOption extends StatelessWidget {
  Function onPressed;
  String text;
  DropdownOption({this.text, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: InkWell(
            onTap: onPressed,
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 17,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 18,
        )
      ],
    );
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
                                    child: Image.network(
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
