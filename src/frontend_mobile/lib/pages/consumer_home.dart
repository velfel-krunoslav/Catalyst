import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/models/categoriesModel.dart';
import 'package:frontend_mobile/models/ordersModel.dart';
import 'package:frontend_mobile/models/reviewsModel.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:frontend_mobile/pages/product_entry_listing.dart';
import 'package:frontend_mobile/pages/consumer_cart.dart';
import 'package:frontend_mobile/pages/search_pages.dart';
import 'package:frontend_mobile/pages/settings.dart';
import 'package:frontend_mobile/pages/my_account.dart';
import 'package:provider/provider.dart';
import '../internals.dart';
import 'new_product.dart';
import '../models/productsModel.dart';

class ConsumerHomePage extends StatefulWidget {
  @override
  _ConsumerHomePageState createState() => _ConsumerHomePageState();
}

class _ConsumerHomePageState extends State<ConsumerHomePage> {
  int category = -1;
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
  var productsModel;
  var categoriesModel;
  var ordersModel;

  void addProductCallback(String name, double price, List<String> assetUrls, int classification, int quantifier, String desc, int sellerId, int categoryId){
    productsModel.addProduct(name, price, assetUrls, classification, quantifier, desc, sellerId, categoryId);
  }

  void callback(int cat) {
    setState(() {
      this.category = cat;
    });
  }
  @override
  Widget build(BuildContext context) {
    productsModel = Provider.of<ProductsModel>(context);
    categoriesModel = Provider.of<CategoriesModel>(context);
    ordersModel = Provider.of<OrdersModel>(context);
    //TODO  ProductEntry p = productsModel.getProductById(0);
    //     print(p.name);
    return MaterialApp(
      home: DefaultTabController(
        length: menuItems.length,
        child: Scaffold(
          drawer: HomeDrawer(context, user, addProductCallback), //TODO context
          appBar: AppBar(
            toolbarHeight: 160,
            flexibleSpace: Container(
              child: SafeArea(
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
            ),
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
                  SingleChildScrollView(
                      child: productsModel.isLoading
                          ? Center(
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.grey,
                              ),
                            )
                          : HomeContent()),
                  SingleChildScrollView(
                      child: category == -1 ? (categoriesModel.isLoading ?
                      Center(
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.grey,
                        ),
                      ) : Categories(categoriesModel.categories)
                      )
                          :
                      ChangeNotifierProvider(
                              create: (context) =>
                                  ProductsModel(category),
                              child: ProductsForCategory(category: category, categoryName: categoriesModel.categories[category].name, callback: this.callback) )
                  )
                  ,
                  SingleChildScrollView(
                      child: productsModel.isLoading
                          ? Center(
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.grey,
                              ),
                            )
                          : BestDeals())
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
            children: List.generate(productsModel.products.length, (index) {
              return InkWell(
                onTap: () {},
                child: Padding(
                  padding: (index + 1) % 2 == 0
                      ? EdgeInsets.only(left: 10, bottom: 15)
                      : EdgeInsets.only(right: 10, bottom: 15),
                  child: SizedBox(
                      width: (size.width - 60) / 2,
                      child: ProductEntryCard(
                          product: productsModel.products[index],
                          onPressed: () {
                            ProductEntry product = productsModel.products[index];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      new ChangeNotifierProvider(
                                          create: (context) =>
                                              ReviewsModel(product.id),
                                          child: ProductEntryListing(
                                              ProductEntryListingPage(
                                                  assetUrls: product.assetUrls,
                                                  name: product.name,
                                                  price: product.price,
                                                  classification:
                                                      product.classification,
                                                  quantifier:
                                                      product.quantifier,
                                                  description: product.desc,
                                                  id: product.id,
                                                  userInfo: new UserInfo(
                                                    profilePictureAssetUrl:
                                                        'assets/avatars/vendor_andrew_ballantyne_cc_by.jpg',
                                                    fullName: 'Petar Nikolić',
                                                    reputationNegative: 7,
                                                    reputationPositive: 240,
                                                  ))))),
                            );
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
            children: List.generate(productsModel.products.length, (index) {
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
                              assetUrls: productsModel.products[index].assetUrls,
                              name: productsModel.products[index].name,
                              price: productsModel.products[index].price,
                              prevPrice: productsModel.products[index].price * 2,
                              classification:
                              productsModel.products[index].classification,
                              quantifier: productsModel.products[index].quantifier),
                          onPressed: () {})),
                ),
              );
            }),
          ),
        )
      ],
    );
  }
  Widget Categories(List<Category> categories){

    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
            children: List.generate(categories.length, (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    category = index;
                  });
                },
                child: CategoryEntry(
                    categories[index].assetUrl, categories[index].name),
              );
            })));


  }
}




