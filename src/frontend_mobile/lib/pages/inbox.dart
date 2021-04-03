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
    );
  }
}
