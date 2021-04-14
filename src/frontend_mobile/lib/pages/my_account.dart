import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/widgets.dart';

class MyAccount extends StatelessWidget {
  User user;

  MyAccount({this.user});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My account",
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
        actions: [
          IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.black,
              ),
              onPressed: () {})
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Color(TEAL),
              child: CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage(
                    'assets/avatars/vendor_andrew_ballantyne_cc_by.jpg'),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Wrap(
          //       children: List.generate(user.rating.round(), (index) {
          //       return SvgPicture.asset("assets/icons/StarFilled.svg", color: Colors.yellow[700]);
          //     }),
          //     ),
          //     Wrap(
          //       children: List.generate(5 - user.rating.round(), (index) {
          //         return SvgPicture.asset("assets/icons/StarOutline.svg", color: Colors.yellow[700]);
          //       }),
          //     ),
          //     SizedBox(width: 10,),
          //     Text("("+user.reviewsCount.toString()+")")
          //   ],
          // ),
          SizedBox(
            height: 10,
          ),
          Center(
              child: Text(
            user.forename + " " + user.surname,
            style: TextStyle(
                fontFamily: "Inter", fontSize: 35, fontWeight: FontWeight.w500),
          )),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Text(
              user.about,
              style: TextStyle(fontFamily: "Inter", fontSize: 17),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 65, right: 65),
            child: ButtonOutline(
              onPressed: () {},
              text: "Moje ponude",
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: Container(
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  color: Color(LIGHT_GREY)),
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.mail_outline),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          user.mail,
                          style: TextStyle(fontFamily: "Inter", fontSize: 17),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(Icons.local_phone_outlined),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          user.phoneNumber,
                          style: TextStyle(fontFamily: "Inter", fontSize: 17),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_city_outlined),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          user.address + ", " + user.city,
                          style: TextStyle(fontFamily: "Inter", fontSize: 17),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
