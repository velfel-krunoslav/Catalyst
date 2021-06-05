import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../models/productsModel.dart';
import '../models/reviewsModel.dart';
import '../pages/new_product.dart';
import '../pages/product_entry_listing.dart';
import '../widgets.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../internals.dart';

class MyProducts extends StatefulWidget {
  Function refreshProductsCallback;
  VoidCallback initiateRefresh;
  MyProducts(this.refreshProductsCallback, this.initiateRefresh);

  @override
  _MyProductsState createState() =>
      _MyProductsState(refreshProductsCallback, initiateRefresh);
}

class _MyProductsState extends State<MyProducts> {
  Function refreshProductsCallback;
  VoidCallback initiateRefresh;
  ProductsModel productsModel;
  _MyProductsState(this.refreshProductsCallback, this.initiateRefresh);
  List<ProductEntry> products = [];
  RegExp regNum = new RegExp(r'^[0-9]+$');

  void addProductCallback2(
      String name,
      double price,
      List<String> assetUrls,
      int classification,
      int quantifier,
      String desc,
      int sellerId,
      int categoryId,
      int inStock) {
    productsModel
        .addProduct(name, price, assetUrls, classification, quantifier, desc,
            sellerId, categoryId, inStock)
        .then((v) {
      refreshProductsCallback();
      showInSnackBar("Proizvod je uspešno dodat");
    });
  }

  void editProductCallback(ProductEntry p) {
    productsModel
        .editProduct(p.id, p.name, p.price, p.assetUrls, p.classification.index,
            p.quantifier, p.desc, p.categoryId, p.inStock)
        .then((v) {
      refreshProductsCallback();
    });
  }

  void setSale(int productId, int percentage) {
    productsModel.setSale(productId, percentage).then((v) {
      refreshProductsCallback();
    });
  }

  void removeProduct(int productId) {
    productsModel.removeProduct(productId).then((v) {
      refreshProductsCallback();
    });
  }

  static GlobalKey<ScaffoldState> _scaffoldKey;
  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    productsModel = Provider.of<ProductsModel>(context);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(BACKGROUND),
        appBar: AppBar(
          title: Text(
            "Moji proizvodi",
            style: TextStyle(fontFamily: 'Inter', color: Color(FOREGROUND)),
          ),
          backgroundColor: Color(BACKGROUND),
          elevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset("assets/icons/ArrowLeft.svg",
                color: Color(FOREGROUND)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        floatingActionButton: SizedBox(
          width: 84,
          child: ButtonFill(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewProduct(addProductCallback2)),
              );
            },
            iconPath: "assets/icons/PlusCircle.svg",
          ),
        ),
        body: productsModel.isLoading == true
            ? LinearProgressIndicator(
                backgroundColor: Colors.grey,
              )
            : productsModel.products.length == 0
                ? Center(
                    child: Text('Nemate proizvoda u ponudi.',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(DARK_GREY))))
                : ListView(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Wrap(
                            children: List.generate(
                                productsModel.products.length, (index) {
                              return InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: (size.width >= 640)
                                      ? EdgeInsets.fromLTRB(
                                          ((index % 3 == 0) ? 0 : 1) * 10.0,
                                          0,
                                          (((index - 2) % 3 == 0) ? 0 : 1) *
                                              10.0,
                                          15)
                                      : EdgeInsets.fromLTRB(
                                          ((index % 2 == 0) ? 0 : 1) * 10.0,
                                          0,
                                          (((index - 1) % 2 == 0) ? 0 : 1) *
                                              10.0,
                                          15),
                                  child: SizedBox(
                                      width: (size.width >= 640)
                                          ? (size.width - 80) / 3
                                          : (size.width - 60) / 2,
                                      child: productsModel.products[index]
                                                  .discountPercentage ==
                                              0
                                          ? ProductEntryCard(
                                              product:
                                                  productsModel.products[index],
                                              onPressed: () {
                                                ProductEntry product =
                                                    productsModel
                                                        .products[index];
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => new ChangeNotifierProvider(
                                                          create: (context) => ReviewsModel(product.id),
                                                          child: ProductEntryListing(
                                                              ProductEntryListingPage(
                                                                  inStock: product.inStock,
                                                                  categoryId: product.categoryId,
                                                                  assetUrls: product.assetUrls,
                                                                  name: product.name,
                                                                  price: product.price,
                                                                  discountPercentage: product.discountPercentage,
                                                                  classification: product.classification,
                                                                  quantifier: product.quantifier,
                                                                  description: product.desc,
                                                                  id: product.id,
                                                                  userInfo: new UserInfo(
                                                                    profilePictureAssetUrl:
                                                                        'https://ipfs.io/ipfs/QmRCHi7CRFfbgyNXYsiSJ8wt8XMD3rjt3YCQ2LccpqwHke',
                                                                    fullName:
                                                                        'Petar Nikolić',
                                                                    reputationNegative:
                                                                        7,
                                                                    reputationPositive:
                                                                        240,
                                                                  ),
                                                                  vendor: usr),
                                                              initiateRefresh,
                                                              setSale: setSale,
                                                              removeProduct: removeProduct,
                                                              editProduct: editProductCallback))),
                                                );
                                              })
                                          : DiscountedProductEntryCard(
                                              product: new DiscountedProductEntry(
                                                  assetUrls: productsModel
                                                      .products[index]
                                                      .assetUrls,
                                                  name: productsModel
                                                      .products[index].name,
                                                  price: productsModel.products[index].price *
                                                      (1 -
                                                          productsModel.products[index].discountPercentage /
                                                              100),
                                                  prevPrice: productsModel
                                                      .products[index].price,
                                                  classification: productsModel
                                                      .products[index]
                                                      .classification,
                                                  quantifier: productsModel
                                                      .products[index]
                                                      .quantifier),
                                              onPressed: () {
                                                ProductEntry product =
                                                    productsModel
                                                        .products[index];
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => new ChangeNotifierProvider(
                                                          create: (context) => ReviewsModel(product.id),
                                                          child: ProductEntryListing(
                                                              ProductEntryListingPage(
                                                                  inStock: product.inStock,
                                                                  categoryId: product.categoryId,
                                                                  assetUrls: product.assetUrls,
                                                                  name: product.name,
                                                                  price: product.price,
                                                                  discountPercentage: product.discountPercentage,
                                                                  classification: product.classification,
                                                                  quantifier: product.quantifier,
                                                                  description: product.desc,
                                                                  id: product.id,
                                                                  userInfo: new UserInfo(
                                                                    profilePictureAssetUrl:
                                                                        'https://ipfs.io/ipfs/QmRCHi7CRFfbgyNXYsiSJ8wt8XMD3rjt3YCQ2LccpqwHke',
                                                                    fullName:
                                                                        'Petar Nikolić',
                                                                    reputationNegative:
                                                                        7,
                                                                    reputationPositive:
                                                                        240,
                                                                  ),
                                                                  vendor: usr),
                                                              initiateRefresh,
                                                              setSale: setSale,
                                                              removeProduct: removeProduct,
                                                              editProduct: editProductCallback))),
                                                );
                                              })),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ));
  }
}
