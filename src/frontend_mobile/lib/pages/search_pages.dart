import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
                        Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: Text('Kategorija:',
                              style: TextStyle(
                                  color: Color(BLACK),
                                  fontFamily: 'Inter',
                                  fontSize: 14)),
                        ),
                        SizedBox(
                          width: 230,
                          height: 60,
                          child: DropdownButtonFormField<String>(
                            items: _categories.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(dropDownStringItem));
                            }).toList(),
                            onChanged: (String newCategorySelected) {
                              _DropDownCategorySelected(newCategorySelected);
                            },
                            hint: Text(_currentCategorySelected),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text("Raspon cena ($CURRENCY):",
                            style: TextStyle(
                                color: Color(BLACK),
                                fontFamily: 'Inter',
                                fontSize: 14)),
                      ),
                      SizedBox(
                        width: 89,
                        height: 44,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                      Text("-",
                          style: TextStyle(
                              color: Color(BLACK),
                              fontFamily: 'Inter',
                              fontSize: 14)),
                      SizedBox(
                        width: 89,
                        height: 44,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Text("Proizvodi na akciji:",
                            style: TextStyle(
                                color: Color(BLACK),
                                fontFamily: 'Inter',
                                fontSize: 14)),
                      ),
                      Switch(
                          value: _value,
                          activeColor: Color(BLACK),
                          onChanged: (bool value) {
                            stateSetter(() => onSwitchValueChanged(value));
                          }),
                      Spacer(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 86,
                        height: 36,
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          color: Color(LIGHT_GREY),
                          onPressed: () {},
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
        });
  }

  final _textController = new TextEditingController();
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
                              hintDistance = _textController.text;
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
                            "Prikazati proizvode dobavljaca koji su udaljeni najvise $hintDistance km.",
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
                      height: 36,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        color: Color(LIGHT_GREY),
                        onPressed: () {},
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
      forename: "Petar",
      surname: "Nikolić",
      photoUrl: "assets/avatars/vendor_andrew_ballantyne_cc_by.jpg",
      phoneNumber: "+49 76 859 69 58",
      address: "4070 Jehovah Drive",
      city: "Roanoke",
      mail: "jay.ritter@gmail.com",
      about: "Lorem ipsum dolor sit amet, consectetur adipiscing elit,"
          " sed do eiusmod tempor incididunt ut labore et dolore magna "
          "aliqua.",
      rating: 4.5,
      reviewsCount: 67);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: HomeDrawer(context, user),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 161,
            flexibleSpace: SafeArea(
                child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
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
                              onPressed: () =>
                                  // Scaffold.of(context).openDrawer(),
                                  _scaffoldKey.currentState.openDrawer(),
                            )),
                        Spacer(),
                        IconButton(
                          icon: SvgPicture.asset(
                              'assets/icons/ShoppingCart.svg',
                              width: 36,
                              height: 36),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        )
                      ],
                    ),
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
                                      fontSize: 14,
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
                                      fontSize: 14,
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
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'Preporučeno',
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 28,
                color: Color(DARK_GREY),
                fontWeight: FontWeight.w700),
          ),
        ),
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
