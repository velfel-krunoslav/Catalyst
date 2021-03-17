import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/pages/blank_page.dart';
import 'package:frontend_mobile/pages/categories_page.dart';
import 'package:frontend_mobile/services/Product_entry.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

const Color RED_ATTENTION = Color(0xffCB1C04);
const Color GREEN_SUCCESSFUL = Color(0xff33AE08);
const Color BLACK = Color(0xff000000);
const Color DARK_GREY = Color(0xff6D6D6D);
const Color LIGHT_GREY = Color(0xffECECEC);
const Color DARK_GREEN = Color(0xff07630B);
const Color MINT = Color(0xffBD14C);
const Color OLIVE = Color(0xff009A29);
const Color TEAL = Color(0xff0EAD65);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int activeMenu = 0;
  int cardItemsCount = 0;
  List menuItems = ['Početna', 'Kategorije', 'Akcije'];
  List<ProductEntry> products = [
    new ProductEntry(
        url: 'assets/product_listings/honey_shawn_caza_cc_by_sa.jpg',
        title: 'Domaći med',
        price: '13.90€ (750g)'),
    new ProductEntry(
        url: 'assets/product_listings/martin_cathrae_by_sa.jpg',
        title: 'Pasirani paradajz',
        price: '2.40€ (500g)'),
    new ProductEntry(
        url:
            'assets/product_listings/olive_oil_catalina_alejandra_acevedo_by_sa.jpg',
        title: 'Maslinovo ulje',
        price: '15€ (750g)'),
    new ProductEntry(
        url: 'assets/product_listings/prosciutto_46137_by.jpg',
        title: 'Pršut',
        price: '15€ (750g)'),
    new ProductEntry(
        url: 'assets/product_listings/rakija_silverije_cc_by_sa.jpg',
        title: 'Rakija',
        price: '12.40€ (1000 ml)'),
    new ProductEntry(
        url: 'assets/product_listings/salami_pbkwee_by_sa.jpg',
        title: 'Kobasica',
        price: '16.70€ (1000g)'),
    new ProductEntry(
        url:
            'assets/product_listings/washed_rind_cheese_paul_asman_jill_lenoble_by.jpg',
        title: 'Kamamber',
        price: '29.90€ (500g)'),
  ];
  List<ProductEntry> recently;
  List<ProductEntry> productsToDispay;
  ScrollController _ScrollController;
  bool reachPoint = false;
  double _height = 1460;

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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    return ListView(
      controller: _ScrollController,
      children: [
        StickyHeader(
            header: StickyBar(),
            content: Container(
              height: _height,
              color: Colors.white,
              child: PageView(
                controller: _PageController,
                children: [HomeContent(), Categories(), BestDeals()],
                onPageChanged: (index) {
                  setState(() {
                    activeMenu = index;
                  });
                },
              ),
            )),
      ],
    );
  }

  Widget StickyBar() {
    return Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color:
                reachPoint ? Colors.black.withOpacity(0.5) : Colors.transparent,
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ]),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 68, 20, 0),
                  child: TextField(
                    onChanged: (text) {
                      text = text.toLowerCase();
                      setState(() {
                        productsToDispay = products.where((product) {
                          var productTitle = product.title.toLowerCase();
                          return productTitle.contains(text);
                        }).toList();
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 36),
                      fillColor: LIGHT_GREY,
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
                ),
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(menuItems.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _PageController.animateToPage(index,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: activeMenu == index
                                            ? BLACK
                                            : Colors.transparent,
                                        width: 2))),
                            child: Padding(
                              padding: EdgeInsets.only(top: 12, bottom: 8),
                              child: Text(
                                menuItems[index],
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: activeMenu == index
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      );
                    })),
                SizedBox(
                  height: 12,
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 14, 0, 0),
              child: Row(
                children: [
                  SizedBox(width: 14),
                  Container(
                      padding: EdgeInsets.all(0),
                      width: 36,
                      child: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: SvgPicture.asset('assets/icons/DotsNine.svg',
                              width: 36, height: 36),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Blank()));
                          })),
                  Spacer(),
                  Row(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset('assets/icons/ShoppingCart.svg',
                            width: 36, height: 36),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Blank()));
                        },
                      ),
                      Container(
                        child: Center(
                          child: Text(
                            cardItemsCount.toString(),
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: DARK_GREY),
                          ),
                        ),
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                            color: LIGHT_GREY,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      )
                    ],
                  ),
                  SizedBox(width: 20)
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/KotaricaIconMonochrome.svg'),
                  ],
                ))
          ],
        ));
  }

  Widget HomeContent() {
    var size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'Preporučeno',
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 28,
                color: DARK_GREY,
                fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Wrap(
            children: List.generate(productsToDispay.length, (index) {
              return InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Blank()));
                },
                child: Padding(
                  padding: (index + 1) % 2 == 0
                      ? EdgeInsets.only(left: 10, bottom: 15)
                      : EdgeInsets.only(right: 10, bottom: 15),
                  child: SizedBox(
                    width: (size.width - 60) / 2,
                    child: Card(
                      color: LIGHT_GREY,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: (size.width - 16) / 2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5)),
                                image: DecorationImage(
                                    image:
                                        AssetImage(productsToDispay[index].url),
                                    fit: BoxFit.cover)),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              productsToDispay[index].title.length > 15
                                  ? productsToDispay[index]
                                          .title
                                          .substring(0, 15) +
                                      '...'
                                  : productsToDispay[index].title,
                              style:
                                  TextStyle(fontFamily: 'Inter', fontSize: 16),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              productsToDispay[index].price,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                color: DARK_GREY,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        recently != null
            ? Padding(
                padding: const EdgeInsets.only(left: 20, top: 30, bottom: 20),
                child: Text(
                  'Nedavno ste pogledali',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 28,
                      color: DARK_GREY,
                      fontWeight: FontWeight.w700),
                ),
              )
            : Container(),
        productsToDispay.length > 6
            ? InkWell(
                onTap: () {
                  _ScrollController.animateTo(0.0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: LIGHT_GREY,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        size: 36,
                        color: DARK_GREY,
                      ),
                      Text(
                        'Nazad na vrh',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: DARK_GREY),
                      )
                    ],
                  ),
                ),
              )
            : Container()
      ],
    );
  }

//error
  Widget BestDeals() {
    var size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Wrap(
            children: List.generate(productsToDispay.length, (index) {
              return InkWell(
                onTap: () {
                  //print((size.width - 16) / 2);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Blank()));
                },
                child: Padding(
                  padding: (index + 1) % 2 == 0
                      ? EdgeInsets.only(left: 10, bottom: 15)
                      : EdgeInsets.only(right: 10, bottom: 15),
                  child: SizedBox(
                    width: (size.width - 60) / 2,
                    child: Card(
                      color: LIGHT_GREY,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: (size.width - 16) / 2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5)),
                                image: DecorationImage(
                                    image:
                                        AssetImage(productsToDispay[index].url),
                                    fit: BoxFit.cover)),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              productsToDispay[index].title.length > 25
                                  ? productsToDispay[index]
                                          .title
                                          .substring(0, 25) +
                                      '...'
                                  : productsToDispay[index].title,
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              productsToDispay[index].price,
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 18,
                                color: DARK_GREY,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              productsToDispay[index].price,
                              style: TextStyle(
                                fontSize: 16,
                                color: RED_ATTENTION,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        productsToDispay.length > 6
            ? InkWell(
                onTap: () {
                  _ScrollController.animateTo(0.0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: LIGHT_GREY,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        size: 35,
                        color: DARK_GREY,
                      ),
                      Text(
                        'Nazad na vrh',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: DARK_GREY),
                      )
                    ],
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
