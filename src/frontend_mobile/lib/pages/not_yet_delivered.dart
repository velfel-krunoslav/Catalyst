import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/pages/consumer_home.dart';

import 'package:frontend_mobile/widgets.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NotYetDelivered extends StatefulWidget {
  @override
  _NotYetDeliveredState createState() => _NotYetDeliveredState();
}

class _NotYetDeliveredState extends State<NotYetDelivered> {
  // ignore: deprecated_member_use
  List<Order> orders = new List<Order>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text('Porudžbine na čekanju',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  color: Color(DARK_GREY),
                  fontWeight: FontWeight.w700)),
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        'https://ipfs.io/ipfs/QmSGWhMdUK9YXdfZBP6gKQozXxqBe4mcdSuhusPbVyZTCx',
                        height: 90,
                        width: 90,
                        fit: BoxFit.cover,
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pasirani paradajz (500g)',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: Color(BLACK),
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: 5),
                      Text('2.40 $CURRENCY',
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
                                  'x14',
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
                              Navigator.pop(context);
                            },
                            child: Text('Stranica proizvoda ->',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Colors.blue,
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
                              'Ime i prezime: Jay Ritter',
                              style: TextStyle(
                                  fontFamily: 'IBM Plex Mono',
                                  fontSize: 16,
                                  color: Color(BLACK)),
                            ),
                            SizedBox(height: 5),
                            Text('Kontakt telefon: +44/7911-123456',
                                style: TextStyle(
                                    fontFamily: 'IBM Plex Mono',
                                    fontSize: 16,
                                    color: Color(BLACK))),
                            SizedBox(height: 15),
                            Text(
                                'Adresa: Main Boulevard No. 214 26510 London, England',
                                style: TextStyle(
                                    fontFamily: 'IBM Plex Mono',
                                    fontSize: 16,
                                    color: Color(BLACK))),
                            SizedBox(height: 10),
                            Text('PLAĆANJE POUZEĆEM ',
                                style: TextStyle(
                                    fontFamily: 'IBM Plex Mono',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Color(
                                        BLACK))) // TODO insert payment method
                          ],
                        ),
                      )
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
                          color: Color(BLACK))),
                  Spacer(),
                  Text('33.60 $CURRENCY',
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new Scaffold(
                                        body: Center(
                                      child: Text('Porudžbina potvrđena'),
                                    ))));
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new Scaffold(
                                        body: Center(
                                      child: Text('Porudžbina otkazana'),
                                    ))));
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
        ),
      ),
    );
  }
}
