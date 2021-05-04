import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend_mobile/models/productsModel.dart';
import 'package:frontend_mobile/models/reviewsModel.dart';
import 'package:frontend_mobile/pages/new_product.dart';
import 'package:frontend_mobile/pages/product_entry_listing.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:provider/provider.dart';

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

  void addProductCallback2(
      String name,
      double price,
      List<String> assetUrls,
      int classification,
      int quantifier,
      String desc,
      int sellerId,
      int categoryId) {
    productsModel
        .addProduct(name, price, assetUrls, classification, quantifier, desc,
            sellerId, categoryId)
        .then((v) {
      refreshProductsCallback();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    productsModel = Provider.of<ProductsModel>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Moji proizvodi",
            style: TextStyle(fontFamily: 'Inter', color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset("assets/icons/ArrowLeft.svg"),
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
            ? LinearProgressIndicator()
            : ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Wrap(
                        children: List.generate(productsModel.products.length,
                            (index) {
                          return InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: (size.width >= 640)
                                  ? EdgeInsets.fromLTRB(
                                      ((index % 3 == 0) ? 0 : 1) * 10.0,
                                      0,
                                      (((index - 2) % 3 == 0) ? 0 : 1) * 10.0,
                                      15)
                                  : EdgeInsets.fromLTRB(
                                      ((index % 2 == 0) ? 0 : 1) * 10.0,
                                      0,
                                      (((index - 1) % 2 == 0) ? 0 : 1) * 10.0,
                                      15),
                              child: SizedBox(
                                  width: (size.width >= 640)
                                      ? (size.width - 80) / 3
                                      : (size.width - 60) / 2,
                                  child: ProductEntryCard(
                                      product: productsModel.products[index],
                                      onPressed: () {
                                        ProductEntry product =
                                            productsModel.products[index];
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
                                                                  assetUrls: product
                                                                      .assetUrls,
                                                                  name: product
                                                                      .name,
                                                                  price: product
                                                                      .price,
                                                                  classification:
                                                                      product
                                                                          .classification,
                                                                  quantifier:
                                                                      product
                                                                          .quantifier,
                                                                  description:
                                                                      product
                                                                          .desc,
                                                                  id: product
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
                                                                  vendor: usr),
                                                              initiateRefresh))),
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
