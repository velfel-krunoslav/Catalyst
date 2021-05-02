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
import 'package:provider/provider.dart';
import '../internals.dart';
import '../models/productsModel.dart';
import '../sizer_helper.dart'
    if (dart.library.html) '../sizer_web.dart'
    if (dart.library.io) '../sizer_io.dart';

class ConsumerHomePage extends StatefulWidget {
  @override
  _ConsumerHomePageState createState() => _ConsumerHomePageState();
}

class _ConsumerHomePageState extends State<ConsumerHomePage> {
  int category = -1;
  int activeMenu = 0;
  int cartItemsCount = 0;
  String query;
  final sizer = getSizer();
  List menuItems = ['Početna', 'Kategorije', 'Akcije'];
  static GlobalKey<ScaffoldState> _scaffoldKey;
  User user = new User(
    name: "Petar",
    surname: "Nikolić",
    photoUrl: "assets/avatars/vendor_andrew_ballantyne_cc_by.jpg",
    phoneNumber: "+49 76 859 69 58",
    homeAddress: "4070 Jehovah Drive",
    email: "jay.ritter@gmail.com",
    desc: "Lorem ipsum dolor sit amet, consectetur adipiscing elit,"
        " sed do eiusmod tempor incididunt ut labore et dolore magna "
        "aliqua.",
    //rating: 4.5,);
  );
  List<ProductEntry> recently = [];
  List<ProductEntry> products = [];
  ProductsModel productsModel;
  var categoriesModel;

  Future<ProductEntry> getProductByIdCallback(int id) async {
    return await productsModel.getProductById(id);
  }

  void addProductCallback(
      String name,
      double price,
      List<String> assetUrls,
      int classification,
      int quantifier,
      String desc,
      int sellerId,
      int categoryId) {
    productsModel.addProduct(name, price, assetUrls, classification, quantifier,
        desc, sellerId, categoryId);
  }

  Future<List<ProductEntry>> sellersProductsCallback() async {
    return await productsModel.getSellersProducts(1); //one sellerId
  }

  void callback(int cat) {
    setState(() {
      this.category = cat;
    });
  }

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    Prefs.instance.setStringValue('cartProducts', '0,1;1,1;4,1;5,1');
  }

  @override
  Widget build(BuildContext context) {
    print(cartItemsCount);
    productsModel = Provider.of<ProductsModel>(context);
    categoriesModel = Provider.of<CategoriesModel>(context);

    //TODO  ProductEntry p = productsModel.getProductById(0);
    //     print(p.name);
    return MaterialApp(
      home: DefaultTabController(
        length: menuItems.length,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: HomeDrawer(context, user, addProductCallback,
              sellersProductsCallback, getProductByIdCallback), //TODO context
          appBar: AppBar(
            automaticallyImplyLeading: false,
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
                                  _scaffoldKey.currentState.openDrawer();
                                })),
                        Spacer(),
                        IconButton(
                          icon: SvgPicture.asset(
                              'assets/icons/ShoppingCart.svg',
                              width: 36,
                              height: 36),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      new ChangeNotifierProvider(
                                          create: (context) => OrdersModel(0),
                                          child: ConsumerCart(
                                              getProductByIdCallback))),
                            );
                          },
                        ),
                        Container(
                          child: Center(
                            child: Text(
                              cartItemsCount.toString(),
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
                    SizedBox(height: 10),
                    TextField(
                      style: TextStyle(fontFamily: 'Inter', fontSize: 16),
                      onChanged: (text) {
                        this.query = text;
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
                      onEditingComplete: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SearchPage(query: this.query)));
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
                      child: category == -1
                          ? (categoriesModel.isLoading
                              ? Center(
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.grey,
                                  ),
                                )
                              : Categories(categoriesModel.categories))
                          : ChangeNotifierProvider(
                              create: (context) => ProductsModel(category),
                              child: ProductsForCategory(
                                  category: category,
                                  categoryName:
                                      categoriesModel.categories[category].name,
                                  callback: this.callback))),
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
                  padding: (size.width >= 640)
                      ? EdgeInsets.fromLTRB(((index % 3 == 0) ? 0 : 1) * 10.0,
                          0, (((index - 2) % 3 == 0) ? 0 : 1) * 10.0, 15)
                      : EdgeInsets.fromLTRB(((index % 2 == 0) ? 0 : 1) * 10.0,
                          0, (((index - 1) % 2 == 0) ? 0 : 1) * 10.0, 15),
                  child: SizedBox(
                      width: (size.width >= 640)
                          ? (size.width - 80) / 3
                          : (size.width - 60) / 2,
                      child: ProductEntryCard(
                          product: productsModel.products[index],
                          onPressed: () {
                            ProductEntry product =
                                productsModel.products[index];
                            bool isInList = false;
                            for (var p in recently) {
                              if (p.id == product.id) isInList = true;
                            }
                            if (!isInList) {
                              setState(() {
                                recently.insert(0, product);
                                if (recently.length > 3) {
                                  recently.removeAt(3);
                                }
                              });
                            }
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
        (recently.length != 0)
            ? Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 30, bottom: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Nedavno ste pogledali',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 28,
                              color: Color(DARK_GREY),
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                        children: List.generate(
                            (recently.length < 3) ? recently.length : 3,
                            (index) {
                      if (((index + 2) * 10) + 40 > size.width) {
                        return Expanded(
                          child: SizedBox(
                            height: 90,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Color(LIGHT_GREY)),
                              child: Text(
                                '+' + (recently.length - 2).toString(),
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 24,
                                    color: Color(DARK_GREY)),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            new ChangeNotifierProvider(
                                                create: (context) =>
                                                    ReviewsModel(
                                                        recently[index].id),
                                                child: ProductEntryListing(
                                                    ProductEntryListingPage(
                                                        assetUrls:
                                                            recently[index]
                                                                .assetUrls,
                                                        name: recently[index]
                                                            .name,
                                                        price: recently[index]
                                                            .price,
                                                        classification:
                                                            recently[index]
                                                                .classification,
                                                        quantifier:
                                                            recently[index]
                                                                .quantifier,
                                                        description:
                                                            recently[index]
                                                                .desc,
                                                        id: recently[index].id,
                                                        userInfo: new UserInfo(
                                                          profilePictureAssetUrl:
                                                              'assets/avatars/vendor_andrew_ballantyne_cc_by.jpg',
                                                          fullName:
                                                              'Petar Nikolić',
                                                          reputationNegative: 7,
                                                          reputationPositive:
                                                              240,
                                                        ))))),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.asset(
                                    recently[index].assetUrls[0],
                                    height: 90,
                                    width: 90,
                                    fit: BoxFit.fill,
                                  ),
                                )),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        );
                      }
                    }).toList())
                  ],
                ))
            : Container()
      ],
    );
  }

  Widget BestDeals() {
    final size = MediaQuery.of(context).size;

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
                  padding: (size.width >= 640)
                      ? EdgeInsets.fromLTRB(((index % 3 == 0) ? 0 : 1) * 10.0,
                          0, (((index - 2) % 3 == 0) ? 0 : 1) * 10.0, 15)
                      : EdgeInsets.fromLTRB(((index % 2 == 0) ? 0 : 1) * 10.0,
                          0, (((index - 1) % 2 == 0) ? 0 : 1) * 10.0, 15),
                  child: SizedBox(
                      width: (size.width >= 640)
                          ? (size.width - 80) / 3
                          : (size.width - 60) / 2,
                      child: DiscountedProductEntryCard(
                          product: new DiscountedProductEntry(
                              assetUrls:
                                  productsModel.products[index].assetUrls,
                              name: productsModel.products[index].name,
                              price: productsModel.products[index].price,
                              prevPrice:
                                  productsModel.products[index].price * 2,
                              classification:
                                  productsModel.products[index].classification,
                              quantifier:
                                  productsModel.products[index].quantifier),
                          onPressed: () {})),
                ),
              );
            }),
          ),
        )
      ],
    );
  }

  Widget Categories(List<Category> categories) {
    final size = MediaQuery.of(context).size;

    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
            children: List.generate(
                (size.width >= 640)
                    ? ((categories.length + 1) / 2.0).toInt()
                    : categories.length, (index) {
          if (size.width >= 640) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width / 2.0 - 20,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        category = index * 2;
                      });
                    },
                    child: CategoryEntry(categories[index * 2].assetUrl,
                        categories[index * 2].name),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                (index * 2 + 1 >= categories.length)
                    ? SizedBox()
                    : SizedBox(
                        width: size.width / 2.0 - 20,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              category = index * 2 + 1;
                            });
                          },
                          child: CategoryEntry(
                              categories[index * 2 + 1].assetUrl,
                              categories[index * 2 + 1].name),
                        ),
                      )
              ],
            );
          } else {
            return InkWell(
              onTap: () {
                setState(() {
                  category = index;
                });
              },
              child: CategoryEntry(
                  categories[index].assetUrl, categories[index].name),
            );
          }
        })));
  }
}
