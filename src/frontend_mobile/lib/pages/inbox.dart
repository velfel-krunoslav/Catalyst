import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/widgets.dart';

class Inbox extends StatelessWidget {
  ChatUsers data;
  Inbox(ChatUsers data) {
    this.data = data;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Row(
                  children: [
                    IconButton(
                        icon: SvgPicture.asset("assets/icons/ArrowLeft.svg"),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    SizedBox(
                      width: 120,
                    ),
                    CircleAvatar(
                      maxRadius: 36,
                      child: CircleAvatar(
                        radius: 36,
                        backgroundImage: AssetImage(data.imageURL),
                      ),
                    ),
                    Text(data.name,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Inter'))
                  ],
                ),
              ),
            )),
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Color(LIGHT_GREY),
                child: Row(
                  children: <Widget>[
                    /*GestureDetector(
                      onTap: () {},
                    )*/
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: TextField(
                      decoration: InputDecoration(
                          hintText: "Unesi poruku...",
                          hintStyle: TextStyle(color: Color(DARK_GREY)),
                          border: InputBorder.none),
                    )),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.send,
                        color: Color(DARK_GREY),
                        size: 18,
                      ),
                      backgroundColor: Color(LIGHT_GREY),
                    ),
                    /* ListView.builder(
                      itemCount: messages.le,
                      itemBuilder: ),*/
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
