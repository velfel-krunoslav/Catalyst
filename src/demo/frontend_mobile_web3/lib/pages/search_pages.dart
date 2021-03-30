import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend_mobile/pages/consumer_home.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../internals.dart';

/*TODO alignments,paddings and dropdownmenu items*/

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
          'assets/product_listings/honey_shawn_caza_cc_by_sa.jpg'
        ],
        name: 'Domaći med',
        price: 13.90,
        classification: Classification.Weight,
        quantifier: 750),
    new ProductEntry(
        assetUrls: <String>['assets/product_listings/martin_cathrae_by_sa.jpg'],
        name: 'Pasirani paradajz',
        price: 2.40,
        classification: Classification.Weight,
        quantifier: 500),
    new ProductEntry(
        assetUrls: <String>[
          'assets/product_listings/olive_oil_catalina_alejandra_acevedo_by_sa.jpg'
        ],
        name: 'Maslinovo ulje',
        price: 15,
        classification: Classification.Weight,
        quantifier: 750),
    new ProductEntry(
        assetUrls: <String>['assets/product_listings/prosciutto_46137_by.jpg'],
        name: 'Pršut',
        price: 15,
        classification: Classification.Weight,
        quantifier: 750),
    new ProductEntry(
        assetUrls: <String>[
          'assets/product_listings/rakija_silverije_cc_by_sa.jpg'
        ],
        name: 'Rakija',
        price: 12.40,
        classification: Classification.Volume,
        quantifier: 1000),
    new ProductEntry(
        assetUrls: <String>['assets/product_listings/salami_pbkwee_by_sa.jpg'],
        name: 'Kobasica',
        price: 16.70,
        classification: Classification.Weight,
        quantifier: 1000),
    new ProductEntry(
        assetUrls: <String>[
          'assets/product_listings/washed_rind_cheese_paul_asman_jill_lenoble_by.jpg'
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
  //double _height = 1460;

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
  void _FilterButtonPress() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Filteri',
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(),
                      Text('Kategorija:',
                          style: TextStyle(
                              color: Color(BLACK),
                              fontFamily: 'Inter',
                              fontSize: 16)),
                      SizedBox(
                        width: 208,
                        height: 44,
                        child: DropdownButtonFormField(
                          items: null,
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
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Raspon cena (€):",
                        style: TextStyle(
                            color: Color(BLACK),
                            fontFamily: 'Inter',
                            fontSize: 16)),
                    SizedBox(
                      width: 89,
                      height: 44,
                      child: TextField(
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
                    Text("-",
                        style: TextStyle(
                            color: Color(BLACK),
                            fontFamily: 'Inter',
                            fontSize: 16)),
                    SizedBox(
                      width: 89,
                      height: 44,
                      child: TextField(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Proizvodi na akciji:",
                        style: TextStyle(
                            color: Color(BLACK),
                            fontFamily: 'Inter',
                            fontSize: 16)),
                    Switch(
                        value: _value,
                        activeColor: Color(BLACK),
                        onChanged: (bool value) {
                          onSwitchValueChanged(value);
                        }),
                    SizedBox(
                      width: 140,
                    ),
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
  }

  final _textController = new TextEditingController();
  String distance = "3";

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
                        width: 69,
                        height: 55,
                        child: TextField(
                          controller: _textController,
                          onChanged: (String value) async {
                            setState(() {
                              distance = _textController.text;
                            });
                          },
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
                                fontSize: 16)),
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
                            "Prikazati proizvode dobavljaca koji su udaljeni najvise $distance km.",
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 160,
            flexibleSpace: SafeArea(
                child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                          padding: EdgeInsets.all(0),
                          width: 36,
                          child: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: SvgPicture.asset(
                                  'assets/icons/DotsNine.svg',
                                  width: 36,
                                  height: 36),
                              onPressed: () {} /* TODO DOTS NINE PRESSED */)),
                      Spacer(),
                      IconButton(
                        icon: SvgPicture.asset('assets/icons/ShoppingCart.svg',
                            width: 36, height: 36),
                        onPressed: () {},
                      ),
                      Container(
                        child: Center(
                          child: Text(
                            cardItemsCount.toString(),
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Color(DARK_GREY)),
                          ),
                        ),
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                            color: Color(LIGHT_GREY),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      )
                    ],
                  ),
                  TextField(
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
                        Padding(
                          padding: EdgeInsetsDirectional.only(top: 8.0),
                          child: FlatButton.icon(
                              onPressed: () => _FilterButtonPress(),
                              icon: Icon(Icons.pin_drop, size: 24.0),
                              label: Text(
                                'Lokacija',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(top: 8.0),
                          child: FlatButton.icon(
                              onPressed: () => _LocationButtonPress(),
                              icon: Icon(
                                Icons.filter_alt,
                                size: 24.0,
                              ),
                              label: Text(
                                'Filteri',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              )),
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
