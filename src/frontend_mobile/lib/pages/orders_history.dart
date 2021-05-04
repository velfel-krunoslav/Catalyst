import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/models/ordersModel.dart';
import 'package:frontend_mobile/pages/product_reviews.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../widgets.dart';
import 'date_orders.dart';

class OrdersHistory extends StatefulWidget {
  Function getProductByIdCallback;
  VoidCallback initiateRefresh;
  OrdersHistory(this.getProductByIdCallback, VoidCallback initiateRefresh);

  @override
  _OrdersHistoryState createState() =>
      _OrdersHistoryState(getProductByIdCallback, initiateRefresh);
}

class _OrdersHistoryState extends State<OrdersHistory> {
  OrdersModel ordersModel;
  Function getProductByIdCallback;
  VoidCallback initiateRefresh;
  _OrdersHistoryState(
      this.getProductByIdCallback, VoidCallback initiateRefresh);
  @override
  Widget build(BuildContext context) {
    ordersModel = Provider.of<OrdersModel>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(LIGHT_GREY),
      appBar: AppBar(
        title: Text(
          "Istorija narudžbi",
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
      body: ordersModel.isLoading == true
          ? LinearProgressIndicator(
              backgroundColor: Colors.grey,
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(45, 40, 45, 30),
              child: ListView(children: [
                //SizedBox(height: 10,),
                SingleChildScrollView(
                  child: Column(
                    children:
                        List.generate(ordersModel.dateOrders.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: SettingsOption(
                          text: ordersModel
                                  .dateOrders[index].date.day
                                  .toString() +
                              ". " +
                              ordersModel.dateOrders[index].date.month
                                  .toString() +
                              ". " +
                              ordersModel.dateOrders[index].date.year
                                  .toString() +
                              ". ",
                          icon: Icon(Icons.date_range),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DateOrders(
                                      ordersModel.dateOrders[index],
                                      getProductByIdCallback,
                                      initiateRefresh)),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                )
              ]),
            ),
    );
  }
}
