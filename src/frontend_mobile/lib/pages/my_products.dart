import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/models/reviewsModel.dart';
import 'package:frontend_mobile/pages/new_product.dart';
import 'package:frontend_mobile/pages/product_entry_listing.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:provider/provider.dart';

import '../internals.dart';

class MyProducts extends StatefulWidget {
  Function addProductCallback;
  Function sellersProductsCallback;
  MyProducts(this.addProductCallback, this.sellersProductsCallback);

  @override
  _MyProductsState createState() => _MyProductsState(addProductCallback, sellersProductsCallback);
}

class _MyProductsState extends State<MyProducts> {
  Function addProductCallback;
  Function sellersProductsCallback;
  _MyProductsState(this.addProductCallback, this.sellersProductsCallback);
  List<ProductEntry> products = [];
  
  @override
  void initState() {
    sellersProductsCallback().then((t){
      for(int i = 0; i < t.length; i++){
        setState(() {
          products.add(t[i]);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
    appBar: AppBar(
        title: Text(
          "Moji proizvodi",
          style: TextStyle(color: Colors.black),
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
              MaterialPageRoute(builder: (context) => NewProduct(addProductCallback)),
            );
          },
          icon: SvgPicture.asset("assets/icons/PlusCircle.svg",color: Colors.white,),
          label: Text("Dodaj proizvod",),
          backgroundColor: Color(MINT),
        ),
    body: ListView(
      children: [
        SizedBox(height: 20,),
        SingleChildScrollView(
          child: Padding(
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
                            product: products[index],
                            onPressed: () {
                              ProductEntry product =
                              products[index];
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
        ),
      ],
    )

    );
  }
}
