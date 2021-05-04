import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend_mobile/config.dart';
import 'package:frontend_mobile/models/productsModel.dart';
import 'package:frontend_mobile/pages/consumer_home.dart';
import 'package:frontend_mobile/widgets.dart';
import 'package:provider/provider.dart';

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
            icon: SvgPicture.asset('assets/icons/ArrowLeft.svg'),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Poruke',
            style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(LIGHT_GREY),
              ),
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
