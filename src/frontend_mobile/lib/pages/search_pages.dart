import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/widgets.dart';
import '../internals.dart';

class SearchPage extends StatefulWidget {
  String query;
  SearchPage({String this.query});
  @override
  _SearchPageState createState() => _SearchPageState(this.query);
}

class _SearchPageState extends State<SearchPage> {
  String query;
  _SearchPageState(String query) {
    this.query = query;
  }
  bool _value = false;
  onSwitchValueChanged(bool value) {
    setState(() {
      _value = value;
    });
  }

  int activeMenu = 0;
  int cardItemsCount = 0;
  List<ProductEntry> products = [
    new ProductEntry(
        assetUrls: <String>[
          'https://ipfs.io/ipfs/QmVB38abDTVj5FU1GTbW6k2QhDB8FHxYqhBHwFTrix78Bw'
        ],
        name: 'Domaći med',
        price: 13.90,
        classification: Classification.Weight,
        quantifier: 750),
    new ProductEntry(
        assetUrls: <String>[
          'https://ipfs.io/ipfs/QmSGWhMdUK9YXdfZBP6gKQozXxqBe4mcdSuhusPbVyZTCx'
        ],
        name: 'Pasirani paradajz',
        price: 2.40,
        classification: Classification.Weight,
        quantifier: 500),
    new ProductEntry(
        assetUrls: <String>[
          'https://ipfs.io/ipfs/QmRsZYboEhSYCGZCBiERvKCfEEBEBWxYm6FUNHg2oryKZk'
        ],
        name: 'Maslinovo ulje',
        price: 15,
        classification: Classification.Weight,
        quantifier: 750),
    new ProductEntry(
        assetUrls: <String>[
          'https://ipfs.io/ipfs/QmXd1VwfEJWea1TL62q9btikLypcwCf7VTB46HLYx7EsuQ'
        ],
        name: 'Pršut',
        price: 15,
        classification: Classification.Weight,
        quantifier: 750),
    new ProductEntry(
        assetUrls: <String>[
          'https://ipfs.io/ipfs/Qmb1tVQBXnQeeaQdSoMHjTRBWnGuwGnsWqJg97LdvkkFzS'
        ],
        name: 'Rakija',
        price: 12.40,
        classification: Classification.Volume,
        quantifier: 1000),
    new ProductEntry(
        assetUrls: <String>[
          'https://ipfs.io/ipfs/QmRxCijtUoMGDP7vdff1r74DYPhhGhdemtkht5R39pGxzC'
        ],
        name: 'Kobasica',
        price: 16.70,
        classification: Classification.Weight,
        quantifier: 1000),
    new ProductEntry(
        assetUrls: <String>[
          'https://ipfs.io/ipfs/QmWWrpbQgUB6LddC4UdZFgC6JPJcv52Sot7fAJjvsqcXgE'
        ],
        name: 'Kamamber',
        price: 29.90,
        classification: Classification.Weight,
        quantifier: 500),
  ];
  List<ProductEntry> recently;
  List<ProductEntry> productsToDispay;
  ScrollController _ScrollController;
  bool reachPoint = false;

  _scrollListener() {
    if (_ScrollController.offset >= 50) {
      setState(() {
        reachPoint = true;
      });
    }
    if (_ScrollController.offset < 50) {
      setState(() {
        reachPoint = false;
      });
    }
  }

  PageController _PageController;
  @override
  void initState() {
    super.initState();
    _ScrollController = ScrollController();
    setState(() {
      productsToDispay = products;
    });
    _ScrollController.addListener(_scrollListener);
    _PageController = PageController(initialPage: 0);
  }
  /*TODO categories dropdown menu items*/

  // ignore: unused_field
  var _categories = [
    'Peciva',
    'Suhomesnato',
    'Mlečni proizvodi',
    'Voće i povrće',
    'Bezalkoholna pića',
    'Alkohol',
    'Žita',
    'Živina',
    'Zimnice',
    'Ostali proizvodi',
  ];
  var _currentCategorySelected = "Izaberite kategoriju...";

  void _DropDownCategorySelected(String newCategorySelected) {
    setState(() {
      this._currentCategorySelected = newCategorySelected;
    });
  }

  // ignore: non_constant_identifier_names
  void _FilterButtonPress() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) {
            return Container(
              height: 280,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Filteri',
                            style: TextStyle(
                                color: Color(DARK_GREY),
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 24)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 5.0, right: 5.0),
                            height: 60,
                            child: Text('Kategorija:',
                                style: TextStyle(
                                    color: Color(BLACK),
                                    fontFamily: 'Inter',
                                    fontSize: 14)),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10.0, right: 5.0),
                            height: 60,
                            child: Text("Raspon cena ($CURRENCY):",
                                style: TextStyle(
                                    color: Color(BLACK),
                                    fontFamily: 'Inter',
                                    fontSize: 14)),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 3.0, right: 5.0),
                            height: 60,
                            child: Text("Proizvodi na akciji:",
                                style: TextStyle(
                                    color: Color(BLACK),
                                    fontFamily: 'Inter',
                                    fontSize: 14)),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: SizedBox(
                              width: 240,
                              height: 60,
                              child: DropdownButtonFormField<String>(
                                items: _categories
                                    .map((String dropDownStringItem) {
                                  return DropdownMenuItem<String>(
                                      value: dropDownStringItem,
                                      child: Text(dropDownStringItem));
                                }).toList(),
                                onChanged: (String newCategorySelected) {
                                  _DropDownCategorySelected(
                                      newCategorySelected);
                                },
                                hint: Text(
                                  _currentCategorySelected,
                                  style: TextStyle(fontFamily: 'Inter'),
                                ),
                                decoration: const InputDecoration(
                                  filled: true,
                                  border: const OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(5.0),
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                height: 60,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(LIGHT_GREY),
                                    border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(5.0),
                                        ),
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 17.0, right: 17.0),
                                child: Text("-",
                                    style: TextStyle(
                                        color: Color(BLACK),
                                        fontFamily: 'Inter',
                                        fontSize: 14)),
                              ),
                              SizedBox(
                                width: 100,
                                height: 60,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(LIGHT_GREY),
                                    border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(5.0),
                                        ),
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Switch(
                              value: _value,
                              activeColor: Color(BLACK),
                              onChanged: (bool value) {
                                stateSetter(() => onSwitchValueChanged(value));
                              }),
                          SizedBox(
                            width: 86,
                            height: 40,
                            // ignore: deprecated_member_use
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              color: Color(LIGHT_GREY),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Primeni',
                                  style: TextStyle(
                                      color: Color(BLACK),
                                      fontFamily: 'Inter',
                                      fontSize: 14)),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                    ],
                  )
                ],
              ),
            );
          });
        });
  }

  final _textController = new TextEditingController();
  final _queryController = new TextEditingController();
  String hintDistance = "3";

  // ignore: non_constant_identifier_names
  void _LocationButtonPress() {
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
                      Text('Lokacija',
                          style: TextStyle(
                              color: Color(DARK_GREY),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 24)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 15.0, left: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 70,
                        height: 55,
                        child: TextField(
                          controller: _textController,
                          onChanged: (String value) {
                            setState(() {
                              if (value == "") {
                                hintDistance = "3";
                              } else {
                                if (value == "0") {
                                  hintDistance = "1";
                                  value = "1";
                                } else {
                                  hintDistance = value;
                                }
                              }
                            });
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          decoration: InputDecoration(
                            hintText: '3',
                            filled: true,
                            fillColor: Color(LIGHT_GREY),
                            border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(5.0),
                                ),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("km",
                            style: TextStyle(
                                color: Color(BLACK),
                                fontFamily: 'Inter',
                                fontSize: 14)),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 282,
                        height: 34,
                        child: Text(
                            "Prikazati proizvode dobavljača koji su udaljeni najviše $hintDistance km.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(BLACK),
                                fontFamily: 'Inter',
                                fontSize: 14)),
                      ),
                    ),
                    SizedBox(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 86,
                      height: 40,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        color: Color(LIGHT_GREY),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Primeni',
                            style: TextStyle(
                                color: Color(BLACK),
                                fontFamily: 'Inter',
                                fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  User user = new User(
    name: "Petar",
    surname: "Nikolić",
    photoUrl:
        "https://ipfs.io/ipfs/QmRCHi7CRFfbgyNXYsiSJ8wt8XMD3rjt3YCQ2LccpqwHke",
    phoneNumber: "+49 76 859 69 58",
    homeAddress: "4070 Jehovah Drive",
    email: "jay.ritter@gmail.com",
    desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit,"
        " sed do eiusmod tempor incididunt ut labore et dolore magna "
        "aliqua.",
  );

  @override
  Widget build(BuildContext context) {
    _queryController.text = this.query;
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 180,
            flexibleSpace: SafeArea(
                child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                          padding: EdgeInsets.all(0),
                          width: BUTTON_HEIGHT,
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Color(LIGHT_GREY)),
                              child: SvgPicture.asset(
                                  'assets/icons/ArrowLeft.svg',
                                  width: 36,
                                  height: 36),
                              onPressed: () {
                                Navigator.pop(context);
                              })),
                      SizedBox(width: 12),
                      Text(
                        'Pretraga: \"${(this.query.length > 10) ? this.query.substring(0, 10) + '...' : this.query}\"',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24,
                            color: Color(DARK_GREY),
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextField(
                    controller: _queryController,
                    onChanged: (text) {
                      text = text.toLowerCase();
                      setState(() {
                        productsToDispay = products.where((product) {
                          var productTitle = product.name.toLowerCase();
                          return productTitle.contains(text);
                        }).toList();
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 36),
                      fillColor: Color(LIGHT_GREY),
                      filled: true,
                      hintText: 'Pretraga',
                      hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 16),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 15, right: 10),
                        child: SvgPicture.asset(
                            'assets/icons/MagnifyingGlass.svg'),
                      ),
                      border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(5.0),
                          ),
                          borderSide: BorderSide.none),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          // ignore: deprecated_member_use
                          child: FlatButton(
                            onPressed: () => {_LocationButtonPress()},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset('assets/icons/Location.svg',
                                    width: 24, height: 24),
                                Text(
                                  "Lokacija",
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Color(BLACK)),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          // ignore: deprecated_member_use
                          child: FlatButton(
                            onPressed: () => {_FilterButtonPress()},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset('assets/icons/Filters.svg',
                                    width: 24, height: 24),
                                Text(
                                  "Filteri",
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Color(BLACK)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(child: SearchContent()),
        ),
      ),
    );
  }

  Widget SearchContent() {
    var size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Wrap(
            children: List.generate(productsToDispay.length, (index) {
              return InkWell(
                onTap: () {},
                child: Padding(
                  padding: (index + 1) % 2 == 0
                      ? EdgeInsets.only(left: 10, bottom: 15)
                      : EdgeInsets.only(right: 10, bottom: 15),
                  child: SizedBox(
                      width: (size.width - 60) / 2,
                      child: ProductEntryCard(
                          product: productsToDispay[index], onPressed: () {})),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
