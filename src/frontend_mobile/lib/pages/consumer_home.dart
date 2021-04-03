import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:frontend_mobile/pages/product_entry_listing.dart';
import 'package:frontend_mobile/pages/consumer_cart.dart';
import 'package:frontend_mobile/pages/search_pages.dart';
import 'package:frontend_mobile/pages/settings.dart';
import 'package:frontend_mobile/pages/my_account.dart';
import 'package:provider/provider.dart';
import '../internals.dart';
import '../models/productsModel.dart';

class ConsumerHomePage extends StatefulWidget {
  @override
  _ConsumerHomePageState createState() => _ConsumerHomePageState();
}

class _ConsumerHomePageState extends State<ConsumerHomePage> {


  int activeMenu = 0;
  int cardItemsCount = 0;
  List menuItems = ['Početna', 'Kategorije', 'Akcije'];
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
  List<ProductEntry> recently;
  List<ProductEntry> products = [];
  var listModel;
  @override
  Widget build(BuildContext context) {

    listModel = Provider.of<ProductsModel>(context);

    return MaterialApp(
      home: DefaultTabController(
        length: menuItems.length,
        child: Scaffold(
          drawer: HomeDrawer(context, user),
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
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              })),
                      Spacer(),
                      IconButton(
                        icon: SvgPicture.asset('assets/icons/ShoppingCart.svg',
                            width: 36, height: 36),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConsumerCart()));
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
                    onChanged: (text) {},
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
                    onEditingComplete: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchPage()));
                    },
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
                  SingleChildScrollView(child: listModel.isLoading ?
                  Center(child: LinearProgressIndicator(backgroundColor: Colors.grey,)
                    ,) :
                  HomeContent()),
                  SingleChildScrollView(child: Categories()),
                  SingleChildScrollView(child: listModel.isLoading ?
                  Center(child: LinearProgressIndicator(backgroundColor: Colors.grey,)
                    ,) :
                  BestDeals())
                ],
              ),

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
            children: List.generate(listModel.products.length, (index) {
              return InkWell(
                onTap: () {},
                child: Padding(
                  padding: (index + 1) % 2 == 0
                      ? EdgeInsets.only(left: 10, bottom: 15)
                      : EdgeInsets.only(right: 10, bottom: 15),
                  child: SizedBox(
                      width: (size.width - 60) / 2,
                      child: ProductEntryCard(
                          product: listModel.products[index], onPressed: () {
                            ProductEntry product = listModel.products[index];
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductEntryListing(ProductEntryListingPage(
                                            assetUrls: product.assetUrls,
                                            name: product.name,
                                            price: product.price,
                                            classification: product.classification,
                                            quantifier: product.quantifier,
                                            description: product.desc,
                                            averageReviewScore: 4,
                                            numberOfReviews: 17,
                                            userInfo: new UserInfo(
                                              profilePictureAssetUrl:
                                              'assets/avatars/vendor_andrew_ballantyne_cc_by.jpg',
                                              fullName: 'Petar Nikolić',
                                              reputationNegative: 7,
                                              reputationPositive: 240,
                                            )))));
                      })),
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
            children: List.generate(listModel.products.length, (index) {
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
                              assetUrls: listModel.products[index].assetUrls,
                              name: listModel.products[index].name,
                              price: listModel.products[index].price,
                              prevPrice: listModel.products[index].price * 2,
                              classification: listModel.products[index].classification,
                              quantifier: listModel.products[index].quantifier),
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

Widget HomeDrawer(BuildContext context, User user) {
  return Container(
    width: 255,
    child: new Drawer(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 50, 0, 0),
        color: Color(LIGHT_BLACK),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(user.photoUrl),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  user.forename + " " + user.surname,
                  style: TextStyle(
                      fontFamily: 'Inter', color: Colors.white, fontSize: 19),
                )
              ],
            ),
            SizedBox(height: 50),
            DrawerOption(
                text: "Moj nalog",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyAccount(user: user)));
                },
                iconUrl: "assets/icons/User.svg"),
            SizedBox(height: 50),
            DrawerOption(
                text: "Poruke",
                onPressed: () {},
                iconUrl: "assets/icons/Envelope.svg"),
            SizedBox(height: 50),
            DrawerOption(
                text: "Istorija narudžbi",
                onPressed: () {},
                iconUrl: "assets/icons/Newspaper.svg"),
            SizedBox(height: 50),
            DrawerOption(
                text: "Pomoć i podrška",
                onPressed: () {},
                iconUrl: "assets/icons/Handshake.svg"),
            SizedBox(height: 50),
            DrawerOption(
                text: "Podešavanja",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  );
                },
                iconUrl: "assets/icons/Gear.svg"),
            SizedBox(height: 50),
            DrawerOption(
                text: "Odjavi se",
                onPressed: () {
                  Navigator.pop(context);
                },
                iconUrl: "assets/icons/SignOut.svg"),
          ],
        ),
      ),
    ),
  );
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
