import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:frontend_mobile/pages/product_entry_listing.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend_mobile/pages/consumer_home.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../internals.dart';

class ConsumerHomePage extends StatefulWidget {
  @override
  _ConsumerHomePageState createState() => _ConsumerHomePageState();
}

class _ConsumerHomePageState extends State<ConsumerHomePage> {
  int activeMenu = 0;
  int cardItemsCount = 0;
  List menuItems = ['Početna', 'Kategorije', 'Akcije'];
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: menuItems.length,
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
                        products = products.where((product) {
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
                ],
              ),
            )),
            bottom: TabBar(
                indicatorColor: Colors.black,
                labelPadding: EdgeInsets.all(8),
                tabs: List.generate(menuItems.length, (index) {
                  return Text(
                    menuItems[index],
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  );
                })),
            backgroundColor: Colors.white,
          ),
          body: Stack(
            children: [
              TabBarView(
                children: [
                  SingleChildScrollView(child: HomeContent()),
                  SingleChildScrollView(child: Categories()),
                  SingleChildScrollView(child: BestDeals())
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProductEntryListing(ProductEntryListingPage(
                                  assetUrls: <String>[
                                    'assets/product_listings/washed_rind_cheese_paul_asman_jill_lenoble_by.jpg',
                                    'assets/product_listings/martin_cathrae_by_sa.jpg',
                                    'assets/product_listings/honey_shawn_caza_cc_by_sa.jpg'
                                  ],
                                  name: 'Kamamber',
                                  price: 29.90,
                                  classification: Classification.Weight,
                                  quantifier: 500,
                                  description:
                                      'Meki sir od kravljeg mleka obložen belom plesni specifičnog ukusa. Specifične je arome i mekane do pastozne konzistencije, s tvrdom koricom spolja. Njegovo zrenje traje od jednog do dva meseca. Priprema se od punomasnog kravljeg mleka.',
                                  averageReviewScore: 4,
                                  numberOfReviews: 17,
                                  userInfo: new UserInfo(
                                    profilePictureAssetUrl:
                                        'assets/avatars/vendor_andrew_ballantyne_cc_by.jpg',
                                    fullName: 'Petar Nikolić',
                                    reputationNegative: 7,
                                    reputationPositive: 240,
                                  )))));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget HomeContent() {
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
            children: List.generate(products.length, (index) {
              return InkWell(
                onTap: () {},
                child: Padding(
                  padding: (index + 1) % 2 == 0
                      ? EdgeInsets.only(left: 10, bottom: 15)
                      : EdgeInsets.only(right: 10, bottom: 15),
                  child: SizedBox(
                      width: (size.width - 60) / 2,
                      child: ProductEntryCard(
                          product: products[index], onPressed: () {})),
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
                      color: Color(DARK_GREY),
                      fontWeight: FontWeight.w700),
                ),
              )
            : Container()
      ],
    );
  }

  Widget BestDeals() {
    var size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Wrap(
            children: List.generate(products.length, (index) {
              return InkWell(
                onTap: () {},
                child: Padding(
                  padding: (index + 1) % 2 == 0
                      ? EdgeInsets.only(left: 10, bottom: 15)
                      : EdgeInsets.only(right: 10, bottom: 15),
                  child: SizedBox(
                      width: (size.width - 60) / 2,
                      child: DiscountedProductEntryCard(
                          product: new DiscountedProductEntry(
                              assetUrls: products[index].assetUrls,
                              name: products[index].name,
                              price: products[index].price,
                              prevPrice: products[index].price * 0.8,
                              classification: products[index].classification,
                              quantifier: products[index].quantifier),
                          onPressed: () {})),
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
            children: List.generate(categories.length, (index) {
          return CategoryEntry(
              categories[index].assetUrl, categories[index].name);
        })));
  }

  List<Category> categories = [
    Category(
        name: 'Peciva',
        assetUrl: 'assets/product_categories/baked_goods_benediktv_cc_by.jpg'),
    Category(
        name: 'Suhomesnato',
        assetUrl:
            'assets/product_categories/cured_meats_marco_verch_cc_by.jpg'),
    Category(
        name: 'Mlečni proizvodi',
        assetUrl: 'assets/product_categories/dairy_benjamin_horn_cc_by.jpg'),
    Category(
        name: 'Voće i povrće',
        assetUrl:
            'assets/product_categories/fruits_and_veg_marco_verch_cc_by.jpg'),
    Category(
        name: 'Bezalkoholna pića',
        assetUrl: 'assets/product_categories/juice_caitlin_regan_cc_by.jpg'),
    Category(
        name: 'Alkohol',
        assetUrl:
            'assets/product_categories/alcohol_shunichi_kouroki_cc_by.jpg'),
    Category(
        name: 'Žita',
        assetUrl:
            'assets/product_categories/grains_christian_schnettelker_cc_by.jpg'),
    Category(
        name: 'Živina',
        assetUrl: 'assets/product_categories/livestock_marco_verch_cc_by.jpg'),
    Category(
        name: 'Zimnice',
        assetUrl:
            'assets/product_categories/preserved_food_dennis_yang_cc_by.jpg'),
    Category(
        name: 'Ostali proizvodi',
        assetUrl:
            'assets/product_categories/animal_produce_john_morgan_cc_by.jpg')
  ];
}

class CategoryEntry extends StatelessWidget {
  final String assetImagePath;
  final String categoryName;

  const CategoryEntry(this.assetImagePath, this.categoryName);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            height: 125.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage(assetImagePath)),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
          Positioned(
            left: 35.0,
            child: Text(categoryName,
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    color: Color(LIGHT_GREY),
                    shadows: <Shadow>[
                      Shadow(blurRadius: 5, color: Colors.black)
                    ])),
          ),
        ],
      ),
      onTap: () {} /* TODO ON CATEGORY CLICKED */,
    );
  }
}
