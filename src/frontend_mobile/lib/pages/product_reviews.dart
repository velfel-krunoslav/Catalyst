import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/widgets.dart';

const BACKGROUNDCOLOR = 0xFFE5E5E5;
const YELLOW = 0xFFE7A600; //added
const GREY = 0xFFC8C8C8; //added

class ProductReview extends StatelessWidget {
  ReviewPage data;
  ProductReview(ReviewPage data) {
    this.data = data;
  }
  @override
  Widget build(BuildContext context) {
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
                      IconButton(
                          icon: SvgPicture.asset("assets/icons/ArrowLeft.svg"),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      /*SvgPicture.asset('assets/icons/ArrowLeft.svg',
                          //width: ICON_SIZE,
                          width: 28,
                          height: 28),*/
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
                    data.average.toString(),
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
                          children: List.generate(data.average.toInt(),
                                  (index) {
                                return Container(
                                    child: SvgPicture.asset(
                                  'assets/icons/StarFilled.svg',
                                  width: 16,
                                  height: 16,
                                  color: Color(YELLOW),
                                ));
                              }).toList() +
                              List.generate(5 - data.average.toInt(), (index) {
                                return Container(
                                    child: SvgPicture.asset(
                                  'assets/icons/StarFilled.svg',
                                  width: 16,
                                  height: 16,
                                  color: Color(LIGHT_GREY),
                                ));
                              }).toList())),
                  Text(
                    data.reviewsCount.toString() + " recenzija",
                    style: TextStyle(
                        fontFamily: 'Inter', fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Column(
                      children: [
                    [
                      5,
                      '33AE08',
                      1.0 * data.stars[4] / data.reviewsCount * 260
                    ],
                    [
                      4,
                      '83AE08',
                      1.0 * data.stars[3] / data.reviewsCount * 260
                    ],
                    [
                      3,
                      'D7C205',
                      1.0 * data.stars[2] / data.reviewsCount * 260
                    ],
                    [
                      2,
                      'EA7E00',
                      1.0 * data.stars[1] / data.reviewsCount * 260
                    ],
                    [1, 'DC3535', 1.0 * data.stars[0] / data.reviewsCount * 260]
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
                  Column(
                    children: data.reviews.map((e) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                              ),
                              CircleAvatar(
                                  radius: 36,
                                  backgroundColor: Color(TEAL),
                                  child: CircleAvatar(
                                    radius: 36,
                                    backgroundImage: AssetImage(e.photoUrl),
                                  )),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    e.forename + ' ' + e.surname,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Row(
                                      children: List.generate(e.stars, (index) {
                                            return SvgPicture.asset(
                                              'assets/icons/StarFilled.svg',
                                              width: 14,
                                              height: 14,
                                            );
                                          }).toList() +
                                          List.generate(5 - e.stars, (index) {
                                            return SvgPicture.asset(
                                              'assets/icons/StarFilled.svg',
                                              width: 14,
                                              height: 14,
                                              color: Color(GREY),
                                            );
                                          }))
                                ],
                              ),
                              SizedBox(
                                width: 24,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Text(
                            e.text,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          )
                        ],
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  ButtonOutline(
                    text: 'Ostavite recenziju',
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class Reviews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
