import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/models/ordersModel.dart';

import '../config.dart';

class DateOrders extends StatefulWidget {
  DateOrder dateOrder;
  Function getProductByIdCallback;
  DateOrders(this.dateOrder, this.getProductByIdCallback);

  @override
  _DateOrdersState createState() => _DateOrdersState(dateOrder, getProductByIdCallback);
}

class _DateOrdersState extends State<DateOrders> {

  DateOrder dateOrder;
  Function getProductByIdCallback;
  _DateOrdersState(this.dateOrder, this.getProductByIdCallback);
  List<ProductEntry> products = [];
  double sum = 0;
  @override
  void initState() {
    for (int i = 0; i < dateOrder.orders.length; i++){
      getProductByIdCallback(dateOrder.orders[i].productId).then((t){
          setState(() {
            products.add(t);
            sum += t.price;
            //print(t);
          });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(dateOrder.date.day.toString() + ". " +
              dateOrder.date.month.toString() + ". " +
              dateOrder.date.year.toString() + ". ",
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(DARK_GREY))),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/ArrowLeft.svg',
              height: ICON_SIZE,
              width: ICON_SIZE,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: ListView(
          children: [
            SizedBox(height: 20,),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(LIGHT_GREY),
                    borderRadius: BorderRadius.circular(5),

                  ),

                  child: Column(

                    children: List.generate(products.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                products[index].assetUrls[0],
                                height: 90,
                                width: 90,
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    products[index].name,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Color(BLACK))
                                ),
                                SizedBox(height: 10,),
                                Text(
                                    products[index].price.toStringAsFixed(2) + " €",
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        color: Color(DARK_GREY))
                                ),
                              ],
                            )
                          ],
                        )
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
                    color: Color(LIGHT_GREY),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0)),

                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text("Total:", style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(BLACK))),
                        Spacer(),
                        Text(sum.toStringAsFixed(2) + " €", style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(BLACK)))
                      ],
                    ),
                  ),
                )
                ),
            SizedBox(height: 20,)
          ]

      ),

    );
  }
}
