import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config.dart';
import '../internals.dart';
import '../models/categoriesModel.dart';
import '../models/ordersModel.dart';
import '../models/reviewsModel.dart';
import '../models/usersModel.dart';
import '../widgets.dart';
import '../pages/product_entry_listing.dart';
import '../pages/consumer_cart.dart';
import '../pages/search_pages.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../internals.dart';
import 'package:flutter/widgets.dart';
import '../models/productsModel.dart';
import '../sizer_helper.dart'
    if (dart.library.html) '../sizer_web.dart'
    if (dart.library.io) '../sizer_io.dart';
import 'inbox.dart';

class ConsumerHomePage extends StatefulWidget {
  bool reg = false;
  ConsumerHomePage({this.reg});
  @override
  _ConsumerHomePageState createState() => _ConsumerHomePageState(reg);
}

class _ConsumerHomePageState extends State<ConsumerHomePage> {
  int category = -1;
  int activeMenu = 0;
  int cartItemsCount = 0;
  String query = "";
  final sizer = getSizer();
  List menuItems = ['Početna', 'Kategorije', 'Akcije'];
  String privateKey, accountAddress;

  GlobalKey<ScaffoldState> _scaffoldKey;

  List<ProductEntry> recently = [];
  List<ProductEntry> products = [];
  ProductsModel productsModel;
  CategoriesModel categoriesModel;
  UsersModel usersModel;
  int userID;
  bool reg;
  bool hasNewMessages = false;

  Function setHasNewMessages;

  _ConsumerHomePageState(this.reg);

  Future<ProductEntry> getProductByIdCallback(int id) async {
    return await productsModel.getProductById(id);
  }

  refreshProductsCallback() {
    productsModel.getProducts();
  }

  void callback(int cat) {
    setState(() {
      this.category = cat;
    });
  }

  void initiateCartRefresh() {
    setState(() {
      Prefs.instance.getStringValue('cartProducts').then((value) {
        if (value.length != 0) {
          bool containsSpacers = false;
          for (int i = 0; i < value.length; i++) {
            if (value[i] == ';') {
              containsSpacers = true;
            }
          }
          if (containsSpacers) {
            setState(() {
              cartItemsCount = value.split(';').length;
            });
          } else {
            setState(() {
              cartItemsCount = 1;
            });
          }
        } else {
          setState(() {
            cartItemsCount = 0;
          });
        }
      });
    });
  }

  void incrementCart() {
    setState(() {
      cartItemsCount++;
    });
  }

  void decrementCart() {
    setState(() {
      cartItemsCount--;
    });
  }

  Timer _timer;

  @override
  void initState() {
    super.initState();
    setHasNewMessages = (bool status) {
      setState(() {
        this.hasNewMessages = status;
      });
    };
    final _tmp = Provider.of<UsersModel>(context, listen: false);
    _scaffoldKey = GlobalKey<ScaffoldState>();
    initiateCartRefresh();
    if (reg == true) showWelcomeDialog();
    const time = const Duration(seconds: 30);
    _timer = new Timer.periodic(time, (Timer t) {
      requestGetChat(usr.id).then((rawData) {
        List<int> partnerIDs = [];
        List<int> chatIDs = [];
        List<ChatInfo> chatInfo = [];
        var tmp = jsonDecode(rawData);
        for (var t in tmp) {
          chatInfo.add(ChatInfo.fromJson(t));
        }
        for (var chat in chatInfo) {
          partnerIDs.add(
              (chat.idReciever != usr.id) ? chat.idReciever : chat.idSender);
          chatIDs.add(chat.id);
        }

        int newunread = 0;
        for (int index = 0; index < partnerIDs.length; index++) {
          _tmp.getUserById(partnerIDs[index]).then((userRawData) {
            requestChatID(usr.id, userRawData.id).then((chatID) {
              requestLatestMessageFromChat(chatIDs[index]).then((value) {
                // TODO CHECK IF RETURN IS NULL
                var msg = ChatMessageInfo.fromJson(jsonDecode(value)[0]);
                setState(() {
                  hasNewMessages = hasNewMessages || msg.unread;
                });
              });
            });
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  final keyCategories = GlobalKey<_ProductsForCategoryState>();

  final _textController = new TextEditingController();
  String hintDistance = "3";
  String filterCategoryName;
  String minPrice = "", maxPrice = "";
  String getFilterCategoryName() {
    return filterCategoryName;
  }

  String getMinPrice() {
    return minPrice;
  }

  String getMaxPrice() {
    return maxPrice;
  }

  var _currentCategorySelected = "Bez sortiranja";
  bool _value = false;
  onSwitchValueChanged(bool value) {
    setState(() {
      _value = value;
    });
  }

  applyFilter() {
    productsModel.apply(minPrice, maxPrice, filterCategoryName);
    if (keyCategories.currentState != null)
      keyCategories.currentState
          .setFilter(minPrice, maxPrice, filterCategoryName);
  }

  void _FilterButtonPress() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) {
            return SingleChildScrollView(
                child: Container(
              color: Color(BACKGROUND),
              height: 480,
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
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Color(FOREGROUND)),
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
                                  color: Color(FOREGROUND),
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
                                  color: Color(FOREGROUND),
                                  fontFamily: 'Inter',
                                  fontSize: 14)),
                        ),
                      ),
                      SizedBox(),
                    ],
                  ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 20.0, right: 5.0),
                            height: 60,
                            child: Text("Raspon cena ($CURRENCY):",
                                style: TextStyle(
                                    color: Color(FOREGROUND),
                                    fontFamily: 'Inter',
                                    fontSize: 14)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20.0, right: 5.0),
                            height: 60,
                            child: Text("Sortiraj:",
                                style: TextStyle(
                                    color: Color(FOREGROUND),
                                    fontFamily: 'Inter',
                                    fontSize: 14)),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                height: 60,
                                child: TextFormField(
                                  initialValue: minPrice,
                                  onChanged: (t) {
                                    minPrice = t;
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  decoration: InputDecoration(
                                    hintText: "0",
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
                                        color: Color(FOREGROUND),
                                        fontFamily: 'Inter',
                                        fontSize: 14)),
                              ),
                              SizedBox(
                                width: 100,
                                height: 60,
                                child: TextFormField(
                                  initialValue: maxPrice,
                                  onChanged: (t) {
                                    maxPrice = t;
                                  },
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
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 240,
                            height: 60,
                            child: DropdownButtonFormField<String>(
                              items: [
                                DropdownMenuItem<String>(
                                  value: "",
                                  child: Text("Bez sortiranja"),
                                ),
                                DropdownMenuItem<String>(
                                  value: "Najjeftinije prvo",
                                  child: Text("Najjeftinije prvo"),
                                ),
                                DropdownMenuItem<String>(
                                  value: "Najskuplje prvo",
                                  child: Text("Najskuplje prvo"),
                                ),
                              ],
                              onChanged: (String newCategorySelected) {
                                setState(() {
                                  filterCategoryName = newCategorySelected;
                                  _currentCategorySelected =
                                      newCategorySelected;
                                });
                              },
                              hint: Text(
                                _currentCategorySelected,
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Color(DARK_GREY)),
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(LIGHT_GREY),
                                border: const OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(5.0),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 86,
                            height: 40,
                            // ignore: deprecated_member_use
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              color: Color(LIGHT_GREY),
                              onPressed: () {
                                applyFilter();
                                Navigator.pop(context);
                              },
                              child: Text('Primeni',
                                  style: TextStyle(
                                      color: Color(DARK_GREY),
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
            ));
          });
        });
  }

  editUserCallback(User u) {
    final _tmp = Provider.of<UsersModel>(context, listen: false);
    setState(() {
      _tmp.user = u;
    });
  }

  @override
  Widget build(BuildContext context) {
    VoidCallback initiateSetState = () {
      setState(() {});
    };

    productsModel = Provider.of<ProductsModel>(context);
    categoriesModel = Provider.of<CategoriesModel>(context);
    usersModel = Provider.of<UsersModel>(context);
    usr = usersModel.user;
    return MaterialApp(
      theme: new ThemeData(scaffoldBackgroundColor: Color(BACKGROUND)),
      home: DefaultTabController(
        length: menuItems.length,
        child: Scaffold(
          floatingActionButton: Container(
            height: 70.0,
            width: 70.0,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {
                  _FilterButtonPress();
                },
                child: SvgPicture.asset('assets/icons/Filters.svg',
                    width: 24, height: 24),
                backgroundColor: Colors.white,
              ),
            ),
          ),
          key: _scaffoldKey,
          drawer: usersModel.isLoading
              ? LinearProgressIndicator()
              : HomeDrawer(
                  context,
                  usr,
                  refreshProductsCallback,
                  getProductByIdCallback,
                  incrementCart,
                  usersModel.getUserById,
                  hasNewMessages,
                  setHasNewMessages,
                  editUserCallback,
                  initiateSetState), //TODO context
          appBar: AppBar(
            centerTitle: true,
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
                                  height: 36,
                                  color: Color(FOREGROUND),
                                ),
                                onPressed: () {
                                  _scaffoldKey.currentState.openDrawer();
                                })),
                        Spacer(),
                        SizedBox(
                          width: 48,
                        ),
                        SvgPicture.asset(
                            'assets/icons/KotaricaIconMonochrome.svg',
                            color: BACKGROUND == 0xFF000000
                                ? Colors.white
                                : Color(DARK_GREEN)),
                        Spacer(),
                        IconButton(
                          icon: SvgPicture.asset(
                              'assets/icons/ShoppingCart.svg',
                              width: 36,
                              height: 36,
                              color: Color(FOREGROUND)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      new ChangeNotifierProvider(
                                          create: (context) => OrdersModel(0),
                                          child: ConsumerCart(
                                              getProductByIdCallback,
                                              initiateCartRefresh,
                                              showInSnackBar,
                                              incrementCart,
                                              decrementCart))),
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
                                  color: (cartItemsCount != 0)
                                      ? Colors.white
                                      : Color(DARK_GREY)),
                            ),
                          ),
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                              color: (cartItemsCount != 0)
                                  ? Color(TEAL)
                                  : Color(LIGHT_GREY),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                      ],
                      // TODO FIX BUG KEYBOARD NEEDS FIXING
                      style: TextStyle(fontFamily: 'Inter', fontSize: 16),
                      onChanged: (text) {
                        this.query = text;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 36),
                        fillColor: Color(LIGHT_GREY),
                        filled: true,
                        hintText: 'Pretraga',
                        hintStyle: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: Color(DARK_GREY)),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 15, right: 10),
                          child: SvgPicture.asset(
                            'assets/icons/MagnifyingGlass.svg',
                            color: Color(DARK_GREY),
                          ),
                        ),
                        border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(5.0),
                            ),
                            borderSide: BorderSide.none),
                      ),
                      onEditingComplete: () {
                        productsModel.getQueryProducts(this.query);
                        if (keyCategories.currentState != null)
                          keyCategories.currentState.setQuery(this.query);
                      },
                    ),
                  ],
                ),
              )),
            ),
            bottom: TabBar(
                indicatorColor: Color(FOREGROUND),
                labelPadding: EdgeInsets.all(8),
                tabs: List.generate(menuItems.length, (index) {
                  return Text(
                    menuItems[index],
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Color(FOREGROUND),
                      fontSize: 16,
                    ),
                  );
                })),
            backgroundColor: Color(BACKGROUND),
          ),
          body: Stack(
            children: [
              TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      color: Color(BACKGROUND),
                      child: productsModel.isLoading
                          ? Center(
                              child: LinearProgressIndicator(
                                backgroundColor: Color(DARK_GREY),
                              ),
                            )
                          : HomeContent(),
                    ),
                  ),
                  SingleChildScrollView(
                      child: category == -1
                          ? (categoriesModel.isLoading
                              ? Center(
                                  child: LinearProgressIndicator(
                                    backgroundColor: Color(DARK_GREY),
                                  ),
                                )
                              : Container(
                                  color: Color(BACKGROUND),
                                  child:
                                      Categories(categoriesModel.categories)))
                          : MultiProvider(
                              providers: [
                                  ChangeNotifierProvider<ProductsModel>(
                                      create: (_) => ProductsModel(category)),
                                  ChangeNotifierProvider<UsersModel>(
                                      create: (_) => UsersModel()),
                                ],
                              child: ProductsForCategory(
                                getMin: getMinPrice,
                                getMax: getMaxPrice,
                                getSort: getFilterCategoryName,
                                query: this.query,
                                key: keyCategories,
                                category: category,
                                categoryName:
                                    categoriesModel.categories[category].name,
                                callback: this.callback,
                                initiateRefresh: incrementCart,
                              ))),
                  SingleChildScrollView(
                      child: productsModel.isLoading
                          ? Center(
                              child: LinearProgressIndicator(
                                backgroundColor: Color(DARK_GREY),
                              ),
                            )
                          : Container(
                              color: Color(BACKGROUND),
                              child: BestDeals(initiateCartRefresh)))
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
            this.query == ""
                ? 'Preporučeno'
                : 'Pretraga: \"${(this.query.length > 10) ? this.query.substring(0, 10) + '...' : this.query}\"',
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
                            usersModel
                                .getUserById(product.sellerId)
                                .then((value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new ChangeNotifierProvider(
                                            create: (context) =>
                                                ReviewsModel(product.id),
                                            child: ProductEntryListing(
                                                ProductEntryListingPage(
                                                    assetUrls:
                                                        product.assetUrls,
                                                    name: product.name,
                                                    price: product.price,
                                                    discountPercentage: product
                                                        .discountPercentage,
                                                    classification:
                                                        product.classification,
                                                    quantifier:
                                                        product.quantifier,
                                                    description: product.desc,
                                                    id: product.id,
                                                    userInfo: new UserInfo(
                                                      profilePictureAssetUrl:
                                                          'https://ipfs.io/ipfs/QmRCHi7CRFfbgyNXYsiSJ8wt8XMD3rjt3YCQ2LccpqwHke',
                                                      fullName: 'Petar Nikolić',
                                                      reputationNegative: 7,
                                                      reputationPositive: 240,
                                                    ),
                                                    vendor: value),
                                                incrementCart))),
                              );
                            });
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
                              onPressed: () {},
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
                                  usersModel
                                      .getUserById(recently[index].sellerId)
                                      .then((value) {
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
                                                        discountPercentage:
                                                            recently[index]
                                                                .discountPercentage,
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
                                                              'https://ipfs.io/ipfs/QmRCHi7CRFfbgyNXYsiSJ8wt8XMD3rjt3YCQ2LccpqwHke',
                                                          fullName:
                                                              'Petar Nikolić',
                                                          reputationNegative: 7,
                                                          reputationPositive:
                                                              240,
                                                        ),
                                                        vendor: value),
                                                    initiateCartRefresh),
                                              )),
                                    );
                                  });
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
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

  Widget BestDeals(VoidCallback initiateRefresh) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Wrap(
            children:
                List.generate(productsModel.discountedProducts.length, (index) {
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
                              assetUrls: productsModel
                                  .discountedProducts[index].assetUrls,
                              name:
                                  productsModel.discountedProducts[index].name,
                              price: productsModel
                                      .discountedProducts[index].price *
                                  (1 -
                                      productsModel.discountedProducts[index]
                                              .discountPercentage /
                                          100),
                              prevPrice:
                                  productsModel.discountedProducts[index].price,
                              classification: productsModel
                                  .discountedProducts[index].classification,
                              quantifier: productsModel
                                  .discountedProducts[index].quantifier),
                          onPressed: () {
                            ProductEntry product =
                                productsModel.discountedProducts[index];
                            usersModel
                                .getUserById(product.sellerId)
                                .then((value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new ChangeNotifierProvider(
                                            create: (context) =>
                                                ReviewsModel(product.id),
                                            child: ProductEntryListing(
                                                ProductEntryListingPage(
                                                    assetUrls:
                                                        product.assetUrls,
                                                    name: product.name,
                                                    price: product.price,
                                                    discountPercentage: product
                                                        .discountPercentage,
                                                    classification:
                                                        product.classification,
                                                    quantifier:
                                                        product.quantifier,
                                                    description: product.desc,
                                                    id: product.id,
                                                    userInfo: new UserInfo(
                                                      profilePictureAssetUrl:
                                                          'https://ipfs.io/ipfs/QmRCHi7CRFfbgyNXYsiSJ8wt8XMD3rjt3YCQ2LccpqwHke',
                                                      fullName: 'Petar Nikolić',
                                                      reputationNegative: 7,
                                                      reputationPositive: 240,
                                                    ),
                                                    vendor: value),
                                                incrementCart))),
                              );
                            });
                          })),
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

  void showWelcomeDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
          backgroundColor: Color(BACKGROUND),
          title: Center(
              child: Text(
            "Uspešna registracija",
            style: TextStyle(color: Color(FOREGROUND)),
          )),
          content: Container(
            width: MediaQuery.of(context).size.width / 1.3,
            height: MediaQuery.of(context).size.height /
                4.5, // TODO PROVJERITI VISINU
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color(BACKGROUND),
              borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Uživajte u kupovini!",
                  maxLines: 6,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: Color(FOREGROUND),
                    fontSize: 18.0,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.center,
                ),
                ButtonFill(
                  text: "U redu",
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString("firstTime", "set");
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ProductsForCategory extends StatefulWidget {
  ProductsForCategory(
      {this.query,
      this.category,
      this.categoryName,
      this.callback,
      this.initiateRefresh,
      this.getMin,
      this.getMax,
      this.getSort,
      Key key})
      : super(key: key);
  int category;
  Function callback;
  String categoryName;
  VoidCallback initiateRefresh;
  String query;
  Function getMin;
  Function getMax;
  Function getSort;
  @override
  _ProductsForCategoryState createState() => _ProductsForCategoryState(
      category: category,
      categoryName: categoryName,
      callback: callback,
      initiateRefresh: initiateRefresh,
      query: query);
}

class _ProductsForCategoryState extends State<ProductsForCategory> {
  _ProductsForCategoryState(
      {this.query,
      this.category,
      this.categoryName,
      this.callback,
      this.initiateRefresh});
  List<ProductEntry> products;
  int category;
  Function callback;
  String categoryName;
  String query = "";
  VoidCallback initiateRefresh;
  var productsModel;
  UsersModel usersModel;
  var size;
  String minPrice;
  String maxPrice;
  String sortName;
  @override
  void initState() {
    super.initState();
    this.minPrice = widget.getMin();
    this.maxPrice = widget.getMax();
    this.sortName = widget.getSort();
  }

  void setQuery(String query) {
    setState(() {
      this.query = query;
    });
  }

  bool _isNumeric(String str) {
    try {
      var value = double.parse(str);
    } on FormatException {
      return false;
    } finally {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    productsModel = Provider.of<ProductsModel>(context);
    usersModel = Provider.of<UsersModel>(context);
    products = productsModel.productsForCategory.where((product) {
      var productTitle = product.name.toLowerCase();
      return productTitle.contains(query) ? true : false;
    }).toList();
    if (products.length > 0) {
      applyFilters();
    }
    return productsModel.isLoading
        ? Center(
            child: LinearProgressIndicator(
              backgroundColor: Color(DARK_GREY),
            ),
          )
        : Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: IconButton(
                        icon: SvgPicture.asset('assets/icons/ArrowLeft.svg',
                            color: Color(FOREGROUND)),
                        onPressed: () {
                          this.widget.callback(-1);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        categoryName,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 28,
                            color: Color(DARK_GREY),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
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
                              child: products[index].discountPercentage == 0
                                  ? ProductEntryCard(
                                      product: products[index],
                                      onPressed: () {
                                        ProductEntry product = products[index];
                                        usersModel
                                            .getUserById(product.sellerId)
                                            .then((value) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    new ChangeNotifierProvider(
                                                        create: (context) =>
                                                            ReviewsModel(
                                                                product.id),
                                                        child:
                                                            ProductEntryListing(
                                                                ProductEntryListingPage(
                                                                    assetUrls:
                                                                        product
                                                                            .assetUrls,
                                                                    name: product
                                                                        .name,
                                                                    price: product
                                                                        .price,
                                                                    discountPercentage:
                                                                        product
                                                                            .discountPercentage,
                                                                    classification:
                                                                        product
                                                                            .classification,
                                                                    quantifier:
                                                                        product
                                                                            .quantifier,
                                                                    description:
                                                                        product
                                                                            .desc,
                                                                    id:
                                                                        product
                                                                            .id,
                                                                    userInfo:
                                                                        new UserInfo(
                                                                      profilePictureAssetUrl:
                                                                          'https://ipfs.io/ipfs/QmRCHi7CRFfbgyNXYsiSJ8wt8XMD3rjt3YCQ2LccpqwHke',
                                                                      fullName:
                                                                          'Petar Nikolić',
                                                                      reputationNegative:
                                                                          7,
                                                                      reputationPositive:
                                                                          240,
                                                                    ),
                                                                    vendor:
                                                                        value),
                                                                initiateRefresh))),
                                          );
                                        });
                                      })
                                  : DiscountedProductEntryCard(
                                      product: new DiscountedProductEntry(
                                          assetUrls: products[index].assetUrls,
                                          name: products[index].name,
                                          price: products[index].price *
                                              (1 -
                                                  products[index]
                                                          .discountPercentage /
                                                      100),
                                          prevPrice: products[index].price,
                                          classification:
                                              products[index].classification,
                                          quantifier:
                                              products[index].quantifier),
                                      onPressed: () {
                                        ProductEntry product = products[index];
                                        usersModel
                                            .getUserById(product.sellerId)
                                            .then((value) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    new ChangeNotifierProvider(
                                                        create: (context) =>
                                                            ReviewsModel(
                                                                product.id),
                                                        child:
                                                            ProductEntryListing(
                                                                ProductEntryListingPage(
                                                                    assetUrls:
                                                                        product
                                                                            .assetUrls,
                                                                    name: product
                                                                        .name,
                                                                    price: product
                                                                        .price,
                                                                    discountPercentage:
                                                                        product
                                                                            .discountPercentage,
                                                                    classification:
                                                                        product
                                                                            .classification,
                                                                    quantifier:
                                                                        product
                                                                            .quantifier,
                                                                    description:
                                                                        product
                                                                            .desc,
                                                                    id:
                                                                        product
                                                                            .id,
                                                                    userInfo:
                                                                        new UserInfo(
                                                                      profilePictureAssetUrl:
                                                                          'https://ipfs.io/ipfs/QmRCHi7CRFfbgyNXYsiSJ8wt8XMD3rjt3YCQ2LccpqwHke',
                                                                      fullName:
                                                                          'Petar Nikolić',
                                                                      reputationNegative:
                                                                          7,
                                                                      reputationPositive:
                                                                          240,
                                                                    ),
                                                                    vendor:
                                                                        value),
                                                                initiateRefresh))),
                                          );
                                        });
                                      })),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
  }

  void setFilter(
      String _minPrice, String _maxPrice, String filterCategoryName) {
    setState(() {
      minPrice = _minPrice;
      maxPrice = _maxPrice;
      sortName = filterCategoryName;
    });
  }

  void applyFilters() {
    if (minPrice == "" ||
        minPrice == null ||
        !_isNumeric(minPrice) ||
        minPrice.isEmpty) {
      ProductEntry min = products[0];
      products.forEach((e) {
        if (e.price < min.price) min = e;
      });
      products.forEach((e) {
        if ((e.price - (e.price * e.discountPercentage / 100)) <
            (min.price - (min.price * min.discountPercentage / 100))) min = e;
      });
      if (min.discountPercentage == 0)
        minPrice = min.price.toString();
      else
        minPrice =
            (min.price - (min.price * min.discountPercentage / 100)).toString();
    }
    if (maxPrice == "" ||
        maxPrice == null ||
        !_isNumeric(maxPrice) ||
        maxPrice.isEmpty) {
      dynamic max = products.first;
      products.forEach((e) {
        if (e.price > max.price) max = e;
      });
      products.forEach((e) {
        if ((e.price - (e.price * e.discountPercentage / 100)) >
            (max.price - (max.price * max.discountPercentage / 100))) max = e;
      });
      if (max.discountPercentage == 0)
        maxPrice = max.price.toString();
      else
        maxPrice =
            (max.price - (max.price * max.discountPercentage / 100)).toString();
    }
    products = products
        .where((e) =>
            (e.price - (e.price * e.discountPercentage / 100)) >=
                double.parse(minPrice) &&
            (e.price - (e.price * e.discountPercentage / 100)) <=
                double.parse(maxPrice))
        .toList();
    if (sortName == "Najjeftinije prvo") {
      products.sort((a, b) => (a.price - (a.price * a.discountPercentage / 100))
          .compareTo((b.price - (b.price * b.discountPercentage / 100))));
    } else if (sortName == "Najjeftinije prvo") {
      products.sort((a, b) => (b.price - (b.price * b.discountPercentage / 100))
          .compareTo((a.price - (a.price * a.discountPercentage / 100))));
    } else {
      products.sort((a, b) => a.id.compareTo(b.id));
    }
  }
}
