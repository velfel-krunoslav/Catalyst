import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../internals.dart';
import '../models/ordersModel.dart';
import '../models/reviewsModel.dart';
import '../models/usersModel.dart';
import '../pages/product_entry_listing.dart';
import 'package:provider/provider.dart';

import '../config.dart';

class DateOrders extends StatefulWidget {
  DateOrder dateOrder;
  Function getProductByIdCallback;
  VoidCallback initiateRefresh;
  DateOrders(this.dateOrder, this.getProductByIdCallback, this.initiateRefresh);

  @override
  _DateOrdersState createState() =>
      _DateOrdersState(dateOrder, getProductByIdCallback, initiateRefresh);
}

class _DateOrdersState extends State<DateOrders> {
  DateOrder dateOrder;
  Function getProductByIdCallback;
  VoidCallback initiateRefresh;
  _DateOrdersState(
      this.dateOrder, this.getProductByIdCallback, this.initiateRefresh);
  List<ProductEntry> products = [];
  double sum = 0;

  UsersModel usersModel;

  @override
  void initState() {
    for (int i = 0; i < dateOrder.orders.length; i++) {
      getProductByIdCallback(dateOrder.orders[i].productId).then((t) {
        setState(() {
          products.add(t);
          if (dateOrder.orders[i].status != 3)
            sum += dateOrder.orders[i].price * dateOrder.orders[i].amount;
          //print(t);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    usersModel = Provider.of<UsersModel>(context);

    return Scaffold(
      backgroundColor: Color(LIGHT_GREY),
      appBar: AppBar(
          title: Text(
              dateOrder.date.day.toString() +
                  ". " +
                  dateOrder.date.month.toString() +
                  ". " +
                  dateOrder.date.year.toString() +
                  ". ",
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(DARK_GREY))),
          centerTitle: true,
          backgroundColor: Color(BACKGROUND),
          elevation: 0.0,
          leading: IconButton(
            icon: SvgPicture.asset('assets/icons/ArrowLeft.svg',
                color: Color(FOREGROUND)),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: ListView(children: [
        SizedBox(
          height: 20,
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Container(
              decoration: BoxDecoration(
                color: Color(BACKGROUND),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                ),
              ),
              child: Column(
                children: List.generate(products.length, (index) {
                  return InkWell(
                    onTap: () {
                      ProductEntry product = products[index];
                      if (product.name != "") {
                        usersModel.getUserById(product.sellerId).then((value) {
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
                                                discountPercentage:
                                                    product.discountPercentage,
                                                classification:
                                                    product.classification,
                                                quantifier: product.quantifier,
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
                                            initiateRefresh))),
                          );
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                            content: new Text("Proizvod više nije u ponudi")));
                      }
                    },
                    child: Container(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: products[index].assetUrls[0] != ""
                                      ? Image.network(
                                          products[index].assetUrls[0],
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.fill,
                                        )
                                      : Container(
                                          width: 90,
                                          height: 90,
                                          color: Color(BACKGROUND),
                                        ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        products[index].name != ""
                                            ? (products[index].name.length <= 20
                                                ? products[index].name
                                                : products[index]
                                                        .name
                                                        .substring(0, 20) +
                                                    "...")
                                            : "-",
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Color(FOREGROUND))),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        dateOrder.orders[index].price
                                                .toStringAsFixed(2) +
                                            ' $CURRENCY',
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 16,
                                            color: Color(DARK_GREY))),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      dateOrder.orders[index].status == 0
                                          ? "Na čekanju"
                                          : (dateOrder.orders[index].status == 1
                                              ? "Potvrđeno"
                                              : (dateOrder.orders[index]
                                                          .status ==
                                                      2
                                                  ? "Isporučeno"
                                                  : "Refundirano")),
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: Color(DARK_GREY)),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Stranica proizvoda ->',
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Color(CYAN),
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Text(
                                  "x" +
                                      dateOrder.orders[index].amount.toString(),
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 18,
                                      color: Color(FOREGROUND)),
                                  textAlign: TextAlign.end,
                                )
                              ])),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Container(
              decoration: BoxDecoration(
                color: Color(BACKGROUND),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0)),
              ),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.grey, width: 1))),
                    child: Row(
                      children: [
                        SizedBox(height: 48),
                        Text("Total:",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(FOREGROUND))),
                        Spacer(),
                        Text(sum.toStringAsFixed(2) + CURRENCY,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(FOREGROUND)))
                      ],
                    ),
                  )),
            )),
        SizedBox(
          height: 20,
        )
      ]),
    );
  }
}
