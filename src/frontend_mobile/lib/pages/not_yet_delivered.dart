import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../config.dart';
import '../models/ordersModel.dart';
import '../models/productsModel.dart';
import '../models/reviewsModel.dart';
import '../models/usersModel.dart';
import '../pages/product_entry_listing.dart';
import '../widgets.dart';
import '../internals.dart';
import 'package:provider/provider.dart';

class NotYetDelivered extends StatefulWidget {
  @override
  _NotYetDeliveredState createState() => _NotYetDeliveredState();
}

class _NotYetDeliveredState extends State<NotYetDelivered> {
  // ignore: deprecated_member_use
  OrdersModel ordersModel;

  setStatus(int orderId, int status) {
    ordersModel.setStatus(orderId, status);
  }

  int count = 0;
  @override
  Widget build(BuildContext context) {
    ordersModel = Provider.of<OrdersModel>(context);
    return Scaffold(
      backgroundColor: Color(BACKGROUND),
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(BACKGROUND),
          title: Text('Porudžbine na čekanju',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  color: Color(DARK_GREY),
                  fontWeight: FontWeight.w700)),
          leading: IconButton(
            icon: SvgPicture.asset('assets/icons/ArrowLeft.svg',
                color: Color(FOREGROUND)),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: ordersModel.isLoading == true
          ? LinearProgressIndicator(
              backgroundColor: Color(DARK_GREY),
            )
          : (ordersModel.deliveryOrders.length == 0
              ? Center(
                  child: Text('Nemate porudžbina na čekanju.',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(DARK_GREY))))
              : Container(
                  padding: EdgeInsets.all(20),
                  color: Color(BACKGROUND),
                  child: SingleChildScrollView(
                      child: Column(
                    children: List.generate(ordersModel.deliveryOrders.length,
                        (index) {
                      return MultiProvider(
                          providers: [
                            ChangeNotifierProvider<UsersModel>(
                                create: (_) => UsersModel.fromId(
                                    ordersModel.deliveryOrders[index].buyerId)),
                            ChangeNotifierProvider<ProductsModel>(
                                create: (_) => ProductsModel.forId(ordersModel
                                    .deliveryOrders[index].productId)),
                          ],
                          child: DeliveryOrder(
                              ordersModel.deliveryOrders[index], setStatus));
                    }),
                  )))),
    );
  }
}

class DeliveryOrder extends StatefulWidget {
  Order deliveryOrder;
  Function setStatus;
  DeliveryOrder(this.deliveryOrder, this.setStatus);
  @override
  _DeliveryOrderState createState() =>
      _DeliveryOrderState(deliveryOrder, setStatus);
}

class _DeliveryOrderState extends State<DeliveryOrder> {
  initiateRefresh() {
    //TODO
  }
  Order deliveryOrder;
  Function setStatus;
  _DeliveryOrderState(this.deliveryOrder, this.setStatus);
  UsersModel usersModel;
  ProductsModel productsModel;
  @override
  Widget build(BuildContext context) {
    usersModel = Provider.of<UsersModel>(context);
    productsModel = Provider.of<ProductsModel>(context);
    return usersModel.isLoading || productsModel.isLoading
        ? SizedBox(
            height: 0.5,
            child: LinearProgressIndicator(
              backgroundColor: Color(DARK_GREY),
            ))
        : Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Color(DARK_GREY), width: 1))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: productsModel.product.assetUrls[0] != ""
                            ? Image.network(
                                productsModel.product.assetUrls[0],
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 90,
                                height: 90,
                                color: Color(LIGHT_GREY))),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            productsModel.product.name != ""
                                ? ((productsModel.product.name.length <= 10
                                        ? productsModel.product.name
                                        : productsModel.product.name
                                                .substring(0, 10) +
                                            "...") +
                                    ' (' +
                                    productsModel.product.quantifier
                                        .toString() +
                                    (productsModel
                                                .product.classification.index ==
                                            0
                                        ? ""
                                        : (productsModel.product.classification
                                                    .index ==
                                                1
                                            ? "g"
                                            : "ml")) +
                                    ")")
                                : "-",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                color: Color(FOREGROUND),
                                fontWeight: FontWeight.w700)),
                        SizedBox(height: 5),
                        Text(
                            deliveryOrder.price.toStringAsFixed(2) +
                                ' $CURRENCY',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                color: Color(DARK_GREY))),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                constraints:
                                    BoxConstraints(minWidth: 24, maxWidth: 50),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        width: 3, color: Color(DARK_GREY))),
                                child: Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Center(
                                      child: Text(
                                    'x' + deliveryOrder.amount.toString(),
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(DARK_GREY)),
                                  )),
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (productsModel.product.name != "") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            new ChangeNotifierProvider(
                                                create: (context) =>
                                                    ReviewsModel(productsModel
                                                        .product.id),
                                                child: ProductEntryListing(
                                                    ProductEntryListingPage(
                                                      assetUrls: productsModel
                                                          .product.assetUrls,
                                                      name: productsModel
                                                          .product.name,
                                                      price: productsModel
                                                          .product.price,
                                                      discountPercentage:
                                                          productsModel.product
                                                              .discountPercentage,
                                                      classification:
                                                          productsModel.product
                                                              .classification,
                                                      quantifier: productsModel
                                                          .product.quantifier,
                                                      description: productsModel
                                                          .product.desc,
                                                      id: productsModel
                                                          .product.id,
                                                      userInfo: new UserInfo(
                                                        profilePictureAssetUrl:
                                                            'https://ipfs.io/ipfs/QmRCHi7CRFfbgyNXYsiSJ8wt8XMD3rjt3YCQ2LccpqwHke',
                                                        fullName:
                                                            'Petar Nikolić',
                                                        reputationNegative: 7,
                                                        reputationPositive: 240,
                                                      ),
                                                      vendor: usersModel.user,
                                                    ),
                                                    initiateRefresh))),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      new SnackBar(
                                          content: new Text(
                                              "Proizvod više nije u ponudi")));
                                }
                              },
                              child: Text('Stranica proizvoda ->',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Color(CYAN),
                                      fontSize: 16)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Detalji porudžbine:',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    color: Color(BLACK)))
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(LIGHT_GREY)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ime i prezime: ' +
                                    usersModel.user.name +
                                    " " +
                                    usersModel.user.surname,
                                style: TextStyle(
                                    fontFamily: 'IBM Plex Mono',
                                    fontSize: 16,
                                    color: Color(DARK_GREY)),
                              ),
                              SizedBox(height: 5),
                              Text(
                                  'Kontakt telefon: ' +
                                      usersModel.user.phoneNumber,
                                  style: TextStyle(
                                      fontFamily: 'IBM Plex Mono',
                                      fontSize: 16,
                                      color: Color(DARK_GREY))),
                              SizedBox(height: 15),
                              Text('Adresa: ' + deliveryOrder.deliveryAddress,
                                  style: TextStyle(
                                      fontFamily: 'IBM Plex Mono',
                                      fontSize: 16,
                                      color: Color(DARK_GREY))),
                              SizedBox(height: 15),
                              Text('Odlozena dostava: ' + (deliveryOrder.deliveryDate == null ? "NE" : "DA"),
                                  style: TextStyle(
                                      fontFamily: 'IBM Plex Mono',
                                      fontSize: 16,
                                      color: Color(DARK_GREY))),
                              SizedBox(height: 10),
                              (deliveryOrder.deliveryDate == null) ? SizedBox.shrink() :
                              Text("Datum dostave: ${deliveryOrder.deliveryDate.day}.${deliveryOrder.deliveryDate.month}.${deliveryOrder.deliveryDate.year}",
                                  style: TextStyle(
                                      fontFamily: 'IBM Plex Mono',
                                      fontSize: 16,
                                      color: Color(DARK_GREY))),
                              SizedBox(height: 10),
                              Text(
                                deliveryOrder.paymentType == 0
                                    ? "PLAĆANJE POUZEĆEM"
                                    : "PLAĆANO KRIPTOVALUTOM",
                                style: TextStyle(
                                    fontFamily: 'IBM Plex Mono',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(
                                        DARK_GREY)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('Iznos porudžbine:',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: Color(FOREGROUND))),
                    Spacer(),
                    Text(
                        (deliveryOrder.price * deliveryOrder.amount)
                                .toStringAsFixed(2) +
                            ' $CURRENCY',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24,
                            color: Color(DARK_GREY),
                            fontWeight: FontWeight.w700))
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 60) / 2,
                      height: 50,
                      child: ButtonOutline(
                        iconPath: 'assets/icons/Check.svg',
                        buttonType: type.GREEN,
                        text: 'Potvrdi',
                        onPressed: () {
                          setStatus(deliveryOrder.id, 1);
                          BigInt totalWei = BigInt.parse("4000000000000") *
                              BigInt.parse(
                                  (deliveryOrder.price * deliveryOrder.amount)
                                      .toInt()
                                      .toString());
                          performPayment(PRIVATE_KEY, usr.metamaskAddress,
                              wei: totalWei);
                        },
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 60) / 2,
                      height: 50,
                      child: ButtonOutline(
                        iconPath: 'assets/icons/Cross.svg',
                        buttonType: type.RED,
                        text: 'Otkaži',
                        onPressed: () {
                          setStatus(deliveryOrder.id, 3);
                          BigInt totalWei = BigInt.parse("4000000000000") *
                              BigInt.parse(
                                  (deliveryOrder.price * deliveryOrder.amount)
                                      .toInt()
                                      .toString());
                          performPayment(PRIVATE_KEY, usersModel.user.metamaskAddress,
                              wei: totalWei);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                )
              ],
            ),
          );
  }
}
