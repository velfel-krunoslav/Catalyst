import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/models/productsModel.dart';
import 'package:frontend_mobile/models/reviewsModel.dart';
import 'package:frontend_mobile/pages/new_product.dart';
import 'package:frontend_mobile/pages/product_entry_listing.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:provider/provider.dart';

import '../internals.dart';

class MyProducts extends StatefulWidget {
  Function refreshProductsCallback;
  MyProducts(this.refreshProductsCallback);

  @override
  _MyProductsState createState() => _MyProductsState(refreshProductsCallback);
}

class _MyProductsState extends State<MyProducts> {
  Function refreshProductsCallback;

  ProductsModel productsModel;
  _MyProductsState(this.refreshProductsCallback);
  List<ProductEntry> products = [];
  bool isLoading = true;

  Function addProductCallback2(
      String name,
      double price,
      List<String> assetUrls,
      int classification,
      int quantifier,
      String desc,
      int sellerId,
      int categoryId) {
    productsModel.addProduct(name, price, assetUrls, classification, quantifier,
        desc, sellerId, categoryId).then((v){
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewProduct(addProductCallback2)),
            );
          },
          icon: SvgPicture.asset("assets/icons/PlusCircle.svg",color: Colors.white,),
          label: Text("Dodaj proizvod", style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontWeight: FontWeight.w700),),
          backgroundColor: Color(MINT),
        ),
    body: productsModel.isLoading == true ? LinearProgressIndicator() :
    ListView(
      children: [
        SizedBox(height: 20,),
        SingleChildScrollView(
          child: Padding(
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
                              ProductEntry product =
                              productsModel.products[index];
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
                                                ),
                                              vendor: usr
                                            )))),
                              );
                            })),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    )

    );
  }
}
