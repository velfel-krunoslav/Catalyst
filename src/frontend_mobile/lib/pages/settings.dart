import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend_mobile/config.dart';
import '../widgets.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(LIGHT_GREY),
      appBar: AppBar(
        title: Text(
          "Podešavanja",
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(45, 40, 45, 30),
        child: Column(
          children: [
            SettingsOption(
              text: "Privatnost i bezbednost",
              icon: Icon(Icons.lock_outline),
              onPressed: () {},
            ),
            SizedBox(
              height: 20,
            ),
            SettingsOption(
              text: "Uslovi korišćenja",
              icon: Icon(Icons.branding_watermark_sharp),
              onPressed: () {},
            ),
            SizedBox(
              height: 20,
            ),
            SettingsOption(
              text: "Promenite lozinku",
              icon: Icon(Icons.screen_lock_rotation_outlined),
              onPressed: () {},
            ),
            SizedBox(
              height: 20,
            ),
            SettingsOption(
              text: "Plaćanje",
              icon: Icon(Icons.credit_card_outlined),
              onPressed: () {},
            ),
            SizedBox(
              height: 20,
            ),
            SettingsOption(
              text: "O aplikaciji",
              icon: Icon(Icons.description_outlined),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
