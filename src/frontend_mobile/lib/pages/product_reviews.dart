import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/models/reviewsModel.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:provider/provider.dart';

const BACKGROUNDCOLOR = 0xFFE5E5E5;
const YELLOW = 0xFFE7A600; //added
const GREY = 0xFFC8C8C8; //added

class ProductReviews extends StatelessWidget {
  int productId = 0;
  var listModel;
  List<Review> reviews = [];


  @override
  Widget build(BuildContext context) {

    listModel = Provider.of<ReviewsModel>(context);

    var reviewsCount = 100;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: EdgeInsets.fromLTRB(20, 20, 0, 0)),
                  Row(
                    children: [
                      //Padding(padding: EdgeInsets.fromLTRB(20, 20, 0, 0)),
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset('assets/icons/ArrowLeft.svg',
                            //width: ICON_SIZE,
                            width: 28,
                            height: 28),
                      ),
                      Spacer(),
                      Text('Recenzije',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(DARK_GREY))),
                      Spacer()
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    "4.0",
                    style: TextStyle(
                        fontSize: 36,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              child: SvgPicture.asset(
                            'assets/icons/StarFilled.svg',
                            width: 16,
                            height: 16,
                            color: Color(YELLOW),
                          )),
                          Container(
                              child: SvgPicture.asset(
                            'assets/icons/StarFilled.svg',
                            width: 16,
                            height: 16,
                            color: Color(YELLOW),
                          )),
                          Container(
                              child: SvgPicture.asset(
                            'assets/icons/StarFilled.svg',
                            width: 16,
                            height: 16,
                            color: Color(YELLOW),
                          )),
                          Container(
                              child: SvgPicture.asset(
                            'assets/icons/StarFilled.svg',
                            width: 16,
                            height: 16,
                            color: Color(YELLOW),
                          )),
                          Container(
                              child: SvgPicture.asset(
                            'assets/icons/StarFilled.svg',
                            width: 16,
                            height: 16,
                            color: Color(GREY),
                          )),
                        ]),
                  ),
                  Text(
                    reviewsCount.toString() + " recenzija",
                    style: TextStyle(
                        fontFamily: 'Inter', fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Column(
                      children: [
                    [5, '33AE08', 180],
                    [4, '83AE08', 80],
                    [3, 'D7C205', 40],
                    [2, 'EA7E00', 30],
                    [1, 'DC3535', 30]
                  ].map((e) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              children: <Widget>[
                                    SizedBox(width: (5.0 - e[0]) * 16)
                                  ].toList() +
                                  List<Widget>.generate(e[0], (index) {
                                    return SvgPicture.asset(
                                        'assets/icons/StarFilled.svg',
                                        width: 16,
                                        height: 16);
                                  }).toList()),
                          SvgPicture.string('''
                          <svg width="260" height="5" />
                          <rect width="260" height="5" fill="#ECECEC">
                          <rect width="''' +
                              e[2].toString() +
                              '''" height="5" fill="#''' +
                              e[1] +
                              '''">
                        </svg>''')
                        ].toList());
                  }).toList()),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.fromLTRB(20, 20, 0, 0)),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Color(TEAL),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage(
                                  'assets/avatars/vendor_andrew_ballantyne_cc_by.jpg'),
                            )),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        children: [
                          Padding(
                              padding:
                                  EdgeInsets.only(left: 0, right: 16, top: 0)),
                          Text("Petar Nikolić",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black)),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Row(children: [
                              Container(
                                  child: SvgPicture.asset(
                                'assets/icons/StarFilled.svg',
                                width: 14,
                                height: 14,
                              )),
                              Container(
                                  child: SvgPicture.asset(
                                'assets/icons/StarFilled.svg',
                                width: 14,
                                height: 14,
                              )),
                              Container(
                                  child: SvgPicture.asset(
                                'assets/icons/StarFilled.svg',
                                width: 14,
                                height: 14,
                              )),
                              Container(
                                  child: SvgPicture.asset(
                                'assets/icons/StarFilled.svg',
                                width: 14,
                                height: 14,
                              )),
                              Container(
                                  child: SvgPicture.asset(
                                'assets/icons/StarFilled.svg',
                                width: 14,
                                height: 14,
                                color: Color(GREY),
                              )),
                            ]),
                          ),
                        ],
                      ),
                      SizedBox(
                          //height: 100,
                          ),
                      Spacer(),
                      Text("Pre 1 dan",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w800,
                              color: Color(DARK_GREY))),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
                    child: Container(
                        //width: 300,
                        child: Text(
                      "Nula dictum rhoncus turpis condimentium rutrum, Vivamus cursus rhoncus dolor eu varies. Donec orci leo, tempus a dui in, viverra fermentum urna.",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    )),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: [
                        SizedBox(height: 15.0),
                        ButtonOutline(
                          text: 'Ostavite recenziju',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new Container()),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

