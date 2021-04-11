import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/internals.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:frontend_mobile/config.dart';

class Inbox extends StatefulWidget {
  @override
  _UserInboxState createState() => _UserInboxState();
}

class _UserInboxState extends State<Inbox> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            //padding: EdgeInsets.all(0),
            icon: SvgPicture.asset('assets/icons/ArrowLeft.svg'),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Poruke',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search, color: Colors.black),
              onPressed: () {
                //Navigator.pop(context);
              }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Color(LIGHT_GREY),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular((30.0)),
                      topRight: Radius.circular((30.0)))),
              child: Column(
                children: <Widget>[
                  Contacts(),
                  Chats(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
